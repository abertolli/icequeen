{
	MPVIEW.PAS
	Map Viewer for Ice Queen
	Copyright (C) 1999-2005 Angelo Bertolli
}

program MapViewer;

uses crt, graph, graphio;

{$I h/game.pas}

var
     ch             :    char;
     loop           :    integer;
     device         :    integer;
     mode           :    integer;
     row            :    integer;
     col            :    integer;
     dosname        :    string;
     mapmap         :    matrix;
     mapcode        :    matrix;

{$I extras.pas}
{---------------------------------------------------------------------------}
procedure drawmaptile(xpos,ypos:integer;themap:matrix);

var
     xpix           :    integer;
     ypix           :    integer;
     tilenum        :    integer;
     filename       :    string;

begin
     xpix:=41;
     ypix:=41;
     xpix:=xpix + ((xpos - 1) * 20);         {tile size = 20}
     ypix:=ypix + ((ypos - 1) * 20);
     tilenum:=themap[xpos,ypos];
     case tilenum of
          1:filename:='town.bmp';
          2:filename:='cave.bmp';
          3:filename:='grass.bmp';
          4:filename:='hill.bmp';
          5:filename:='mountain.bmp';
          6:filename:='road.bmp';
          7:filename:='swamp.bmp';
          8:filename:='desert.bmp';
          9:filename:='whitemt.bmp';
          10:filename:='castle.bmp';
          11:filename:='snow.bmp';
          12:filename:='inn.bmp';
          13:filename:='ground.bmp';
          14:filename:='dgt.bmp';
          15:filename:='dww.bmp';
          16:filename:='dnw.bmp';
          17:filename:='dew.bmp';
          18:filename:='dsw.bmp';
          19:filename:='dnwc.bmp';
          20:filename:='dnsw.bmp';
          21:filename:='dsec.bmp';
          22:filename:='dnec.bmp';
          23:filename:='dswc.bmp';
          24:filename:='deww.bmp';
          25:filename:='dna.bmp';
          26:filename:='dea.bmp';
          27:filename:='dwa.bmp';
          28:filename:='dsa.bmp';
          29:filename:='blank.bmp';
     else
          filename:='blank.bmp';
     end;
     DrawPic(xpix,ypix,imagedir+filename);
end;
{---------------------------------------------------------------------------}
procedure drawmap(themap:matrix);

var
   row:byte;
   col:byte;

begin
     for row:=1 to rowmax do
          for col:=1 to colmax do
               drawmaptile(col,row,themap);
end;
{---------------------------------------------------------------------------}
procedure getmap(dosname:string;var themap:matrix);

var
     pasfile        :    file of matrix;

begin
     assign(pasfile,dosname);
     reset(pasfile);
     read(pasfile,themap);
     close(pasfile);
end;
{--------------------------------------------------------------------------}
procedure maplegend;

const
     tilemax   =    28;

var
     name      :    string;

begin

     gotoxy(30,2);
     write('              Map Legend');
     gotoxy(30,3);
     write('-------------------------------------');
     gotoxy(30,4);
     write('   SURFACE             DUNGEON');
     for loop:=1 to tilemax do
          begin
               if (loop<=12) then
                    gotoxy(30,loop+4)
               else
                    gotoxy(50,loop-8);
               if (loop<=9) then
                    write(loop,': ')
               else
                    write(chr(loop+55),': ');
               case loop of
                    1:name:='town';
                    2:name:='cave';
                    3:name:='grass';
                    4:name:='hill';
                    5:name:='mountain';
                    6:name:='road';
                    7:name:='swamp';
                    8:name:='desert';
                    9:name:='white mountain';
                    10:name:='castle';
                    11:name:='water/ice';
                    12:name:='inn';
                    13:name:='ground';
                    14:name:='gray tile';
                    15:name:='west wall';
                    16:name:='north wall';
                    17:name:='east wall';
                    18:name:='south wall';
                    19:name:='northwest corner';
                    20:name:='north-south walls';
                    21:name:='southeast corner';
                    22:name:='northeast corner';
                    23:name:='southwest corner';
                    24:name:='east-west walls';
                    25:name:='north alcove';
                    26:name:='east alcove';
                    27:name:='west alcove';
                    28:name:='south alcove';
                    29:name:='black tile';
               else
                    name:='error';
               end; {case}
               write(name);
          end;

end;
{--------------------------------------------------------------------------}
procedure codelegend;

const
     tilemax   =    28;

var
     name      :    string;

begin

     gotoxy(30,2);
     write('              Code Legend');
     gotoxy(30,3);
     write('-------------------------------------');
     gotoxy(30,4);
     for loop:=0 to tilemax do
          begin
               if (loop<=12) then
                    gotoxy(30,loop+5)
               else
                    gotoxy(50,loop-8);
               if (loop<=9) then
                    write(loop,': ')
               else
                    write(chr(loop+55),': ');
               case loop of
                    0:name:='open';
                    1:name:='blocked';
                    2:name:='road';
                    3:name:='town';
                    4:name:='inn';
                    5:name:='cave';
                    6:name:='dragon';
                    7:name:='password';
                    8:name:='castle';
                    9:name:='cave: sword';
                    10:name:='cave: shield';
                    11:name:='cave: library';
                    12:name:='cave: key';
                    13:name:='cave: staircase';
                    14:name:='cave: locked';
                    15:name:='dungeon: treasure';
                    16:name:='dungeon: trap';
                    17:name:='dungeon: frost lizard';
                    18:name:='stair down';
                    19:name:='stair up';
                    20:name:='castle: knight';
                    21:name:='castle: barracks';
                    22:name:='castle: courtyard';
                    23:name:='castle: guest';
                    24:name:='castle: banquet';
                    25:name:='castle: master';
                    26:name:='castle: kitchen';
                    27:name:='castle: throne';
                    28:name:='secret door';
               else
                    name:='error';
               end; {case}
               write(name);
          end;

end;
{--------------------------------------------------------------------------}

begin {main}
     clrscr;
     writeln('Ice Queen Map Viewer ',version);
     writeln;
     writeln;
     write('Enter map file name:  ');
     readln(dosname);
     while not(exist(dosname)) do
          begin
               writeln('File does not exist.');
               write('enter map file name:  ');
               readln(dosname);
          end;
     getmap(mapdir+dosname,mapmap);
     write('Enter code file name:  ');

     readln(dosname);
     while not(exist(dosname)) do
          begin
               writeln('File does not exist.');
               write('enter code file name:  ');
               readln(dosname);
          end;
     getmap(mapdir+dosname,mapcode);
     writeln;
     writeln('Map and Code loaded.  Press <Enter> to continue.');
     readln;
     clrscr;
     writeln;
     writeln('     The Map');
     writeln('     -------');
     writeln;
     for row:=1 to rowmax do
          begin
               for col:=1 to colmax do
                    if (mapmap[col,row]<=9) then
                         write(mapmap[col,row])
                    else
                         begin
                              write(chr(mapmap[col,row]+55));
                         end;
               writeln;
          end;
     writeln;
     writeln;
     writeln;
     writeln;
     writeln('Press <Enter> to continue.');
     maplegend;
     readln;
     clrscr;
     writeln;
     writeln('    The Code');
     writeln('    --------');
     writeln;
     for row:=1 to rowmax do
          begin
               for col:=1 to colmax do
                    if (mapcode[col,row]<=9) then
                         write(mapcode[col,row])
                    else
                         begin
                              write(chr(mapcode[col,row]+55));
                         end;
               writeln;
          end;
     writeln;
     writeln;
     writeln;
     writeln('Map Viewer Done.');
     writeln;
     writeln('Would you like to view the map in graphics mode? (y/n)');
     codelegend;
     repeat
          ch:=readkey;
     until (ch in ['y','Y','n','N']);
     if (ch in ['y','Y']) then
          begin
               graph_init(device,mode,'c:\tp\bgi');
               drawmap(mapmap);
               ch:=readkey;
               closegraph;
          end;

     textmode(CO40);
     textcolor(black);
     textbackground(white);
     clrscr;
     for row:=1 to rowmax do
          begin
               for col:=1 to colmax do
                    if (mapcode[col,row]=0) then
                         write(' ')
                    else
                         if (mapcode[col,row]=1) then
                              write(chr(219))
                         else
                              if (mapcode[col,row]>9) then
                                   write(chr(mapcode[col,row]+55))
                              else
                                   write(mapcode[col,row]);
               writeln;
          end;
     ch:=readkey;

     textmode(CO80);
     writeln('Goodbye.');

end. {main}
