{
Monster Chart Viewer for Ice Queen
Copyright (C) 1999-2005 Angelo Bertolli

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

Angelo Bertolli <angelo.bertoli@gmail.com>
}

program MonsterChartViewer;

uses crt;

{$I h/game.pas}
{$I h/monster.pas}
{$I h/encounter.pas}

var
     ch             :    char;
     int            :    integer;
     loop           :    integer;
     chart          :    chartrecord;
     dosname        :    string;
     pasfile        :    file of chartrecord;
     maxmon         :    integer;

{$I extras.pas}
{--------------------------------------------------------------------------}


begin {main}
  repeat
     clrscr;
     writeln('Ice Queen Monster Chart Viewer ',version);
     writeln;
     writeln;
     write('Enter Chart File Name:  ');
     readln(dosname);
     while not(exist(CHT_DIR+dosname)) do
          begin
               writeln('File does not exist.');
               write('Quit? (y/n)');
               repeat
                    ch:=readkey;
               until (ch in ['n','N','y','Y']);
               if (ch in ['y','Y']) then
                    halt;
               write('Enter Chart File Name:  ');
               readln(dosname);
          end;
     assign(pasfile,CHT_DIR+dosname);
     reset(pasfile);
     read(pasfile,chart);
     close(pasfile);
     writeln('Chart Loaded, press any key to continue.');
     ch:=readkey;

     clrscr;
     writeln;
     writeln;
     maxmon:=0;
     with chart do
          begin
               with diceroll do
                    writeln('Roll:  ':60,rollnum,'d',dicetype,'+',bonus);
               writeln('Result':8,'Filename':18,'No.':16);
               maxmon:=diceroll.rollnum*diceroll.dicetype+diceroll.bonus;
               for loop:=1 to maxmon do
                    begin
                         write(value[loop,1]:4,value[loop,2]:4,
                               filename[loop]:20);
                         with number[loop] do
                              writeln(rollnum:10,'d',dicetype,'+',bonus);
                    end;
          end;
     writeln('Done.':60);
     writeln('<Enter> to continue, <ESC> to quit.');
     repeat
          ch:=readkey;
     until (ch in [#13,#27]);

  until (ch in [#27]);
end. {main}
