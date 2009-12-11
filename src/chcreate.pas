{
Character Creator for Ice Queen
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

program CharacterCreator;

uses crt;

{$I h/game.pas}
{$I h/character.pas}

var
     ch             :    char;
     int            :    integer;
     loop           :    integer;
     player         :    playerrecord;
     dosname        :    string;
     pasfile        :    file of playerrecord;
     goahead        :    boolean;

{--------------------------------------------------------------------------}
function exist(dosname:string) : boolean;

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
{--------------------------------------------------------------------------}


begin {main}
     clrscr;
     writeln('Ice Queen Character Creator ',version);
     writeln;
     writeln;
     with player do
          begin
               write('Enter character name [Landon]:  ');
               readln(name);
               if(name='')then
                    name:='Landon';
               write('Character picture file [mplayer.bmp]:  ');
               readln(picfile);
               if(picfile='')then
                    picfile:='mplayer.bmp';
               write('Gender [m]:  ');
               readln(sex);
               if not(sex in ['f','F'])then
                    sex:='m';
               write('Strength (1-20):  ');
               readln(strength);
               if not(strength in [1..20]) then
                    strength:=10;
               write('Dexterity (1-20):  ');
               readln(dexterity);
               if not(dexterity in [1..20]) then
                    dexterity:=10;
               write('Level (1-12):  ');
               readln(level);
               if not(level in [1..12]) then
                    level:=1;
               write('Endurance (1-99):  ');
               readln(endurance);
               if not(endurance in [1..99]) then
                    endurance:=level * 8;
               endurancemax:=endurance;
               armorclass:=0;
               thac0:=0;
               with damage do
                    begin
                         rollnum:=0;
                         dicetype:=0;
                         bonus:=0;
                    end;
               savingthrow:=0;
               write('Experience (0-600000):  ');
               readln(experience);
               if(experience<0)then
                    experience:=0;
               write('Coins (0..9999):  ');
               readln(coins);
               if(coins<0)then
                    coins:=0;
               writeln('ITEMS');
               writeln('1)sword, 2)shield, 3)axe, 4)blue potion,');
               writeln('5)red potion, 6)green potion, 7)chain mail,');
               writeln('8)plate mail, 9)dagger, 10)club, 11)staff,');
               writeln('12)hammer, 13)magic sword, 14)magic shield,');
               writeln('15)flame wand');
               write('Number of items (0-9):  ');
               readln(numitems);
               if not(numitems in [0..9]) then
                    numitems:=0;
               for loop:=1 to numitems do
                    begin
                         write('ITEM ',loop,':  ');
                         readln(int);
                         case int of
                              2:item[loop]:=shield;
                              3:item[loop]:=axe;
                              4:item[loop]:=bluepotion;
                              5:item[loop]:=redpotion;
                              6:item[loop]:=greenpotion;
                              7:item[loop]:=chainmail;
                              8:item[loop]:=platemail;
                              9:item[loop]:=dagger;
                             10:item[loop]:=club;
                             11:item[loop]:=staff;
                             12:item[loop]:=hammer;
                             13:item[loop]:=magicsword;
                             14:item[loop]:=magicshield;
                             15:item[loop]:=flamewand;
                         else
                              item[loop]:=sword;
                         end;{case}
                    end;
               writeln('SPELLS');
               writeln('1)ice storm, 2)fire blast, 3)web, 4)call wild, 5)heal');
               writeln('6)courage, 7)freeze, 8)obliterate, 9)icicle,');
               writeln('10)power, 11)shatter, 12)glacier, 13)dragon breath,');
               writeln('14)resist fire, 15)resist cold');
               write('Number of spells (0-8):  ');
               readln(numspells);
               if not(numspells in [0..8]) then
                    numspells:=0;
               for loop:=1 to numspells do
                    begin
                         write('spell ',loop,':  ');
                         readln(int);
                         case int of
                              2:spell[loop]:=fireblast;
                              3:spell[loop]:=web;
                              4:spell[loop]:=callwild;
                              5:spell[loop]:=heal;
                              6:spell[loop]:=courage;
                              7:spell[loop]:=freeze;
                              8:spell[loop]:=obliterate;
                              9:spell[loop]:=icicle;
                             10:spell[loop]:=power;
                             11:spell[loop]:=shatter;
                             12:spell[loop]:=glacier;
                             13:spell[loop]:=dragonbreath;
                             14:spell[loop]:=resistfire;
                             15:spell[loop]:=resistcold;
                         else
                              spell[loop]:=icestorm;
                         end;{case}
                    end;
               stages:=[];
               if (numspells>0) then
                    begin
                        stages:=stages + [ring];
                        write('Number of charges in the ring (max ',
                              ringmax,') :  ');
                        readln(chargemax);
                        if(chargemax>ringmax)then
                             chargemax:=ringmax;
                        charges:=chargemax;
                    end;
          end;
     writeln;
     writeln;

     write('Enter Save File Name:  ');
     readln(dosname);
     if exist(SAV_DIR+dosname) then
          begin
               writeln('File exists.');
               writeln('Overwrite? (y/n)');
               repeat
                    ch:=readkey;
               until (ch in ['n','N','y','Y']);
               if (ch in ['y','Y']) then
                    goahead:=true
               else
                    goahead:=false;
          end
     else
          goahead:=true;
     if goahead then
          begin
               assign(pasfile,SAV_DIR+dosname);
               rewrite(pasfile);
               write(pasfile,player);
               close(pasfile);
               writeln('Saved.');
               ch:=readkey;
          end
     else
          writeln('Bye.');

end. {main}
