{
Character Converter from Ice Queen version 1.1 to Ice Queen version 2.1
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

program CharacterConverter;

uses crt,graph;

const

     version        =    'v2.1';   {give xp for coins, protection vs breaking
                                    into the old save files (max limits)}
{$I global.pas}

type
     oldrecord      =    record
                              name           :    stringtype;
                              picfile        :    stringtype;
                              sex            :    char;
                              endurance      :    word;
                              endurancemax   :    word;
                              experience     :    longint;
                              coins          :    longint;
                              numitems       :    byte;
                              item           :    array[1..itemmax] of byte;
                              numspells      :    byte;
                              spell          :    array[1..spellmax] of byte;
                              combatskill    :    byte;
                              luck           :    byte;
                              charges        :    byte;
                              chargemax      :    byte;
                         end;

var
     ch             :    char;
     loop           :    integer;
     player         :    playerrecord;
     oldplayer      :    oldrecord;
     oldfile        :    text;
     newfile        :    file of playerrecord;
     dosname        :    stringtype;
     found          :    boolean;
     spot           :    integer;
     firstline      :    stringtype;

{--------------------------------------------------------------------------}
function exist(dosname:stringtype) : boolean;

{Returns TRUE if the file exists.}

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
function D(dnum:integer):integer; begin d:=random(dnum)+1; end;

{The value of d(dnum) is returned as a random number between 1 and dnum.}
{---------------------------------------------------------------------------}
procedure calcstats(var player:playerrecord);

{Calculates the player stats based on level, xp, etc. and returns it.}

type
    itemset     = set of item;

var
     tempset        :    itemset;
     tempinteger    :    integer;
     count          :    integer;

begin
     with player do
          begin
               if(level=1)and(experience>=2000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=2)and(experience>=4000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=3)and(experience>=8000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=4)and(experience>=16000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=5)and(experience>=32000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=6)and(experience>=64000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=7)and(experience>=120000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=8)and(experience>=240000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=9)and(experience>=360000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=10)and(experience>=480000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               if(level=11)and(experience>=600000)then
                    begin
                         level:=level + 1;
                         tempinteger:=d(8);
                         endurancemax:=endurancemax+tempinteger;
                         endurance:=endurance+tempinteger;
                    end;
               case level of
                 1..3:savingthrow:=16;
                 4..6:savingthrow:=14;
                 7..9:savingthrow:=12;
               else
                    savingthrow:=10;
               end;{case}
               case level of
                 1..3:thac0:=19;
                 4..6:thac0:=17;
                 7..9:thac0:=15;
               else
                    thac0:=13;
               end;{case}
               case strength of
                    1:thac0:=thac0+8;
                    2:thac0:=thac0+5;
                    3:thac0:=thac0+3;
                 4..5:thac0:=thac0+2;
                 6..8:thac0:=thac0+1;
               13..15:thac0:=thac0-1;
               16..17:thac0:=thac0-2;
                   18:thac0:=thac0-3;
                   19:thac0:=thac0-5;
                   20:thac0:=thac0-8;
               end;{case}
               tempset:=[];
               for count:=1 to numitems do
                    tempset:=tempset + [item[count]];
               armorclass:=9;
               if(magicshield in tempset)then
                    armorclass:=armorclass-4
               else
                    if(shield in tempset)then
                         armorclass:=armorclass-1;
               if(platemail in tempset)then
                    armorclass:=armorclass-6
               else
                    if(chainmail in tempset)then
                         armorclass:=armorclass-4;
               case dexterity of
                    1:armorclass:=armorclass+8;
                    2:armorclass:=armorclass+5;
                    3:armorclass:=armorclass+3;
                 4..5:armorclass:=armorclass+2;
                 6..8:armorclass:=armorclass+1;
               13..15:armorclass:=armorclass-1;
               16..17:armorclass:=armorclass-2;
                   18:armorclass:=armorclass-3;
                   19:armorclass:=armorclass-5;
                   20:armorclass:=armorclass-8;
               end;{case}
               damage.rollnum:=1;
               damage.dicetype:=2;
               damage.bonus:=0;
               if (club in tempset)or(dagger in tempset) then
                    damage.dicetype:=4;
               if (hammer in tempset)or(staff in tempset) then
                    damage.dicetype:=6;
               if (axe in tempset)or(sword in tempset) then
                    damage.dicetype:=8;
               if(magicsword in tempset)then
                    begin
                         damage.dicetype:=8;
                         damage.bonus:=3;
                         if not(flamewand in tempset)then
                              thac0:=thac0-3;
                    end;
               if (flamewand in tempset) then
                    begin
                         damage.rollnum:=6;
                         damage.dicetype:=6;
                         damage.bonus:=0;
                    end;
               if not(flamewand in tempset) then
                    case strength of
                         1:damage.bonus:=damage.bonus-8;
                         2:damage.bonus:=damage.bonus-5;
                         3:damage.bonus:=damage.bonus-3;
                      4..5:damage.bonus:=damage.bonus-2;
                      6..8:damage.bonus:=damage.bonus-1;
                    13..15:damage.bonus:=damage.bonus+1;
                    16..17:damage.bonus:=damage.bonus+2;
                        18:damage.bonus:=damage.bonus+3;
                        19:damage.bonus:=damage.bonus+5;
                        20:damage.bonus:=damage.bonus+8;
                    end;{case}
          end;
end;
{---------------------------------------------------------------------------}
function itemstring(theitem:item):stringtype;

begin
     case theitem of
          sword          :itemstring:='sword';
          shield         :itemstring:='shield';
          axe            :itemstring:='axe';
          bluepotion     :itemstring:='blue potion';
          redpotion      :itemstring:='red potion';
          greenpotion    :itemstring:='green potion';
          chainmail      :itemstring:='chain mail';
          platemail      :itemstring:='plate mail';
          dagger         :itemstring:='dagger';
          club           :itemstring:='club';
          staff          :itemstring:='staff';
          hammer         :itemstring:='hammer';
          magicsword     :itemstring:='magic sword';
          magicshield    :itemstring:='magic shield';
          flamewand      :itemstring:='flame wand';
     end;{case}
end;
{---------------------------------------------------------------------------}
function spellstring(thespell:spell):stringtype;

begin
     case thespell of
          icestorm       :spellstring:='ice storm';
          fireblast      :spellstring:='fire blast';
          web            :spellstring:='web';
          callwild       :spellstring:='call wild';
          heal           :spellstring:='heal';
          courage        :spellstring:='courage';
          freeze         :spellstring:='freeze';
          obliterate     :spellstring:='obliterate';
          icicle         :spellstring:='icicle';
          power          :spellstring:='power';
          shatter        :spellstring:='shatter';
          glacier        :spellstring:='glacier';
          dragonbreath   :spellstring:='dragon breath';
          resistfire     :spellstring:='resist fire';
          resistcold     :spellstring:='resist cold';
     end;{case}
end;
{--------------------------------------------------------------------------}

Begin
  repeat
     randomize;
     clrscr;
     writeln('Ice Queen Character Converter ',version);
     writeln;
     writeln;
     write('Enter saved game to convert from v1.x to v2.x format:  ');
     readln(dosname);
     if not(exist(dosname)) then
          begin
               writeln('That file does not exist.');
          end;
     if (exist(dosname)) then
          begin
               assign(oldfile,dosname);
               reset(oldfile);
               readln(oldfile,firstline);
               readln(oldfile);
               readln(oldfile,oldplayer.name);
               readln(oldfile,oldplayer.picfile);
               readln(oldfile,oldplayer.endurance);
               readln(oldfile,oldplayer.endurancemax);
               readln(oldfile,oldplayer.combatskill);
               readln(oldfile,oldplayer.sex);
               readln(oldfile,oldplayer.luck);
               readln(oldfile,oldplayer.coins);
               readln(oldfile,oldplayer.numitems);
               for loop:=1 to oldplayer.numitems do
                    readln(oldfile,oldplayer.item[loop]);
               readln(oldfile,oldplayer.numspells);
               for loop:=1 to oldplayer.numspells do
                    readln(oldfile,oldplayer.spell[loop]);
               close(oldfile);

            if (firstline<>'COTW SAVEGAME') then
                 writeln('This is not a valid 1.x character.')
            else
              begin
               player.name:=oldplayer.name;
               player.picfile:=oldplayer.picfile;
               if (player.picfile='fplayer.pic') then
                    player.picfile:='fplayer.ln1'
               else
                    player.picfile:='mplayer.ln1';
               if (oldplayer.endurancemax>18) then
                    begin
                         oldplayer.endurancemax:=3;
                         writeln('Cheater... penalty applied. [endurancemax]');
                    end;
               player.endurancemax:=(oldplayer.endurancemax DIV 2) - 1;
               if (player.endurancemax<=0) then
                    player.endurancemax:=1;
               if (player.endurancemax>8) then
                    player.endurancemax:=8;
               if (oldplayer.endurance>18) then
                    begin
                         oldplayer.endurance:=3;
                         writeln('Cheater... penalty applied. [endurance]');
                    end;
               player.endurance:=(oldplayer.endurance DIV 2) - 1;
               if (player.endurance<=0) then
                    player.endurance:=1;
               if (player.endurance>8) then
                    player.endurance:=8;
               if not(oldplayer.sex in ['m','M','f','F']) then
                    oldplayer.sex:='M';
               player.sex:=oldplayer.sex;
               player.coins:=oldplayer.coins DIV 2;
               if (oldplayer.combatskill>18) then
                    begin
                         oldplayer.combatskill:=3;
                         writeln('Cheater... penalty applied. [combatskill]');
                    end;
               if (oldplayer.luck>18) then
                    begin
                         oldplayer.luck:=3;
                         writeln('Cheater... penalty applied. [luck]');
                    end;
               player.strength:=(oldplayer.combatskill DIV 3) + (oldplayer.luck DIV 3) + random(6)+1;
               player.dexterity:=(oldplayer.combatskill DIV 3) + (oldplayer.luck DIV 3) + random(6)+1;
               player.level:=1;
               player.experience:=0;
               player.stages:=[];
               player.charges:=0;
               player.chargemax:=0;
               player.numitems:=oldplayer.numitems;
               for loop:=1 to oldplayer.numitems do
                    begin
                         case oldplayer.item[loop] of
                              2:player.item[loop]:=shield;
                              3:player.item[loop]:=axe;
                              4:player.item[loop]:=bluepotion;
                              5:player.item[loop]:=redpotion;
                              6:player.item[loop]:=greenpotion;
                              7:player.item[loop]:=chainmail;
                              8:player.item[loop]:=platemail;
                              9:player.item[loop]:=dagger;
                             10:player.item[loop]:=club;
                             11:player.item[loop]:=staff;
                             12:player.item[loop]:=hammer;
                             13:player.item[loop]:=magicsword;
                             14:player.item[loop]:=magicshield;
                             15:player.item[loop]:=flamewand;
                         else
                              player.item[loop]:=sword;
                         end; {case}
                    end;
               if (oldplayer.numspells>=1) then
                    player.stages:=[ring];
               player.numspells:=oldplayer.numspells;
               found:=false;
               for loop:=1 to oldplayer.numspells do
                    begin
                         case oldplayer.spell[loop] of
                              2:player.spell[loop]:=fireblast;
                              3:player.spell[loop]:=web;
                              4:player.spell[loop]:=callwild;
                              5:player.spell[loop]:=heal;
                              6:player.spell[loop]:=courage;
                              7:player.spell[loop]:=freeze;
                              8:begin
                                     player.spell[loop]:=obliterate;
                                     found:=true;
                                     spot:=loop;
                                end;
                              9:player.spell[loop]:=icicle;
                             10:player.spell[loop]:=power;
                             11:player.spell[loop]:=shatter;
                             12:player.spell[loop]:=glacier;
                             13:player.spell[loop]:=dragonbreath;
                             14:player.spell[loop]:=resistfire;
                             15:player.spell[loop]:=resistcold;
                         else
                              player.spell[loop]:=icestorm;
                         end; {case}
                         player.chargemax:=player.chargemax+1;
                    end;

               if (found) then
                    begin
                         for loop:=spot to player.numspells do
                              player.spell[loop]:=player.spell[loop+1];
                         player.numspells:=player.numspells-1;
                    end;

               if (player.chargemax>ringmax) then
                    player.chargemax:=ringmax;
               player.charges:=player.chargemax;

               player.experience:=oldplayer.coins;
               if (player.experience>12000) then
                    player.experience:=12000;
               loop:=0;
               repeat
                    calcstats(player);
                    loop:=loop+1;
               until (player.level=loop);

               writeln;
               writeln('Conversion done.  Press a key to continue.');
               ch:=readkey;

               writeln;
               writeln;
               writeln('CONVERT TO');
               writeln;
               with player do
                    begin
                         writeln('Name:  ',name);
                         writeln('Gender:  ',sex);
                         writeln('Level:  ',level);
                         writeln('Endurance:  ',endurance,'/',endurancemax);
                         writeln('Strength:  ',strength);
                         writeln('Dexterity:  ',dexterity);
                         writeln('Armor Class:  ',armorclass);
                         writeln('THAC0:  ',thac0);
                         writeln('Damage:  ',damage.rollnum,'d',damage.dicetype,'+',damage.bonus);
                         writeln('Save As:  ',savingthrow);
                         writeln('Experience:  ',experience);
                         writeln('Coins:  ',coins);
                         writeln('Items:  ');
                         for loop:=1 to numitems do
                              writeln('   ',itemstring(item[loop]));
                         if (numitems=0) then
                              writeln('   NONE');
                         writeln('Spells:  ');
                         for loop:=1 to numspells do
                              writeln('   ',spellstring(spell[loop]));
                         if (numspells=0) then
                              writeln('   NONE');
                    end;
               writeln;
               writeln('Save this character instead?  (y/n)');
               repeat
                    ch:=readkey;
               until (ch in ['n','N','y','Y']);
               writeln;
               if (ch in ['y','Y']) then
                    begin
                         assign(newfile,dosname);
                         rewrite(newfile);
                         write(newfile,player);
                         close(newfile);
                         writeln('Done.');
                    end
               else
                    writeln('BYE.');

              end;
          end;

     writeln;
     writeln;
     writeln('<Enter> to continue, <ESC> to quit.');
     repeat
          ch:=readkey;
     until (ch in [#13,#27]);

  until (ch in [#27]);
End.