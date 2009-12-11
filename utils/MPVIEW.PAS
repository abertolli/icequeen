program MapViewer;

uses crt,graph;

const
     version        =    'v1.0';

     {used for graphics text}
     default        =    0;
     triplex        =    1;
     small          =    2;
     sanseri        =    3;
     gothic         =    4;
     horizontal     =    0;
     vertical       =    1;

     {used for maps}
     rowmax         =    14;       {number of rows on a map}
     colmax         =    20;       {number of columns on a map}


type
     stringtype     =    string[20];
     matrix         =    array[1..colmax,1..rowmax] of integer;

var
     ch             :    char;
     loop           :    integer;
     device         :    integer;
     mode           :    integer;
     row            :    integer;
     col            :    integer;
     dosname        :    stringtype;
     mapmap         :    matrix;
     mapcode        :    matrix;

{--------------------------------------------------------------------------}
procedure gfilesloc(var gdriver,gmode:integer;gpath:string);

{Used to locate the graphics files.}

var
     error          :    integer;

begin
     clrscr;
     repeat
          gdriver:=detect;
          initgraph(gdriver,gmode,gpath);
          error:=graphresult;
          if(error<>grOK)then
               begin
                    writeln('Graphics error:  ',grapherrormsg(error));
                    if(error=grfilenotfound)then
                         begin
                              writeln;
                              writeln('     Cannot find graphics driver.');
                              write('     Please enter directory path for the driver:  ');
                              readln(gpath);
                              writeln;
                         end
                    else
                         halt(1);
               end;
     until(error=grOK);
end;
{--------------------------------------------------------------------------}
function exist(dosname:stringtype) : boolean;

var
     pasfile        :   text;

begin
     {$I-}
     assign(pasfile,dosname);
     reset(pasfile);
     close(pasfile);
     {$I+}
     exist:=(IoResult=0);
end;
{---------------------------------------------------------------------------}
procedure getmap(dosname:stringtype;var themap:matrix);

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
     name      :    stringtype;

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
     name      :    stringtype;

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
                    15:name:='dungeon: stair 1';
                    16:name:='dungeon: stair 2';
                    17:name:='dungeon: frost lizard';
                    18:name:='castle: stair 1';
                    19:name:='castle: stair 2';
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
{-------------------------------------------------------------------------}
procedure DRAWPICTUREBYLINE(beginx,beginy:integer;dosname:stringtype);

{dosname            =    name of the file, including extention
beginx, beginy      =    the coordinates of where the upper left hand corner
                         of where the picture will be.}

var
     pasfile        :    text;
     row            :    integer;
     col            :    integer;
     color          :    integer;
     length         :    integer;
     lineoftext     :    string[100];
     savename       :    stringtype;

begin

     savename:='';
     if not(exist(dosname)) then
          begin
               savename:=dosname;
               dosname:='nophoto.ln1';
          end;
     assign(pasfile,dosname);
     reset(pasfile);
     readln(pasfile,lineoftext);
     if(lineoftext='FORMAT=LINE')then
          begin
               row:=beginy;
               col:=beginx;
               while not eof(pasfile) do
                    begin
                         while not eoln(pasfile) do
                              begin
                                   read(pasfile,color);
                                   read(pasfile,ch);
                                   read(pasfile,length);
                                   if not eoln(pasfile) then
                                        read(pasfile,ch);
                                   setcolor(color);
                                   line(col,row,(col+length),row);
                                   col:=col + length;
                              end;
                         readln(pasfile);
                         row:=row + 1;
                         col:=beginx;
                    end;
          end;
     close(pasfile);
     if (savename<>'') then
          begin
               setcolor(lightblue);
               settextstyle(default,horizontal,1);
               outtextxy(beginx+15,beginy+20,savename);
          end;

end;
{---------------------------------------------------------------------------}
procedure drawmaptile(xpos,ypos:integer;themap:matrix);

var
     xpix           :    integer;
     ypix           :    integer;
     tilenum        :    integer;
     filename       :    stringtype;

begin
     xpix:=41;
     ypix:=41;
     xpix:=xpix + ((xpos - 1) * 20);         {tile size = 20}
     ypix:=ypix + ((ypos - 1) * 20);
     tilenum:=themap[xpos,ypos];
     case tilenum of
          1:filename:='town.ln1';
          2:filename:='cave.ln1';
          3:filename:='grass.ln1';
          4:filename:='hill.ln1';
          5:filename:='mountain.ln1';
          6:filename:='road.ln1';
          7:filename:='swamp.ln1';
          8:filename:='desert.ln1';
          9:filename:='whitemt.ln1';
          10:filename:='castle.ln1';
          11:filename:='snow.ln1';
          12:filename:='inn.ln1';
          13:filename:='ground.ln1';
          14:filename:='dgt.ln1';
          15:filename:='dww.ln1';
          16:filename:='dnw.ln1';
          17:filename:='dew.ln1';
          18:filename:='dsw.ln1';
          19:filename:='dnwc.ln1';
          20:filename:='dnsw.ln1';
          21:filename:='dsec.ln1';
          22:filename:='dnec.ln1';
          23:filename:='dswc.ln1';
          24:filename:='deww.ln1';
          25:filename:='dna.ln1';
          26:filename:='dea.ln1';
          27:filename:='dwa.ln1';
          28:filename:='dsa.ln1';
          29:filename:='blank.ln1';
     else
          filename:='blank.ln1';
     end;
     drawpicturebyline(xpix,ypix,filename);
end;
{---------------------------------------------------------------------------}
procedure drawmap(themap:matrix);

begin
     for row:=1 to rowmax do
          for col:=1 to colmax do
               drawmaptile(col,row,themap);
end;
{--------------------------------------------------------------------------}


begin {main}
     clrscr;
     writeln('Ice Queen Map Viewer v1.0');
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
     getmap(dosname,mapmap);
     write('Enter code file name:  ');
     readln(dosname);
     while not(exist(dosname)) do
          begin
               writeln('File does not exist.');
               write('enter code file name:  ');
               readln(dosname);
          end;
     getmap(dosname,mapcode);
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
               gfilesloc(device,mode,'c:\tp\bgi');
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
