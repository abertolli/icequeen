{
Monster Chart Creator for Ice Queen
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

program MonsterChartCreator;

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
     goahead        :    boolean;
     nummonstermax  :    word;

{$I extras.pas}
{--------------------------------------------------------------------------}


begin {main}
  repeat
     clrscr;
     writeln('Ice Queen Monster Chart Creator ',version);
     writeln;
     writeln;
     with chart do
          begin
               with diceroll do
                    begin
                         writeln('Dice Roll = <rollnum>d<dicetype>+<bonus>');
                         writeln('(max 20 monsters)');
                         write('     rollnum:  ');
                         readln(rollnum);
                         write('     dicetype:  ');
                         readln(dicetype);
                         write('     bonus:  ');
                         readln(bonus);
                         nummonstermax:=rollnum*dicetype+bonus;
                    end;
               if (nummonstermax>20) then
                    nummonstermax:=20;
               for loop:=1 to nummonstermax do
                    begin
                         writeln;
                         writeln('MONSTER ',loop,' of ',nummonstermax);
                         write('Enter monster file (eg. kobold.dat):  ');
                         readln(filename[loop]);
                         with number[loop] do
                              begin
                                   writeln('No. Appearing = <rollnum>d<dicetype>+<bonus>');
                                   write('     rollnum:  ');
                                   readln(rollnum);
                                   write('     dicetype:  ');
                                   readln(dicetype);
                                   write('     bonus:  ');
                                   readln(bonus);
                              end;
                         writeln('Enter value range (inclusive)');
                         write('Starting Value (from):  ');
                         readln(value[loop,1]);
                         write('Ending Value (to):  ');
                         readln(value[loop,2]);

                    end;
          end;
     writeln;
     writeln;

     write('Enter Save File Name:  ');
     readln(dosname);
     goahead:=false;
     if exist(chartdir+dosname) then
          begin
               writeln('File exists.');
               writeln('Overwrite? (y/n)');
               repeat
                    ch:=readkey;
               until (ch in ['n','N','y','Y']);
               if (ch in ['y','Y']) then
                    goahead:=true;

          end
     else
          goahead:=true;
     if goahead then
          begin
               assign(pasfile,chartdir+dosname);
               rewrite(pasfile);
               write(pasfile,chart);
               close(pasfile);
               writeln('Saved.');
          end;
     writeln('<Enter> to continue, <ESC> to quit.');
     repeat
           ch:=readkey;
     until (ch in [#13,#27]);
  until (ch in [#27]);

end. {main}
