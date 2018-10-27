{
	MPCREATE.PAS
	Map Creator for Ice Queen
	Copyright (C) 1999-2005 Angelo Bertolli
}

program MapCreator;

uses crt, dataio;

const
{$I const.inc}

var
     ch             :    char;
     loop           :    integer;
     row            :    integer;
     col            :    integer;
     map            :    matrix;
     ans            :    char;
     quit           :    boolean;

{--------------------------------------------------------------------------}
procedure initmap(var map:matrix);

begin
     for row:=1 to rowmax do
          for col:=1 to colmax do
               map[col,row]:=1;
end;
{---------------------------------------------------------------------------}
procedure makewindow(beginx,beginy,endx,endy:integer);

begin
     window(1,1,80,25);
     for loop:=beginx to endx do
          begin
               gotoxy(loop,beginy - 1);
               write('-');
               gotoxy(loop,endy + 1);
               write('-');
          end;
     for loop:=beginy to endy do
          begin
               gotoxy(beginx - 1,loop);
               write('|');
               gotoxy(endx + 1,loop);
               write('|');
          end;
     gotoxy(beginx-1,beginy-1);
     write('/');
     gotoxy(beginx-1,endy+1);
     write('\');
     gotoxy(endx+1,beginy-1);
     write('\');
     gotoxy(endx+1,endy+1);
     write('/');
     window(beginx,beginy,endx,endy);
end;
{--------------------------------------------------------------------------}
procedure drawmap(map:matrix);

begin
     makewindow(2,2,colmax+3,rowmax+3);
     textcolor(red);
     write(' ');
     for loop:=1 to colmax do
          if (loop<=9) then
               write(loop)
          else
               write(chr(loop+55));
     textcolor(lightgray);
     writeln;
     for row:=1 to rowmax do
          begin
               textcolor(red);
               if (row<=9) then
                    write(row)
               else
                    write(chr(row+55));
               textcolor(lightgray);
               for col:=1 to colmax do
                    if (map[col,row]<=9) then
                         write(map[col,row])
                    else
                         write(chr(map[col,row]+55));
               writeln;
          end;
end;
{--------------------------------------------------------------------------}
procedure maplegend;

const
     tilemax   =    29;

var
     name      :    string;

begin

     writeln('              Map Legend');
     writeln('-------------------------------------');
     writeln('   SURFACE             DUNGEON');
     for loop:=1 to tilemax do
          begin
               if (loop<=13) then
                    gotoxy(1,loop+4)
               else
                    gotoxy(20,loop-9);
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
                    29:name:='blank';
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

     writeln('              Code Legend');
     writeln('-------------------------------------');
     for loop:=0 to tilemax do
          begin
               if (loop<=12) then
                    gotoxy(3,loop+4)
               else
                    gotoxy(22,loop-9);
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
procedure setscreen(map:matrix;ch:char);

begin

     drawmap(map);
     makewindow(30,2,74,24);
     if (ch in ['m','M']) then
          maplegend
     else
          codelegend;
     makewindow(2,rowmax+6,27,24);
     clrscr;
end;
{--------------------------------------------------------------------------}
procedure rewritemap(var map:matrix);

var
     num       :    integer;
     errcode   :    integer;


begin
     writeln('Enter all map codes (0-Z)');
     drawmap(map);
     window(3,3,colmax+3,rowmax+3);
     clrscr;
     for row:=1 to rowmax do
          begin
               for col:=1 to colmax do
                    begin
                         repeat
                              ans:=readkey;
                              ans:=upcase(ans);
                         until (ans in ['0'..'9','A'..'Z']);
                         write(ans);
                         if (ans in ['0'..'9']) then
                              val(ans,num,errcode)
                         else
                              num:=ord(ans)-55;
                         map[col,row]:=num;
                    end;
               writeln;
          end;
     makewindow(2,rowmax+6,27,24);
     writeln;
     writeln;
     write('Done.  Press a key.');
     ans:=readkey;
end;
{--------------------------------------------------------------------------}
procedure replacemap(var map:matrix);

var
     errcode   :    integer;
     num       :    integer;

begin
     write('Column (1-K): ');
     repeat
          ans:=readkey;
          ans:=upcase(ans);
     until (ans in ['1'..'9','A'..'K']);
     write(ans);
     if (ans in ['1'..'9']) then
          val(ans,col,errcode)
     else
          col:=ord(ans)-55;

     write('Row (1-E): ');
     repeat
          ans:=readkey;
          ans:=upcase(ans);
     until (ans in ['1'..'9','A'..'E']);
     write(ans);
     if (ans in ['1'..'9']) then
          val(ans,row,errcode)
     else
          row:=ord(ans)-55;

     write('From Legend (0-Z): ');
     repeat
          ans:=readkey;
          ans:=upcase(ans);
     until (ans in ['0'..'9','A'..'Z']);
     write(ans);
     if (ans in ['0'..'9']) then
          val(ans,num,errcode)
     else
          num:=ord(ans)-55;

     map[col,row]:=num;

end;
{--------------------------------------------------------------------------}
procedure savemap(var map:matrix);

const
     mapdir    =    'game/';

var
     dosname   :    string;
     pasfile   :    file of matrix;
     textfile  :    text;

begin
     write('Load or Save (L/S)');
     repeat
           ans:=readkey;
     until (ans in ['l','L','s','S']);
     writeln;
     if (ans in ['l','L']) then
          begin
               write('Load filename: ');
               readln(dosname);
               while not(exist(mapdir+dosname)) do
                    begin
                         writeln('File not found.');
                         write('Load filename: ');
                         readln(dosname);
                    end;
               assign(pasfile,mapdir+dosname);
               reset(pasfile);
               read(pasfile,map);
               close(pasfile);
          end
     else
          begin
               write('Save filename: ');
               readln(dosname);
               if (exist(mapdir+dosname)) then
                    begin
                         writeln('File exists.');
                         write('Overwrite (y/n)');
                         repeat
                              ans:=readkey;
                         until (ans in ['y','Y','n','N']);
                    end;
               if (ans in ['y','Y']) or not(exist(mapdir+dosname)) then
                    begin
                         assign(textfile,mapdir+dosname);
                         rewrite(textfile);
			 for row:=1 to rowmax do
			 begin
				for col:=1 to colmax do
					write(textfile,' ',map[col,row]);
			 	writeln(textfile);
			 end;
                         close(textfile);
                    end;
          end;
     writeln;
     write('Hit any key to continue');
     ans:=readkey;
end;
{--------------------------------------------------------------------------}


begin {main}
     clrscr;
     writeln('Ice Queen Map Creator ',version);
     writeln;
     writeln;
     write('Create Map or Code:  (M/C)');
     initmap(map);
     repeat
          ch:=readkey;
     until (ch in ['m','M','c','C']);
     clrscr;
     repeat
          setscreen(map,ch);
          writeln('1) rewrite entire map');
          writeln('2) replace one tile');
          writeln('3) load/save map');
          writeln('4) quit');
          repeat
               ans:=readkey;
          until (ans in ['1'..'4']);
          quit:=(ans='4');
          clrscr;
          case ans of
               '1':rewritemap(map);
               '2':replacemap(map);
               '3':savemap(map);
          end;{case}
     until (quit);
     writeln('Goodbye.');

end. {main}
