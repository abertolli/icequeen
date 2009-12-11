{
Map Viewer for Ice Queen
Copyright (C) 2001 Angelo Bertolli

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

Angelo Bertolli
<angelo.bertolli@gmail.com>
}

program MapViewer;

uses crt, graph, graphio, ice;

const
     version        =    'v2.1';

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
