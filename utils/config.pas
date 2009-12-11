{
Configurator for Ice Queen
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

program Config;

{Allows you to reset the configuration settings.}

uses crt;

const
     version        =    'v2.1';

{$I global.pas}

var
     ch             :    char;
     ans            :    char;
     loop           :    integer;
     configuration  :    configrecord;
     pasfile        :    file of configrecord;

begin {main}

     clrscr;
     gotoxy(75,1);
     writeln(version);
     writeln('Ice Queen Configuration Tool');
     writeln('----------------------------');
     writeln('Just hit <enter> for the default (on things you don''t want to change).');
     writeln;
     with configuration do
          begin
               write('Surface map [surface.map]: ');
               readln(surfacemap);
               if (surfacemap='') then surfacemap:='surface.map';

               write('Surface code [surface.cod]: ');
               readln(surfacecode);
               if (surfacecode='') then surfacecode:='surface.cod';

               write('Cave map [cave.map]: ');
               readln(cavemap);
               if (cavemap='') then cavemap:='cave.map';

               write('Cave code [cave.cod]: ');
               readln(cavecode);
               if (cavecode='') then cavecode:='cave.cod';

               write('Castle map [castle.map]: ');
               readln(castlemap);
               if (castlemap='') then castlemap:='castle.map';

               write('Castle code [castle.cod]: ');
               readln(castlecode);
               if (castlecode='') then castlecode:='castle.cod';

               write('Dungeon map [dungeon.map]: ');
               readln(dungeonmap);
               if (dungeonmap='') then dungeonmap:='dungeon.map';

               write('Dungeon code [dungeon.cod]: ');
               readln(dungeoncode);
               if (dungeoncode='') then dungeoncode:='dungeon.cod';

               write('Wilderness monster chart [wild.dat]: ');
               readln(wildchart);
               if (wildchart='') then wildchart:='wild.dat';

               write('Cave monster chart [cave.dat]: ');
               readln(cavechart);
               if (cavechart='') then cavechart:='cave.dat';

               write('Dungeon monster chart [dungeon.dat]: ');
               readln(dungeonchart);
               if (dungeonchart='') then dungeonchart:='dungeon.dat';

               write('Castle monster chart [castle.dat]: ');
               readln(castlechart);
               if (castlechart='') then castlechart:='castle.dat';

               write('Left title picture [msoldier.ln1]: ');
               readln(leftpic);
               if (leftpic='') then leftpic:='msoldier.ln1';

               write('Right title picture [landon.ln1]: ');
               readln(rightpic);
               if (rightpic='') then rightpic:='landon.ln1';

               write('Character tile [chartile.ln1]: ');
               readln(chartile);
               if (chartile='') then chartile:='chartile.ln1';

               write('Default save game [game.sav]: ');
               readln(savegame);
               if (savegame='') then savegame:='game.sav';
          end;
     writeln;
     assign(pasfile,configfile);
     rewrite(pasfile);
     write(pasfile,configuration);
     close(pasfile);
     writeln('Done.');

end. {main}
