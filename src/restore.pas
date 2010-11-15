{
Ice Queen Defaults Program
Resets all default settings for Ice Queen
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

program Restore;

{This program resets all defaults, creating monster files, map and code files,
wandering monster charts, and the config.dat file to go with them.}

uses crt;

{$I config.pas}
{$I data_t.pas}

var
     ch             :    char;
     ans            :    char;
     loop           :    integer;

{$I extras.pas}
{--------------------------------------------------------------------------}
procedure parse(thestring:string;var therecord:dicerecord);

{This procedure parses a string into a dice record.  ##d##+##}

var
     errcode   :    integer;
     dpos      :    integer;  {position of "d"}
     bpos      :    integer;  {position of "+" or "-"}
     substr    :    string;
     tempint   :    integer;

begin

     dpos:=pos('d',thestring);
     bpos:=pos('+',thestring);
     if (bpos=0) then
          bpos:=pos('-',thestring);
     errcode:=0;

     if (thestring='') then
          with therecord do
               begin
                    rollnum:=0;
                    dicetype:=0;
                    bonus:=0;
               end
     else
          if (dpos=0) then
               with therecord do
                    begin
                         rollnum:=0;
                         dicetype:=0;
                         val(thestring,tempint,errcode);
                         if not(errcode=0) then
                              write('ERROR');
                         bonus:=tempint;
                    end
          else
               begin
                    substr:='';
                    for loop:=1 to (dpos-1) do
                         substr:=substr+thestring[loop];
                    val(substr,tempint,errcode);
                    therecord.rollnum:=tempint;
                    if not(errcode=0) then
                         write('ERROR');
                    substr:='';
                    if (bpos=0) then
                         begin
                              for loop:=(dpos+1) to length(thestring) do
                                   substr:=substr+thestring[loop];
                              val(substr,tempint,errcode);
                              therecord.dicetype:=tempint;
                              if not(errcode=0) then
                                   write('ERROR');
                              therecord.bonus:=0;
                         end
                    else
                         begin
                              for loop:=(dpos+1) to (bpos-1) do
                                   substr:=substr+thestring[loop];
                              val(substr,tempint,errcode);
                              therecord.dicetype:=tempint;
                              if not(errcode=0) then
                                   write('ERROR');
                              substr:='';
                              for loop:=(bpos+1) to length(thestring) do
                                   substr:=substr+thestring[loop];
                              val(substr,tempint,errcode);
                              therecord.bonus:=tempint;
                              if not(errcode=0) then
                                   write('ERROR');
                              if (pos('-',thestring)>0) then
                                   therecord.bonus:=therecord.bonus * -1;
                         end;
               end;

end;
{--------------------------------------------------------------------------}
procedure createmonster(
               name           :    string;
               filename       :    string;
               picfile        :    string;
               sex            :    char;
               alignment      :    char;
               hitdice        :    byte;
               hpbonus        :    shortint;
               armorclass     :    integer;
               damagestr      :    string;
               attacktype     :    string;
               savingthrow    :    byte;
               morale         :    byte;
               xpvalue        :    longint;
               treasurestr    :    string;
               numspells      :    byte;
               spellstr       :    string);

var
     int            :    integer;
     monster        :    monsterrecord;
     damage         :    dicerecord;
     treasure       :    dicerecord;
     spell          :    spellarray;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure savemonster(filename:string;monster:monsterrecord);

var
     savefile        :    file of monsterrecord;

begin
     assign(savefile,filename);
     rewrite(savefile);
     write(savefile,monster);
     close(savefile);
     writeln(filename);
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

begin

     parse(damagestr,damage);
     parse(treasurestr,treasure);

     for loop:=1 to numspells do
          begin
               case spellstr[loop] of
                    '2':spell[loop]:=fireblast;
                    '3':spell[loop]:=web;
                    '4':spell[loop]:=callwild;
                    '5':spell[loop]:=heal;
                    '6':spell[loop]:=courage;
                    '7':spell[loop]:=freeze;
                    '8':spell[loop]:=obliterate;
                    '9':spell[loop]:=icicle;
                    'A':spell[loop]:=power;
                    'B':spell[loop]:=shatter;
                    'C':spell[loop]:=glacier;
                    'D':spell[loop]:=dragonbreath;
                    'E':spell[loop]:=resistfire;
                    'F':spell[loop]:=resistcold;
               else
                    spell[loop]:=icestorm;
               end; {case}
          end;
     monster.name:=name;
     monster.picfile:=picfile;
     monster.sex:=sex;
     monster.alignment:=alignment;
     monster.hitdice:=hitdice;
     monster.hpbonus:=hpbonus;
     monster.endurance:=0;
     monster.endurancemax:=0;
     monster.armorclass:=armorclass;
     monster.thac0:=20-hitdice;
     if(hpbonus>0)then
          monster.thac0:=monster.thac0-1;
     monster.damage:=damage;
     monster.attacktype:=attacktype;
     monster.savingthrow:=savingthrow;
     monster.morale:=morale;
     monster.xpvalue:=xpvalue;
     monster.treasure:=treasure;
     monster.coins:=0;
     monster.numspells:=numspells;
     monster.spell:=spell;

     savemonster(monsterdir+'/'+filename,monster);

end;
{--------------------------------------------------------------------------}
procedure createmonsters;

begin
{name,file,picture,gender,alignment,HD,+HD,AC,DMG,attack,save,morale,basexpv,coins,numspells,spells}
{
'1':icestorm        '2':fireblast       '3':web
'4':callwild        '5':heal            '6':courage
'7':freeze          '8':obliterate      '9':icicle
'A':power           'B':shatter         'C':glacier
'D':dragonbreath    'E':resistfire      'F':resistcold
}

createmonster('wyvern','wyvern.dat','wyvern.bmp','M','C',7,0,3,'3d8','thrashes',14,9,850,'2d8',0,'');
createmonster('centaur','centaur.dat','centaur.bmp','M','N',4,0,5,'1d6','kicks',14,8,75,'2d6',0,'');
createmonster('crab spider','spider.dat','spider.bmp','M','N',2,0,7,'1d8','bites',16,7,25,'0',0,'');
createmonster('werewolf','werewolf.dat','werewolf.bmp','M','C',4,0,5,'2d4','swipes',14,8,125,'2d6',0,'');
createmonster('giant ant','ant.dat','ant.bmp','M','N',4,0,3,'2d6','bites',16,12,125,'0',0,'');
createmonster('fire beetle','beetle.dat','beetle.bmp','M','N',1,2,4,'2d4','bites',16,7,15,'0',0,'');
createmonster('wolf','wolf.dat','wolf.bmp','M','N',2,2,7,'1d6','bites',16,8,25,'0',0,'');
createmonster('berserker','berserke.dat','berserke.bmp','M','C',1,1,7,'1d10+2','smashes',16,12,19,'2d6',0,'');
createmonster('goblin','goblin.dat','goblin.bmp','M','C',1,-1,6,'1d6','spears',17,6,5,'3d6',0,'');
createmonster('kobold','kobold.dat','kobold.bmp','M','C',1,-4,7,'1d4-1','pokes',17,4,1,'4d10',0,'');
createmonster('orc','orc.dat','orc.bmp','M','C',1,0,6,'1d8','slashes',16,8,10,'3d6',0,'');
createmonster('bandit','bandit.dat','bandit.bmp','M','C',1,-2,6,'1d6','attacks',15,6,5,'3d8+8',0,'');
createmonster('ogre','ogre.dat','ogre.bmp','M','C',4,1,5,'1d8+2','clubs',14,10,125,'4d8',0,'');
createmonster('rock baboon','baboon.dat','baboon.bmp','M','N',2,0,6,'1d4','scratches',16,8,20,'1d4',0,'');
createmonster('giant bee','bee.dat','bee.bmp','M','N',1,-4,7,'1d3','stings',16,9,1,'0',0,'');
createmonster('gnt centipede','centiped.dat','centiped.bmp','M','N',1,-4,9,'1d3','bites',17,7,1,'0',0,'');
createmonster('minotaur','minotaur.dat','minotaur.bmp','M','C',6,0,6,'2d6','gores',14,12,275,'2d8',0,'');
createmonster('troll','troll.dat','troll.bmp','M','C',6,3,4,'2d6+2','attacks',14,10,650,'3d6',0,'');
createmonster('hill giant','giant.dat','giant.bmp','M','C',8,0,4,'2d8','decimates',12,8,650,'1000',0,'');
createmonster('displacer','displace.dat','displace.bmp','M','N',6,0,4,'3d4','swipes',14,8,500,'1d20',0,'');
createmonster('manticore','manticor.dat','manticor.bmp','M','C',6,1,4,'3d6','punctures',14,9,650,'1d100',0,'');
createmonster('frost lizard','salamand.dat','salamand.bmp','F','C',12,0,3,'4d6','claws',10,9,2125,'1d10+200',1,'F');
createmonster('Winter Soldier','soldier.dat','soldier.bmp','M','N',2,1,3,'1d6+1','spears',16,10,25,'2d6',0,'');
createmonster('Red Dragon','dragon.dat','dragon.bmp','M','C',10,0,-1,'4d8','claws',10,12,2500,'10d100+5000',2,'DDDE');
createmonster('Ice Queen','icequeen.dat','icequeen.bmp','F','C',12,0,9,'1d4+1','stabs',10,12,6500,'10d10+10',6,'11179C');
createmonster('Roland McDoland','roland.dat','roland.bmp','M','C',20,20,-10,'2d6+3','kicks',1,12,18500,'100d100+100',1,'8');
createmonster('green slime','slime.dat','slime.bmp','M','N',2,0,20,'1d4','attacks',16,7,30,'0',0,'');
createmonster('shadow','shadow.dat','shadow.bmp','M','C',2,2,7,'1d4','attacks',16,12,35,'0',0,'');
createmonster('skeleton','skeleton.dat','skeleton.bmp','M','C',1,0,7,'1d8','slashes',16,12,10,'1d6',0,'');
createmonster('gargoyle','gargoyle.dat','gargoyle.bmp','M','C',4,0,5,'2d4','claws',12,11,175,'1d4',0,'');
createmonster('ghoul','ghoul.dat','ghoul.bmp','M','C',2,0,6,'2d3','gropes',16,9,25,'1d6',0,'');
createmonster('purple ooze','ooze.dat','ooze.bmp','M','N',1,0,9,'1d4','attacks',16,5,10,'1d4',0,'');
createmonster('wraith','wraith.dat','wraith.bmp','M','C',4,0,3,'1d6','attacks',14,11,175,'0',0,'');
createmonster('Dilvish','dilvish.dat','dilvish.bmp','M','N',4,0,1,'1d8+2','slashes',11,10,125,'2d10',2,'32');
createmonster('Prudence','prudence.dat','prudence.bmp','F','L',5,5,4,'1d6+2','spears',14,12,175,'1d10',0,'');
createmonster('Spirit','spirit.dat','spirit.bmp','F','N',4,0,3,'1d6','hits',15,10,125,'1d10',1,'5');
createmonster('Marcus','marcus.dat','marcus.bmp','M','N',5,0,4,'1d6+3','attacks',13,8,175,'5d10',0,'');
createmonster('Baltar','baltar.dat','baltar.bmp','M','C',5,5,2,'1d8+3','slices',14,10,175,'3d10',0,'');
createmonster('Succubus','succubus.dat','succubus.bmp','F','C',6,0,0,'1d6','claws',14,12,500,'1d10+10',0,'');
createmonster('Brawler','brawler.dat','brawler.bmp','M','N',2,1,9,'1d2+1','punches',16,8,25,'1d10',0,'');
createmonster('Ice Knight','knight.dat','knight.bmp','M','C',6,6,2,'1d8+1','strikes',14,11,350,'4d8',0,'');

end;
{--------------------------------------------------------------------------}
procedure createmaps;

type
     matrix         =    array[1..colmax,1..rowmax] of integer;

var
     themap    :    matrix;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure savemap(filename:string;themap:matrix);

var
     savefile   :    file of matrix;

begin
     assign(savefile,filename);
     rewrite(savefile);
     write(savefile,themap);
     close(savefile);
     writeln(filename);
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
begin

     {surface.map}
     themap[1,1]:=9;
     themap[1,2]:=9;
     themap[1,3]:=13;
     themap[1,4]:=13;
     themap[1,5]:=13;
     themap[1,6]:=13;
     themap[1,7]:=13;
     themap[1,8]:=4;
     themap[1,9]:=5;
     themap[1,10]:=5;
     themap[1,11]:=5;
     themap[1,12]:=5;
     themap[1,13]:=5;
     themap[1,14]:=4;
     themap[2,1]:=9;
     themap[2,2]:=13;
     themap[2,3]:=13;
     themap[2,4]:=11;
     themap[2,5]:=13;
     themap[2,6]:=13;
     themap[2,7]:=3;
     themap[2,8]:=4;
     themap[2,9]:=4;
     themap[2,10]:=5;
     themap[2,11]:=5;
     themap[2,12]:=5;
     themap[2,13]:=4;
     themap[2,14]:=4;
     themap[3,1]:=13;
     themap[3,2]:=13;
     themap[3,3]:=11;
     themap[3,4]:=11;
     themap[3,5]:=13;
     themap[3,6]:=3;
     themap[3,7]:=3;
     themap[3,8]:=3;
     themap[3,9]:=4;
     themap[3,10]:=5;
     themap[3,11]:=5;
     themap[3,12]:=4;
     themap[3,13]:=4;
     themap[3,14]:=4;
     themap[4,1]:=13;
     themap[4,2]:=11;
     themap[4,3]:=11;
     themap[4,4]:=13;
     themap[4,5]:=13;
     themap[4,6]:=3;
     themap[4,7]:=3;
     themap[4,8]:=3;
     themap[4,9]:=3;
     themap[4,10]:=4;
     themap[4,11]:=5;
     themap[4,12]:=5;
     themap[4,13]:=4;
     themap[4,14]:=4;
     themap[5,1]:=11;
     themap[5,2]:=11;
     themap[5,3]:=11;
     themap[5,4]:=13;
     themap[5,5]:=13;
     themap[5,6]:=3;
     themap[5,7]:=3;
     themap[5,8]:=3;
     themap[5,9]:=3;
     themap[5,10]:=2;
     themap[5,11]:=4;

     themap[5,12]:=5;
     themap[5,13]:=4;
     themap[5,14]:=4;
     themap[6,1]:=11;
     themap[6,2]:=11;
     themap[6,3]:=11;
     themap[6,4]:=11;
     themap[6,5]:=13;
     themap[6,6]:=3;
     themap[6,7]:=3;
     themap[6,8]:=3;
     themap[6,9]:=3;
     themap[6,10]:=3;
     themap[6,11]:=3;
     themap[6,12]:=4;
     themap[6,13]:=3;
     themap[6,14]:=4;
     themap[7,1]:=11;
     themap[7,2]:=11;
     themap[7,3]:=11;
     themap[7,4]:=11;
     themap[7,5]:=13;
     themap[7,6]:=3;
     themap[7,7]:=3;
     themap[7,8]:=3;
     themap[7,9]:=3;
     themap[7,10]:=3;
     themap[7,11]:=3;
     themap[7,12]:=3;
     themap[7,13]:=3;
     themap[7,14]:=8;
     themap[8,1]:=11;
     themap[8,2]:=11;
     themap[8,3]:=11;
     themap[8,4]:=11;
     themap[8,5]:=13;
     themap[8,6]:=3;
     themap[8,7]:=3;
     themap[8,8]:=3;
     themap[8,9]:=3;
     themap[8,10]:=3;
     themap[8,11]:=3;
     themap[8,12]:=3;
     themap[8,13]:=8;
     themap[8,14]:=8;
     themap[9,1]:=13;
     themap[9,2]:=11;
     themap[9,3]:=11;
     themap[9,4]:=13;
     themap[9,5]:=13;
     themap[9,6]:=13;
     themap[9,7]:=3;
     themap[9,8]:=3;
     themap[9,9]:=3;
     themap[9,10]:=3;
     themap[9,11]:=3;
     themap[9,12]:=3;
     themap[9,13]:=8;
     themap[9,14]:=8;
     themap[10,1]:=13;
     themap[10,2]:=13;
     themap[10,3]:=13;
     themap[10,4]:=13;
     themap[10,5]:=13;
     themap[10,6]:=13;
     themap[10,7]:=3;
     themap[10,8]:=3;
     themap[10,9]:=6;
     themap[10,10]:=6;
     themap[10,11]:=1;
     themap[10,12]:=6;
     themap[10,13]:=8;
     themap[10,14]:=8;
     themap[11,1]:=9;
     themap[11,2]:=9;
     themap[11,3]:=9;
     themap[11,4]:=13;
     themap[11,5]:=13;
     themap[11,6]:=3;
     themap[11,7]:=3;
     themap[11,8]:=3;
     themap[11,9]:=6;
     themap[11,10]:=3;
     themap[11,11]:=3;
     themap[11,12]:=6;
     themap[11,13]:=8;
     themap[11,14]:=8;
     themap[12,1]:=9;
     themap[12,2]:=9;
     themap[12,3]:=9;
     themap[12,4]:=9;
     themap[12,5]:=13;
     themap[12,6]:=3;
     themap[12,7]:=3;
     themap[12,8]:=3;
     themap[12,9]:=6;
     themap[12,10]:=3;
     themap[12,11]:=3;
     themap[12,12]:=6;
     themap[12,13]:=6;
     themap[12,14]:=8;
     themap[13,1]:=9;
     themap[13,2]:=9;
     themap[13,3]:=10;
     themap[13,4]:=13;
     themap[13,5]:=13;
     themap[13,6]:=3;
     themap[13,7]:=3;
     themap[13,8]:=6;
     themap[13,9]:=6;
     themap[13,10]:=3;
     themap[13,11]:=3;
     themap[13,12]:=3;
     themap[13,13]:=6;
     themap[13,14]:=6;
     themap[14,1]:=9;
     themap[14,2]:=9;
     themap[14,3]:=9;
     themap[14,4]:=9;
     themap[14,5]:=13;
     themap[14,6]:=3;
     themap[14,7]:=3;
     themap[14,8]:=6;
     themap[14,9]:=3;
     themap[14,10]:=3;
     themap[14,11]:=3;
     themap[14,12]:=3;
     themap[14,13]:=8;
     themap[14,14]:=8;
     themap[15,1]:=9;
     themap[15,2]:=9;
     themap[15,3]:=9;
     themap[15,4]:=13;
     themap[15,5]:=13;
     themap[15,6]:=3;
     themap[15,7]:=6;
     themap[15,8]:=6;
     themap[15,9]:=3;
     themap[15,10]:=3;
     themap[15,11]:=3;
     themap[15,12]:=3;
     themap[15,13]:=3;
     themap[15,14]:=8;
     themap[16,1]:=13;
     themap[16,2]:=13;
     themap[16,3]:=13;
     themap[16,4]:=13;
     themap[16,5]:=3;
     themap[16,6]:=3;
     themap[16,7]:=12;
     themap[16,8]:=3;
     themap[16,9]:=3;
     themap[16,10]:=3;
     themap[16,11]:=3;
     themap[16,12]:=3;
     themap[16,13]:=3;
     themap[16,14]:=4;
     themap[17,1]:=13;
     themap[17,2]:=13;
     themap[17,3]:=13;
     themap[17,4]:=13;
     themap[17,5]:=3;
     themap[17,6]:=3;
     themap[17,7]:=3;
     themap[17,8]:=3;
     themap[17,9]:=3;
     themap[17,10]:=3;
     themap[17,11]:=3;
     themap[17,12]:=3;
     themap[17,13]:=3;
     themap[17,14]:=5;
     themap[18,1]:=11;
     themap[18,2]:=13;
     themap[18,3]:=13;
     themap[18,4]:=13;



     themap[18,5]:=13;
     themap[18,6]:=3;
     themap[18,7]:=3;
     themap[18,8]:=3;
     themap[18,9]:=3;
     themap[18,10]:=3;
     themap[18,11]:=7;
     themap[18,12]:=4;
     themap[18,13]:=4;
     themap[18,14]:=5;
     themap[19,1]:=11;
     themap[19,2]:=11;
     themap[19,3]:=13;
     themap[19,4]:=13;
     themap[19,5]:=13;
     themap[19,6]:=3;
     themap[19,7]:=3;
     themap[19,8]:=7;
     themap[19,9]:=7;
     themap[19,10]:=7;
     themap[19,11]:=4;
     themap[19,12]:=4;
     themap[19,13]:=5;
     themap[19,14]:=5;
     themap[20,1]:=11;
     themap[20,2]:=11;
     themap[20,3]:=11;
     themap[20,4]:=13;
     themap[20,5]:=13;
     themap[20,6]:=13;
     themap[20,7]:=7;
     themap[20,8]:=7;
     themap[20,9]:=7;
     themap[20,10]:=4;
     themap[20,11]:=5;
     themap[20,12]:=5;
     themap[20,13]:=5;
     themap[20,14]:=5;

     savemap(mapdir+'/surface.map',themap);

     {surface.cod}
     themap[1,1]:=1;
     themap[1,2]:=1;
     themap[1,3]:=0;
     themap[1,4]:=0;
     themap[1,5]:=0;
     themap[1,6]:=0;
     themap[1,7]:=0;
     themap[1,8]:=0;
     themap[1,9]:=1;
     themap[1,10]:=1;
     themap[1,11]:=1;
     themap[1,12]:=1;
     themap[1,13]:=1;
     themap[1,14]:=0;
     themap[2,1]:=1;
     themap[2,2]:=7;
     themap[2,3]:=0;
     themap[2,4]:=1;
     themap[2,5]:=0;
     themap[2,6]:=0;
     themap[2,7]:=0;
     themap[2,8]:=0;
     themap[2,9]:=0;
     themap[2,10]:=1;
     themap[2,11]:=1;
     themap[2,12]:=1;
     themap[2,13]:=0;
     themap[2,14]:=0;
     themap[3,1]:=0;
     themap[3,2]:=0;
     themap[3,3]:=1;
     themap[3,4]:=1;
     themap[3,5]:=0;
     themap[3,6]:=0;
     themap[3,7]:=0;
     themap[3,8]:=0;
     themap[3,9]:=0;
     themap[3,10]:=1;
     themap[3,11]:=1;
     themap[3,12]:=6;
     themap[3,13]:=0;
     themap[3,14]:=0;
     themap[4,1]:=0;
     themap[4,2]:=1;
     themap[4,3]:=1;
     themap[4,4]:=0;
     themap[4,5]:=0;
     themap[4,6]:=0;
     themap[4,7]:=0;
     themap[4,8]:=0;
     themap[4,9]:=0;
     themap[4,10]:=0;
     themap[4,11]:=1;
     themap[4,12]:=1;
     themap[4,13]:=0;
     themap[4,14]:=0;
     themap[5,1]:=1;
     themap[5,2]:=1;
     themap[5,3]:=1;
     themap[5,4]:=0;
     themap[5,5]:=0;
     themap[5,6]:=0;
     themap[5,7]:=0;
     themap[5,8]:=0;
     themap[5,9]:=0;
     themap[5,10]:=5;
     themap[5,11]:=0;
     themap[5,12]:=1;
     themap[5,13]:=0;
     themap[5,14]:=0;
     themap[6,1]:=1;
     themap[6,2]:=1;
     themap[6,3]:=1;
     themap[6,4]:=1;
     themap[6,5]:=0;
     themap[6,6]:=0;
     themap[6,7]:=0;
     themap[6,8]:=0;
     themap[6,9]:=0;
     themap[6,10]:=0;
     themap[6,11]:=0;
     themap[6,12]:=0;
     themap[6,13]:=0;
     themap[6,14]:=0;
     themap[7,1]:=1;
     themap[7,2]:=1;
     themap[7,3]:=1;
     themap[7,4]:=1;
     themap[7,5]:=0;
     themap[7,6]:=0;
     themap[7,7]:=0;
     themap[7,8]:=0;
     themap[7,9]:=0;
     themap[7,10]:=0;
     themap[7,11]:=0;
     themap[7,12]:=0;
     themap[7,13]:=0;
     themap[7,14]:=0;
     themap[8,1]:=1;
     themap[8,2]:=1;
     themap[8,3]:=1;
     themap[8,4]:=1;
     themap[8,5]:=0;
     themap[8,6]:=0;
     themap[8,7]:=0;
     themap[8,8]:=0;
     themap[8,9]:=0;
     themap[8,10]:=0;
     themap[8,11]:=0;
     themap[8,12]:=0;
     themap[8,13]:=0;
     themap[8,14]:=0;
     themap[9,1]:=0;
     themap[9,2]:=1;
     themap[9,3]:=1;
     themap[9,4]:=0;
     themap[9,5]:=0;
     themap[9,6]:=0;
     themap[9,7]:=0;
     themap[9,8]:=0;
     themap[9,9]:=0;
     themap[9,10]:=0;
     themap[9,11]:=0;
     themap[9,12]:=0;
     themap[9,13]:=0;
     themap[9,14]:=0;
     themap[10,1]:=0;
     themap[10,2]:=0;
     themap[10,3]:=0;
     themap[10,4]:=0;
     themap[10,5]:=0;
     themap[10,6]:=0;
     themap[10,7]:=0;
     themap[10,8]:=0;
     themap[10,9]:=2;
     themap[10,10]:=2;
     themap[10,11]:=3;
     themap[10,12]:=2;
     themap[10,13]:=0;
     themap[10,14]:=0;
     themap[11,1]:=1;
     themap[11,2]:=1;
     themap[11,3]:=1;
     themap[11,4]:=0;
     themap[11,5]:=0;
     themap[11,6]:=0;
     themap[11,7]:=0;
     themap[11,8]:=0;
     themap[11,9]:=2;
     themap[11,10]:=0;
     themap[11,11]:=0;
     themap[11,12]:=2;
     themap[11,13]:=0;
     themap[11,14]:=0;
     themap[12,1]:=1;
     themap[12,2]:=1;
     themap[12,3]:=1;
     themap[12,4]:=1;
     themap[12,5]:=0;
     themap[12,6]:=0;
     themap[12,7]:=0;
     themap[12,8]:=0;
     themap[12,9]:=2;
     themap[12,10]:=0;
     themap[12,11]:=0;
     themap[12,12]:=2;
     themap[12,13]:=2;
     themap[12,14]:=0;
     themap[13,1]:=1;
     themap[13,2]:=1;
     themap[13,3]:=8;
     themap[13,4]:=0;
     themap[13,5]:=0;
     themap[13,6]:=0;
     themap[13,7]:=0;
     themap[13,8]:=2;
     themap[13,9]:=2;
     themap[13,10]:=0;
     themap[13,11]:=0;
     themap[13,12]:=0;
     themap[13,13]:=2;
     themap[13,14]:=2;
     themap[14,1]:=1;
     themap[14,2]:=1;
     themap[14,3]:=1;
     themap[14,4]:=1;
     themap[14,5]:=0;
     themap[14,6]:=0;
     themap[14,7]:=0;
     themap[14,8]:=2;
     themap[14,9]:=0;
     themap[14,10]:=0;
     themap[14,11]:=0;
     themap[14,12]:=0;
     themap[14,13]:=0;
     themap[14,14]:=0;
     themap[15,1]:=1;
     themap[15,2]:=1;
     themap[15,3]:=1;
     themap[15,4]:=0;
     themap[15,5]:=0;
     themap[15,6]:=0;
     themap[15,7]:=2;
     themap[15,8]:=2;
     themap[15,9]:=0;
     themap[15,10]:=0;
     themap[15,11]:=0;
     themap[15,12]:=0;
     themap[15,13]:=0;
     themap[15,14]:=0;
     themap[16,1]:=0;
     themap[16,2]:=0;
     themap[16,3]:=0;
     themap[16,4]:=0;
     themap[16,5]:=0;
     themap[16,6]:=0;
     themap[16,7]:=4;
     themap[16,8]:=0;
     themap[16,9]:=0;
     themap[16,10]:=0;
     themap[16,11]:=0;
     themap[16,12]:=0;
     themap[16,13]:=0;
     themap[16,14]:=0;
     themap[17,1]:=0;
     themap[17,2]:=0;
     themap[17,3]:=0;
     themap[17,4]:=0;
     themap[17,5]:=0;
     themap[17,6]:=0;
     themap[17,7]:=0;
     themap[17,8]:=0;
     themap[17,9]:=0;
     themap[17,10]:=0;
     themap[17,11]:=0;
     themap[17,12]:=0;
     themap[17,13]:=0;
     themap[17,14]:=1;
     themap[18,1]:=1;
     themap[18,2]:=0;
     themap[18,3]:=0;
     themap[18,4]:=0;
     themap[18,5]:=0;
     themap[18,6]:=0;
     themap[18,7]:=0;
     themap[18,8]:=0;
     themap[18,9]:=0;
     themap[18,10]:=0;
     themap[18,11]:=0;
     themap[18,12]:=0;


     themap[18,13]:=0;
     themap[18,14]:=1;
     themap[19,1]:=1;
     themap[19,2]:=1;
     themap[19,3]:=0;
     themap[19,4]:=0;
     themap[19,5]:=0;
     themap[19,6]:=0;
     themap[19,7]:=0;
     themap[19,8]:=0;
     themap[19,9]:=0;
     themap[19,10]:=0;
     themap[19,11]:=0;
     themap[19,12]:=0;
     themap[19,13]:=1;
     themap[19,14]:=1;
     themap[20,1]:=1;
     themap[20,2]:=1;
     themap[20,3]:=1;
     themap[20,4]:=0;
     themap[20,5]:=0;
     themap[20,6]:=0;
     themap[20,7]:=0;
     themap[20,8]:=0;
     themap[20,9]:=0;
     themap[20,10]:=0;
     themap[20,11]:=1;
     themap[20,12]:=1;
     themap[20,13]:=1;
     themap[20,14]:=1;

     savemap(mapdir+'/surface.cod',themap);

     {cave.map}
     themap[1,1]:=29;
     themap[1,2]:=29;
     themap[1,3]:=29;
     themap[1,4]:=29;
     themap[1,5]:=29;
     themap[1,6]:=29;
     themap[1,7]:=19;
     themap[1,8]:=15;
     themap[1,9]:=23;
     themap[1,10]:=29;
     themap[1,11]:=29;
     themap[1,12]:=29;
     themap[1,13]:=29;
     themap[1,14]:=29;
     themap[2,1]:=29;
     themap[2,2]:=29;
     themap[2,3]:=29;
     themap[2,4]:=29;
     themap[2,5]:=29;
     themap[2,6]:=29;
     themap[2,7]:=22;
     themap[2,8]:=14;
     themap[2,9]:=21;
     themap[2,10]:=29;
     themap[2,11]:=29;
     themap[2,12]:=29;
     themap[2,13]:=29;
     themap[2,14]:=29;
     themap[3,1]:=29;
     themap[3,2]:=29;
     themap[3,3]:=29;
     themap[3,4]:=29;
     themap[3,5]:=29;
     themap[3,6]:=29;
     themap[3,7]:=29;
     themap[3,8]:=20;
     themap[3,9]:=29;
     themap[3,10]:=29;
     themap[3,11]:=29;
     themap[3,12]:=29;
     themap[3,13]:=29;
     themap[3,14]:=29;
     themap[4,1]:=29;
     themap[4,2]:=29;
     themap[4,3]:=29;
     themap[4,4]:=19;
     themap[4,5]:=23;
     themap[4,6]:=29;
     themap[4,7]:=29;
     themap[4,8]:=20;
     themap[4,9]:=29;
     themap[4,10]:=29;
     themap[4,11]:=29;
     themap[4,12]:=27;
     themap[4,13]:=29;
     themap[4,14]:=27;
     themap[5,1]:=29;
     themap[5,2]:=29;
     themap[5,3]:=29;
     themap[5,4]:=16;
     themap[5,5]:=14;
     themap[5,6]:=24;
     themap[5,7]:=24;
     themap[5,8]:=14;
     themap[5,9]:=24;
     themap[5,10]:=24;
     themap[5,11]:=24;
     themap[5,12]:=14;
     themap[5,13]:=24;
     themap[5,14]:=18;
     themap[6,1]:=29;
     themap[6,2]:=29;
     themap[6,3]:=29;
     themap[6,4]:=22;
     themap[6,5]:=21;
     themap[6,6]:=29;
     themap[6,7]:=29;
     themap[6,8]:=20;
     themap[6,9]:=29;
     themap[6,10]:=29;
     themap[6,11]:=29;
     themap[6,12]:=26;
     themap[6,13]:=29;
     themap[6,14]:=26;
     themap[7,1]:=19;
     themap[7,2]:=23;
     themap[7,3]:=29;
     themap[7,4]:=29;
     themap[7,5]:=29;
     themap[7,6]:=29;
     themap[7,7]:=29;
     themap[7,8]:=29;
     themap[7,9]:=29;
     themap[7,10]:=29;
     themap[7,11]:=29;
     themap[7,12]:=29;
     themap[7,13]:=29;
     themap[7,14]:=29;
     themap[8,1]:=16;
     themap[8,2]:=14;
     themap[8,3]:=23;
     themap[8,4]:=29;
     themap[8,5]:=29;
     themap[8,6]:=29;
     themap[8,7]:=29;
     themap[8,8]:=29;
     themap[8,9]:=29;
     themap[8,10]:=19;
     themap[8,11]:=23;
     themap[8,12]:=29;
     themap[8,13]:=29;
     themap[8,14]:=29;
     themap[9,1]:=16;
     themap[9,2]:=14;
     themap[9,3]:=14;
     themap[9,4]:=24;
     themap[9,5]:=24;
     themap[9,6]:=24;
     themap[9,7]:=24;
     themap[9,8]:=15;
     themap[9,9]:=24;
     themap[9,10]:=14;
     themap[9,11]:=18;
     themap[9,12]:=29;
     themap[9,13]:=29;
     themap[9,14]:=29;
     themap[10,1]:=16;
     themap[10,2]:=14;
     themap[10,3]:=21;
     themap[10,4]:=29;
     themap[10,5]:=29;
     themap[10,6]:=29;
     themap[10,7]:=29;
     themap[10,8]:=20;
     themap[10,9]:=29;
     themap[10,10]:=22;
     themap[10,11]:=21;
     themap[10,12]:=29;
     themap[10,13]:=29;
     themap[10,14]:=29;
     themap[11,1]:=22;
     themap[11,2]:=21;






     themap[11,3]:=29;
     themap[11,4]:=19;
     themap[11,5]:=15;
     themap[11,6]:=23;
     themap[11,7]:=29;
     themap[11,8]:=20;
     themap[11,9]:=29;
     themap[11,10]:=29;
     themap[11,11]:=29;
     themap[11,12]:=29;
     themap[11,13]:=29;
     themap[11,14]:=29;
     themap[12,1]:=29;
     themap[12,2]:=29;
     themap[12,3]:=29;
     themap[12,4]:=16;
     themap[12,5]:=14;
     themap[12,6]:=18;
     themap[12,7]:=29;
     themap[12,8]:=20;
     themap[12,9]:=29;
     themap[12,10]:=29;
     themap[12,11]:=29;
     themap[12,12]:=29;
     themap[12,13]:=29;
     themap[12,14]:=29;
     themap[13,1]:=29;
     themap[13,2]:=29;
     themap[13,3]:=29;
     themap[13,4]:=22;
     themap[13,5]:=14;
     themap[13,6]:=21;
     themap[13,7]:=29;
     themap[13,8]:=20;
     themap[13,9]:=29;
     themap[13,10]:=29;
     themap[13,11]:=29;
     themap[13,12]:=29;
     themap[13,13]:=29;
     themap[13,14]:=29;
     themap[14,1]:=29;
     themap[14,2]:=29;
     themap[14,3]:=29;
     themap[14,4]:=29;
     themap[14,5]:=20;
     themap[14,6]:=29;
     themap[14,7]:=29;
     themap[14,8]:=20;
     themap[14,9]:=29;
     themap[14,10]:=29;
     themap[14,11]:=19;
     themap[14,12]:=15;
     themap[14,13]:=23;
     themap[14,14]:=29;
     themap[15,1]:=29;
     themap[15,2]:=29;
     themap[15,3]:=29;
     themap[15,4]:=29;
     themap[15,5]:=22;
     themap[15,6]:=24;
     themap[15,7]:=15;
     themap[15,8]:=14;
     themap[15,9]:=15;
     themap[15,10]:=24;
     themap[15,11]:=14;
     themap[15,12]:=14;
     themap[15,13]:=18;
     themap[15,14]:=29;
     themap[16,1]:=29;
     themap[16,2]:=19;
     themap[16,3]:=15;
     themap[16,4]:=23;
     themap[16,5]:=29;
     themap[16,6]:=29;
     themap[16,7]:=16;
     themap[16,8]:=14;
     themap[16,9]:=18;
     themap[16,10]:=29;
     themap[16,11]:=22;
     themap[16,12]:=17;
     themap[16,13]:=21;
     themap[16,14]:=29;
     themap[17,1]:=29;
     themap[17,2]:=16;
     themap[17,3]:=14;
     themap[17,4]:=18;
     themap[17,5]:=29;
     themap[17,6]:=29;
     themap[17,7]:=16;
     themap[17,8]:=14;
     themap[17,9]:=18;
     themap[17,10]:=29;
     themap[17,11]:=29;
     themap[17,12]:=29;
     themap[17,13]:=29;
     themap[17,14]:=29;
     themap[18,1]:=29;
     themap[18,2]:=16;
     themap[18,3]:=14;
     themap[18,4]:=14;
     themap[18,5]:=24;
     themap[18,6]:=24;
     themap[18,7]:=17;
     themap[18,8]:=14;
     themap[18,9]:=17;
     themap[18,10]:=24;
     themap[18,11]:=15;
     themap[18,12]:=23;
     themap[18,13]:=29;
     themap[18,14]:=29;
     themap[19,1]:=29;
     themap[19,2]:=22;
     themap[19,3]:=17;
     themap[19,4]:=21;
     themap[19,5]:=29;
     themap[19,6]:=29;
     themap[19,7]:=29;
     themap[19,8]:=20;
     themap[19,9]:=29;
     themap[19,10]:=29;
     themap[19,11]:=22;
     themap[19,12]:=21;
     themap[19,13]:=29;
     themap[19,14]:=29;
     themap[20,1]:=29;
     themap[20,2]:=29;
     themap[20,3]:=29;
     themap[20,4]:=29;
     themap[20,5]:=29;
     themap[20,6]:=29;
     themap[20,7]:=29;
     themap[20,8]:=20;
     themap[20,9]:=29;
     themap[20,10]:=29;
     themap[20,11]:=29;
     themap[20,12]:=29;
     themap[20,13]:=29;
     themap[20,14]:=29;

     savemap(mapdir+'/cave.map',themap);

     {cave.cod}
     themap[1,1]:=1;
     themap[1,2]:=1;
     themap[1,3]:=1;
     themap[1,4]:=1;
     themap[1,5]:=1;

     themap[1,6]:=1;
     themap[1,7]:=0;
     themap[1,8]:=10;
     themap[1,9]:=0;
     themap[1,10]:=1;
     themap[1,11]:=1;
     themap[1,12]:=1;
     themap[1,13]:=1;
     themap[1,14]:=1;
     themap[2,1]:=1;
     themap[2,2]:=1;
     themap[2,3]:=1;
     themap[2,4]:=1;
     themap[2,5]:=1;
     themap[2,6]:=1;
     themap[2,7]:=0;
     themap[2,8]:=0;
     themap[2,9]:=0;
     themap[2,10]:=1;
     themap[2,11]:=1;
     themap[2,12]:=1;
     themap[2,13]:=1;
     themap[2,14]:=1;
     themap[3,1]:=1;
     themap[3,2]:=1;

     themap[3,3]:=1;
     themap[3,4]:=1;
     themap[3,5]:=1;
     themap[3,6]:=1;
     themap[3,7]:=1;
     themap[3,8]:=14;
     themap[3,9]:=1;
     themap[3,10]:=1;
     themap[3,11]:=1;
     themap[3,12]:=1;
     themap[3,13]:=1;
     themap[3,14]:=1;
     themap[4,1]:=1;
     themap[4,2]:=1;
     themap[4,3]:=1;
     themap[4,4]:=0;
     themap[4,5]:=0;
     themap[4,6]:=1;
     themap[4,7]:=1;
     themap[4,8]:=0;
     themap[4,9]:=1;
     themap[4,10]:=1;
     themap[4,11]:=1;
     themap[4,12]:=0;
     themap[4,13]:=1;
     themap[4,14]:=0;
     themap[5,1]:=1;
     themap[5,2]:=1;
     themap[5,3]:=1;
     themap[5,4]:=0;
     themap[5,5]:=0;
     themap[5,6]:=0;
     themap[5,7]:=0;
     themap[5,8]:=0;
     themap[5,9]:=0;
     themap[5,10]:=0;
     themap[5,11]:=0;
     themap[5,12]:=0;
     themap[5,13]:=0;
     themap[5,14]:=0;
     themap[6,1]:=1;
     themap[6,2]:=1;
     themap[6,3]:=1;
     themap[6,4]:=0;
     themap[6,5]:=0;
     themap[6,6]:=1;
     themap[6,7]:=1;
     themap[6,8]:=0;
     themap[6,9]:=1;
     themap[6,10]:=1;
     themap[6,11]:=1;
     themap[6,12]:=0;
     themap[6,13]:=1;
     themap[6,14]:=0;
     themap[7,1]:=0;
     themap[7,2]:=0;
     themap[7,3]:=1;
     themap[7,4]:=1;
     themap[7,5]:=1;
     themap[7,6]:=1;
     themap[7,7]:=1;
     themap[7,8]:=28;
     themap[7,9]:=1;
     themap[7,10]:=1;
     themap[7,11]:=1;
     themap[7,12]:=1;
     themap[7,13]:=1;
     themap[7,14]:=1;
     themap[8,1]:=0;
     themap[8,2]:=0;
     themap[8,3]:=0;
     themap[8,4]:=1;
     themap[8,5]:=1;
     themap[8,6]:=1;
     themap[8,7]:=1;
     themap[8,8]:=28;
     themap[8,9]:=1;
     themap[8,10]:=0;
     themap[8,11]:=0;
     themap[8,12]:=1;
     themap[8,13]:=1;
     themap[8,14]:=1;
     themap[9,1]:=9;
     themap[9,2]:=0;
     themap[9,3]:=0;
     themap[9,4]:=0;
     themap[9,5]:=13;
     themap[9,6]:=0;
     themap[9,7]:=0;
     themap[9,8]:=0;
     themap[9,9]:=0;
     themap[9,10]:=0;
     themap[9,11]:=11;
     themap[9,12]:=1;
     themap[9,13]:=1;
     themap[9,14]:=1;
     themap[10,1]:=0;
     themap[10,2]:=0;
     themap[10,3]:=0;
     themap[10,4]:=1;
     themap[10,5]:=1;
     themap[10,6]:=1;
     themap[10,7]:=1;
     themap[10,8]:=0;
     themap[10,9]:=1;
     themap[10,10]:=0;
     themap[10,11]:=0;
     themap[10,12]:=1;
     themap[10,13]:=1;
     themap[10,14]:=1;
     themap[11,1]:=0;
     themap[11,2]:=0;
     themap[11,3]:=1;
     themap[11,4]:=0;
     themap[11,5]:=0;
     themap[11,6]:=0;
     themap[11,7]:=1;
     themap[11,8]:=0;
     themap[11,9]:=1;
     themap[11,10]:=1;
     themap[11,11]:=1;
     themap[11,12]:=1;
     themap[11,13]:=1;
     themap[11,14]:=1;
     themap[12,1]:=1;
     themap[12,2]:=1;
     themap[12,3]:=1;
     themap[12,4]:=0;
     themap[12,5]:=0;
     themap[12,6]:=0;
     themap[12,7]:=1;
     themap[12,8]:=0;
     themap[12,9]:=1;
     themap[12,10]:=1;
     themap[12,11]:=1;
     themap[12,12]:=1;
     themap[12,13]:=1;
     themap[12,14]:=1;
     themap[13,1]:=1;
     themap[13,2]:=1;
     themap[13,3]:=1;
     themap[13,4]:=0;
     themap[13,5]:=0;
     themap[13,6]:=0;
     themap[13,7]:=1;
     themap[13,8]:=0;
     themap[13,9]:=1;
     themap[13,10]:=1;
     themap[13,11]:=1;
     themap[13,12]:=1;
     themap[13,13]:=1;
     themap[13,14]:=1;
     themap[14,1]:=1;
     themap[14,2]:=1;
     themap[14,3]:=1;

     themap[14,4]:=1;
     themap[14,5]:=0;
     themap[14,6]:=1;
     themap[14,7]:=1;
     themap[14,8]:=0;
     themap[14,9]:=1;
     themap[14,10]:=1;
     themap[14,11]:=0;
     themap[14,12]:=0;
     themap[14,13]:=0;
     themap[14,14]:=1;
     themap[15,1]:=1;
     themap[15,2]:=1;
     themap[15,3]:=1;
     themap[15,4]:=1;
     themap[15,5]:=0;
     themap[15,6]:=0;
     themap[15,7]:=0;
     themap[15,8]:=0;
     themap[15,9]:=0;
     themap[15,10]:=0;
     themap[15,11]:=0;
     themap[15,12]:=0;
     themap[15,13]:=0;
     themap[15,14]:=1;
     themap[16,1]:=1;
     themap[16,2]:=0;
     themap[16,3]:=0;
     themap[16,4]:=0;
     themap[16,5]:=1;
     themap[16,6]:=1;
     themap[16,7]:=0;
     themap[16,8]:=0;
     themap[16,9]:=0;
     themap[16,10]:=1;
     themap[16,11]:=0;
     themap[16,12]:=0;
     themap[16,13]:=0;
     themap[16,14]:=1;
     themap[17,1]:=1;
     themap[17,2]:=0;
     themap[17,3]:=0;
     themap[17,4]:=0;
     themap[17,5]:=1;
     themap[17,6]:=1;
     themap[17,7]:=0;
     themap[17,8]:=0;
     themap[17,9]:=0;
     themap[17,10]:=1;
     themap[17,11]:=1;
     themap[17,12]:=1;
     themap[17,13]:=1;
     themap[17,14]:=1;
     themap[18,1]:=1;
     themap[18,2]:=0;
     themap[18,3]:=0;
     themap[18,4]:=0;
     themap[18,5]:=0;
     themap[18,6]:=0;
     themap[18,7]:=0;
     themap[18,8]:=0;
     themap[18,9]:=0;
     themap[18,10]:=0;
     themap[18,11]:=0;
     themap[18,12]:=0;
     themap[18,13]:=1;
     themap[18,14]:=1;
     themap[19,1]:=1;
     themap[19,2]:=0;
     themap[19,3]:=0;
     themap[19,4]:=0;
     themap[19,5]:=1;
     themap[19,6]:=1;
     themap[19,7]:=1;
     themap[19,8]:=0;
     themap[19,9]:=1;
     themap[19,10]:=1;
     themap[19,11]:=0;
     themap[19,12]:=12;
     themap[19,13]:=1;
     themap[19,14]:=1;
     themap[20,1]:=1;
     themap[20,2]:=1;
     themap[20,3]:=1;
     themap[20,4]:=1;
     themap[20,5]:=1;
     themap[20,6]:=1;
     themap[20,7]:=1;
     themap[20,8]:=0;
     themap[20,9]:=1;
     themap[20,10]:=1;
     themap[20,11]:=1;
     themap[20,12]:=1;
     themap[20,13]:=1;
     themap[20,14]:=1;

     savemap(mapdir+'/cave.cod',themap);

     {castle.map}
     themap[1,1]:=0;
     themap[1,2]:=0;
     themap[1,3]:=0;
     themap[1,4]:=0;
     themap[1,5]:=0;
     themap[1,6]:=0;
     themap[1,7]:=0;
     themap[1,8]:=0;
     themap[1,9]:=0;
     themap[1,10]:=0;
     themap[1,11]:=0;
     themap[1,12]:=0;
     themap[1,13]:=0;
     themap[1,14]:=0;
     themap[2,1]:=0;
     themap[2,2]:=0;
     themap[2,3]:=0;
     themap[2,4]:=0;
     themap[2,5]:=0;
     themap[2,6]:=0;
     themap[2,7]:=0;
     themap[2,8]:=0;
     themap[2,9]:=0;
     themap[2,10]:=0;
     themap[2,11]:=0;
     themap[2,12]:=0;
     themap[2,13]:=0;
     themap[2,14]:=0;
     themap[3,1]:=0;
     themap[3,2]:=0;
     themap[3,3]:=0;
     themap[3,4]:=0;
     themap[3,5]:=0;
     themap[3,6]:=0;
     themap[3,7]:=0;
     themap[3,8]:=0;
     themap[3,9]:=0;
     themap[3,10]:=0;
     themap[3,11]:=0;
     themap[3,12]:=0;
     themap[3,13]:=0;
     themap[3,14]:=0;
     themap[4,1]:=0;
     themap[4,2]:=0;
     themap[4,3]:=0;
     themap[4,4]:=0;
     themap[4,5]:=0;
     themap[4,6]:=0;
     themap[4,7]:=19;
     themap[4,8]:=15;
     themap[4,9]:=23;
     themap[4,10]:=0;
     themap[4,11]:=19;
     themap[4,12]:=15;
     themap[4,13]:=23;
     themap[4,14]:=0;
     themap[5,1]:=19;
     themap[5,2]:=15;
     themap[5,3]:=15;
     themap[5,4]:=23;
     themap[5,5]:=0;
     themap[5,6]:=0;
     themap[5,7]:=16;
     themap[5,8]:=14;
     themap[5,9]:=18;
     themap[5,10]:=0;
     themap[5,11]:=16;
     themap[5,12]:=14;
     themap[5,13]:=18;
     themap[5,14]:=0;
     themap[6,1]:=16;
     themap[6,2]:=14;
     themap[6,3]:=14;
     themap[6,4]:=18;
     themap[6,5]:=0;
     themap[6,6]:=0;
     themap[6,7]:=22;
     themap[6,8]:=14;
     themap[6,9]:=21;
     themap[6,10]:=0;

     themap[6,11]:=22;
     themap[6,12]:=14;
     themap[6,13]:=21;
     themap[6,14]:=0;
     themap[7,1]:=22;
     themap[7,2]:=17;
     themap[7,3]:=17;
     themap[7,4]:=18;
     themap[7,5]:=0;
     themap[7,6]:=0;
     themap[7,7]:=0;
     themap[7,8]:=20;
     themap[7,9]:=0;
     themap[7,10]:=0;
     themap[7,11]:=0;
     themap[7,12]:=20;
     themap[7,13]:=0;
     themap[7,14]:=0;
     themap[8,1]:=0;
     themap[8,2]:=0;
     themap[8,3]:=0;
     themap[8,4]:=20;
     themap[8,5]:=0;
     themap[8,6]:=0;
     themap[8,7]:=0;


     themap[8,8]:=20;
     themap[8,9]:=0;
     themap[8,10]:=0;
     themap[8,11]:=0;
     themap[8,12]:=20;
     themap[8,13]:=0;
     themap[8,14]:=0;
     themap[9,1]:=19;
     themap[9,2]:=23;
     themap[9,3]:=0;
     themap[9,4]:=16;
     themap[9,5]:=15;
     themap[9,6]:=15;
     themap[9,7]:=15;
     themap[9,8]:=14;
     themap[9,9]:=15;
     themap[9,10]:=15;
     themap[9,11]:=15;
     themap[9,12]:=18;
     themap[9,13]:=0;
     themap[9,14]:=0;
     themap[10,1]:=16;
     themap[10,2]:=14;
     themap[10,3]:=15;
     themap[10,4]:=14;
     themap[10,5]:=14;
     themap[10,6]:=14;
     themap[10,7]:=14;
     themap[10,8]:=14;
     themap[10,9]:=14;
     themap[10,10]:=14;
     themap[10,11]:=14;
     themap[10,12]:=14;
     themap[10,13]:=15;
     themap[10,14]:=0;
     themap[11,1]:=16;
     themap[11,2]:=14;
     themap[11,3]:=17;
     themap[11,4]:=14;
     themap[11,5]:=14;
     themap[11,6]:=14;
     themap[11,7]:=14;
     themap[11,8]:=14;
     themap[11,9]:=14;
     themap[11,10]:=14;
     themap[11,11]:=14;
     themap[11,12]:=14;
     themap[11,13]:=17;
     themap[11,14]:=0;
     themap[12,1]:=22;
     themap[12,2]:=21;
     themap[12,3]:=0;
     themap[12,4]:=16;
     themap[12,5]:=17;
     themap[12,6]:=17;
     themap[12,7]:=17;
     themap[12,8]:=14;
     themap[12,9]:=17;
     themap[12,10]:=17;
     themap[12,11]:=17;
     themap[12,12]:=18;
     themap[12,13]:=0;

     themap[12,14]:=0;
     themap[13,1]:=0;
     themap[13,2]:=0;
     themap[13,3]:=0;
     themap[13,4]:=20;
     themap[13,5]:=0;
     themap[13,6]:=0;
     themap[13,7]:=0;
     themap[13,8]:=20;
     themap[13,9]:=0;
     themap[13,10]:=0;
     themap[13,11]:=0;
     themap[13,12]:=20;
     themap[13,13]:=0;
     themap[13,14]:=0;
     themap[14,1]:=0;
     themap[14,2]:=0;
     themap[14,3]:=0;
     themap[14,4]:=20;
     themap[14,5]:=0;
     themap[14,6]:=0;
     themap[14,7]:=0;
     themap[14,8]:=20;
     themap[14,9]:=0;
     themap[14,10]:=0;
     themap[14,11]:=0;
     themap[14,12]:=20;
     themap[14,13]:=0;
     themap[14,14]:=0;
     themap[15,1]:=19;
     themap[15,2]:=15;
     themap[15,3]:=24;
     themap[15,4]:=18;
     themap[15,5]:=0;
     themap[15,6]:=0;
     themap[15,7]:=19;
     themap[15,8]:=14;
     themap[15,9]:=23;
     themap[15,10]:=0;
     themap[15,11]:=19;
     themap[15,12]:=14;
     themap[15,13]:=23;
     themap[15,14]:=0;
     themap[16,1]:=16;
     themap[16,2]:=18;
     themap[16,3]:=0;
     themap[16,4]:=16;
     themap[16,5]:=15;
     themap[16,6]:=15;
     themap[16,7]:=14;
     themap[16,8]:=14;
     themap[16,9]:=18;
     themap[16,10]:=0;
     themap[16,11]:=16;
     themap[16,12]:=14;
     themap[16,13]:=18;
     themap[16,14]:=0;
     themap[17,1]:=16;
     themap[17,2]:=18;
     themap[17,3]:=0;
     themap[17,4]:=16;
     themap[17,5]:=14;
     themap[17,6]:=14;
     themap[17,7]:=14;
     themap[17,8]:=14;
     themap[17,9]:=18;
     themap[17,10]:=0;
     themap[17,11]:=22;
     themap[17,12]:=17;
     themap[17,13]:=21;
     themap[17,14]:=0;
     themap[18,1]:=22;
     themap[18,2]:=21;
     themap[18,3]:=0;
     themap[18,4]:=22;
     themap[18,5]:=17;
     themap[18,6]:=17;
     themap[18,7]:=17;
     themap[18,8]:=17;
     themap[18,9]:=21;
     themap[18,10]:=0;
     themap[18,11]:=0;
     themap[18,12]:=0;
     themap[18,13]:=0;
     themap[18,14]:=0;
     themap[19,1]:=0;
     themap[19,2]:=0;
     themap[19,3]:=0;
     themap[19,4]:=0;
     themap[19,5]:=0;
     themap[19,6]:=0;
     themap[19,7]:=0;
     themap[19,8]:=0;
     themap[19,9]:=0;
     themap[19,10]:=0;
     themap[19,11]:=0;
     themap[19,12]:=0;
     themap[19,13]:=0;
     themap[19,14]:=0;
     themap[20,1]:=0;
     themap[20,2]:=0;
     themap[20,3]:=0;
     themap[20,4]:=0;
     themap[20,5]:=0;
     themap[20,6]:=0;
     themap[20,7]:=0;
     themap[20,8]:=0;
     themap[20,9]:=0;
     themap[20,10]:=0;
     themap[20,11]:=0;
     themap[20,12]:=0;
     themap[20,13]:=0;
     themap[20,14]:=0;

     savemap(mapdir+'/castle.map',themap);

     {castle.cod}
     themap[1,1]:=1;
     themap[1,2]:=1;
     themap[1,3]:=1;
     themap[1,4]:=1;
     themap[1,5]:=1;
     themap[1,6]:=1;
     themap[1,7]:=1;
     themap[1,8]:=1;
     themap[1,9]:=1;
     themap[1,10]:=1;
     themap[1,11]:=1;
     themap[1,12]:=1;
     themap[1,13]:=1;
     themap[1,14]:=1;
     themap[2,1]:=1;
     themap[2,2]:=1;
     themap[2,3]:=1;
     themap[2,4]:=1;
     themap[2,5]:=1;
     themap[2,6]:=1;
     themap[2,7]:=1;
     themap[2,8]:=1;
     themap[2,9]:=1;
     themap[2,10]:=1;
     themap[2,11]:=1;
     themap[2,12]:=1;
     themap[2,13]:=1;
     themap[2,14]:=1;
     themap[3,1]:=1;
     themap[3,2]:=1;
     themap[3,3]:=1;
     themap[3,4]:=1;
     themap[3,5]:=1;
     themap[3,6]:=1;
     themap[3,7]:=1;
     themap[3,8]:=1;
     themap[3,9]:=1;
     themap[3,10]:=1;
     themap[3,11]:=1;
     themap[3,12]:=1;
     themap[3,13]:=1;
     themap[3,14]:=1;
     themap[4,1]:=1;
     themap[4,2]:=1;
     themap[4,3]:=1;
     themap[4,4]:=1;
     themap[4,5]:=1;
     themap[4,6]:=1;
     themap[4,7]:=0;
     themap[4,8]:=0;
     themap[4,9]:=0;
     themap[4,10]:=1;
     themap[4,11]:=0;
     themap[4,12]:=0;
     themap[4,13]:=0;
     themap[4,14]:=1;
     themap[5,1]:=0;
     themap[5,2]:=0;
     themap[5,3]:=0;
     themap[5,4]:=0;
     themap[5,5]:=1;
     themap[5,6]:=1;
     themap[5,7]:=0;
     themap[5,8]:=0;
     themap[5,9]:=0;
     themap[5,10]:=1;
     themap[5,11]:=0;
     themap[5,12]:=0;
     themap[5,13]:=0;
     themap[5,14]:=1;
     themap[6,1]:=0;
     themap[6,2]:=0;
     themap[6,3]:=0;
     themap[6,4]:=25;
     themap[6,5]:=1;
     themap[6,6]:=1;
     themap[6,7]:=0;
     themap[6,8]:=23;
     themap[6,9]:=0;
     themap[6,10]:=1;
     themap[6,11]:=0;
     themap[6,12]:=20;
     themap[6,13]:=0;
     themap[6,14]:=1;
     themap[7,1]:=0;
     themap[7,2]:=9;
     themap[7,3]:=0;
     themap[7,4]:=0;
     themap[7,5]:=1;
     themap[7,6]:=1;
     themap[7,7]:=1;
     themap[7,8]:=0;
     themap[7,9]:=1;
     themap[7,10]:=1;
     themap[7,11]:=1;
     themap[7,12]:=0;
     themap[7,13]:=1;
     themap[7,14]:=1;
     themap[8,1]:=1;
     themap[8,2]:=1;
     themap[8,3]:=1;
     themap[8,4]:=0;
     themap[8,5]:=1;
     themap[8,6]:=1;
     themap[8,7]:=1;
     themap[8,8]:=0;
     themap[8,9]:=1;
     themap[8,10]:=1;
     themap[8,11]:=1;
     themap[8,12]:=0;
     themap[8,13]:=1;
     themap[8,14]:=1;
     themap[9,1]:=0;
     themap[9,2]:=0;
     themap[9,3]:=1;
     themap[9,4]:=0;
     themap[9,5]:=22;
     themap[9,6]:=22;
     themap[9,7]:=22;
     themap[9,8]:=22;
     themap[9,9]:=22;
     themap[9,10]:=22;
     themap[9,11]:=22;
     themap[9,12]:=0;
     themap[9,13]:=1;
     themap[9,14]:=1;
     themap[10,1]:=0;
     themap[10,2]:=27;
     themap[10,3]:=0;
     themap[10,4]:=0;
     themap[10,5]:=22;
     themap[10,6]:=22;
     themap[10,7]:=22;
     themap[10,8]:=22;
     themap[10,9]:=22;
     themap[10,10]:=22;
     themap[10,11]:=22;
     themap[10,12]:=0;
     themap[10,13]:=0;
     themap[10,14]:=1;
     themap[11,1]:=0;
     themap[11,2]:=27;
     themap[11,3]:=0;
     themap[11,4]:=0;
     themap[11,5]:=22;
     themap[11,6]:=22;
     themap[11,7]:=22;
     themap[11,8]:=22;
     themap[11,9]:=22;
     themap[11,10]:=22;
     themap[11,11]:=22;
     themap[11,12]:=0;
     themap[11,13]:=0;
     themap[11,14]:=1;
     themap[12,1]:=0;
     themap[12,2]:=0;
     themap[12,3]:=1;
     themap[12,4]:=0;
     themap[12,5]:=22;
     themap[12,6]:=22;
     themap[12,7]:=22;
     themap[12,8]:=22;
     themap[12,9]:=22;
     themap[12,10]:=22;
     themap[12,11]:=22;
     themap[12,12]:=0;
     themap[12,13]:=1;
     themap[12,14]:=1;
     themap[13,1]:=1;
     themap[13,2]:=1;
     themap[13,3]:=1;
     themap[13,4]:=0;
     themap[13,5]:=1;
     themap[13,6]:=1;
     themap[13,7]:=1;
     themap[13,8]:=0;
     themap[13,9]:=1;
     themap[13,10]:=1;
     themap[13,11]:=1;
     themap[13,12]:=0;
     themap[13,13]:=1;
     themap[13,14]:=1;
     themap[14,1]:=1;
     themap[14,2]:=1;
     themap[14,3]:=1;
     themap[14,4]:=0;
     themap[14,5]:=1;
     themap[14,6]:=1;
     themap[14,7]:=1;
     themap[14,8]:=0;
     themap[14,9]:=1;
     themap[14,10]:=1;
     themap[14,11]:=1;
     themap[14,12]:=0;
     themap[14,13]:=1;
     themap[14,14]:=1;
     themap[15,1]:=0;
     themap[15,2]:=26;
     themap[15,3]:=0;
     themap[15,4]:=0;
     themap[15,5]:=1;
     themap[15,6]:=1;
     themap[15,7]:=0;
     themap[15,8]:=24;
     themap[15,9]:=0;
     themap[15,10]:=1;
     themap[15,11]:=0;
     themap[15,12]:=21;
     themap[15,13]:=0;
     themap[15,14]:=1;
     themap[16,1]:=0;
     themap[16,2]:=0;
     themap[16,3]:=1;
     themap[16,4]:=24;
     themap[16,5]:=0;
     themap[16,6]:=0;
     themap[16,7]:=0;
     themap[16,8]:=0;
     themap[16,9]:=0;
     themap[16,10]:=1;
     themap[16,11]:=0;
     themap[16,12]:=0;
     themap[16,13]:=0;
     themap[16,14]:=1;
     themap[17,1]:=0;
     themap[17,2]:=0;
     themap[17,3]:=1;
     themap[17,4]:=0;
     themap[17,5]:=0;
     themap[17,6]:=0;
     themap[17,7]:=0;
     themap[17,8]:=0;
     themap[17,9]:=0;
     themap[17,10]:=1;
     themap[17,11]:=0;
     themap[17,12]:=0;
     themap[17,13]:=0;
     themap[17,14]:=1;
     themap[18,1]:=0;
     themap[18,2]:=0;
     themap[18,3]:=1;
     themap[18,4]:=18;
     themap[18,5]:=0;
     themap[18,6]:=0;
     themap[18,7]:=0;
     themap[18,8]:=0;
     themap[18,9]:=0;
     themap[18,10]:=1;
     themap[18,11]:=1;
     themap[18,12]:=1;
     themap[18,13]:=1;
     themap[18,14]:=1;
     themap[19,1]:=1;
     themap[19,2]:=1;
     themap[19,3]:=1;
     themap[19,4]:=1;
     themap[19,5]:=1;
     themap[19,6]:=1;
     themap[19,7]:=1;
     themap[19,8]:=1;
     themap[19,9]:=1;
     themap[19,10]:=1;
     themap[19,11]:=1;
     themap[19,12]:=1;
     themap[19,13]:=1;
     themap[19,14]:=1;
     themap[20,1]:=1;
     themap[20,2]:=1;
     themap[20,3]:=1;
     themap[20,4]:=1;
     themap[20,5]:=1;
     themap[20,6]:=1;
     themap[20,7]:=1;
     themap[20,8]:=1;
     themap[20,9]:=1;
     themap[20,10]:=1;
     themap[20,11]:=1;
     themap[20,12]:=1;
     themap[20,13]:=1;
     themap[20,14]:=1;

     savemap(mapdir+'/castle.cod',themap);

     {dungeon.map}
     themap[1,1]:=0;
     themap[1,2]:=0;
     themap[1,3]:=0;
     themap[1,4]:=0;
     themap[1,5]:=0;
     themap[1,6]:=0;
     themap[1,7]:=0;
     themap[1,8]:=0;
     themap[1,9]:=0;
     themap[1,10]:=0;
     themap[1,11]:=0;
     themap[1,12]:=0;
     themap[1,13]:=0;
     themap[1,14]:=0;
     themap[2,1]:=0;
     themap[2,2]:=0;
     themap[2,3]:=0;
     themap[2,4]:=0;
     themap[2,5]:=0;
     themap[2,6]:=0;
     themap[2,7]:=0;
     themap[2,8]:=0;
     themap[2,9]:=0;
     themap[2,10]:=19;
     themap[2,11]:=15;
     themap[2,12]:=23;
     themap[2,13]:=0;
     themap[2,14]:=0;
     themap[3,1]:=0;
     themap[3,2]:=0;
     themap[3,3]:=0;
     themap[3,4]:=0;
     themap[3,5]:=0;
     themap[3,6]:=0;
     themap[3,7]:=0;
     themap[3,8]:=0;
     themap[3,9]:=0;
     themap[3,10]:=16;
     themap[3,11]:=14;
     themap[3,12]:=18;
     themap[3,13]:=0;
     themap[3,14]:=0;
     themap[4,1]:=0;
     themap[4,2]:=0;
     themap[4,3]:=19;
     themap[4,4]:=15;
     themap[4,5]:=23;
     themap[4,6]:=0;
     themap[4,7]:=0;
     themap[4,8]:=0;
     themap[4,9]:=0;
     themap[4,10]:=22;
     themap[4,11]:=14;
     themap[4,12]:=21;
     themap[4,13]:=0;
     themap[4,14]:=0;
     themap[5,1]:=0;
     themap[5,2]:=0;
     themap[5,3]:=16;
     themap[5,4]:=14;
     themap[5,5]:=18;
     themap[5,6]:=0;
     themap[5,7]:=0;
     themap[5,8]:=0;
     themap[5,9]:=0;
     themap[5,10]:=0;
     themap[5,11]:=20;
     themap[5,12]:=0;
     themap[5,13]:=0;
     themap[5,14]:=0;
     themap[6,1]:=0;
     themap[6,2]:=19;
     themap[6,3]:=14;
     themap[6,4]:=17;
     themap[6,5]:=18;
     themap[6,6]:=0;
     themap[6,7]:=0;
     themap[6,8]:=0;
     themap[6,9]:=0;
     themap[6,10]:=0;
     themap[6,11]:=20;
     themap[6,12]:=0;
     themap[6,13]:=0;
     themap[6,14]:=0;
     themap[7,1]:=0;
     themap[7,2]:=16;
     themap[7,3]:=18;
     themap[7,4]:=0;
     themap[7,5]:=20;
     themap[7,6]:=0;
     themap[7,7]:=0;
     themap[7,8]:=0;
     themap[7,9]:=0;
     themap[7,10]:=0;
     themap[7,11]:=20;
     themap[7,12]:=0;
     themap[7,13]:=0;
     themap[7,14]:=0;
     themap[8,1]:=0;
     themap[8,2]:=16;
     themap[8,3]:=14;
     themap[8,4]:=24;
     themap[8,5]:=14;
     themap[8,6]:=24;
     themap[8,7]:=24;
     themap[8,8]:=24;
     themap[8,9]:=24;
     themap[8,10]:=24;
     themap[8,11]:=21;
     themap[8,12]:=0;
     themap[8,13]:=0;
     themap[8,14]:=0;
     themap[9,1]:=0;
     themap[9,2]:=16;
     themap[9,3]:=18;
     themap[9,4]:=0;
     themap[9,5]:=20;
     themap[9,6]:=0;
     themap[9,7]:=0;
     themap[9,8]:=0;
     themap[9,9]:=0;
     themap[9,10]:=0;
     themap[9,11]:=0;
     themap[9,12]:=0;
     themap[9,13]:=0;
     themap[9,14]:=0;
     themap[10,1]:=0;
     themap[10,2]:=16;
     themap[10,3]:=14;
     themap[10,4]:=24;
     themap[10,5]:=18;
     themap[10,6]:=0;
     themap[10,7]:=0;
     themap[10,8]:=19;
     themap[10,9]:=15;
     themap[10,10]:=24;
     themap[10,11]:=15;
     themap[10,12]:=23;
     themap[10,13]:=0;
     themap[10,14]:=0;
     themap[11,1]:=0;
     themap[11,2]:=16;
     themap[11,3]:=18;
     themap[11,4]:=0;
     themap[11,5]:=20;
     themap[11,6]:=0;
     themap[11,7]:=0;
     themap[11,8]:=16;
     themap[11,9]:=21;
     themap[11,10]:=0;
     themap[11,11]:=22;
     themap[11,12]:=18;
     themap[11,13]:=0;
     themap[11,14]:=0;
     themap[12,1]:=0;
     themap[12,2]:=16;
     themap[12,3]:=14;
     themap[12,4]:=24;
     themap[12,5]:=14;
     themap[12,6]:=24;
     themap[12,7]:=24;
     themap[12,8]:=18;
     themap[12,9]:=0;
     themap[12,10]:=0;
     themap[12,11]:=0;
     themap[12,12]:=20;
     themap[12,13]:=0;
     themap[12,14]:=0;
     themap[13,1]:=0;
     themap[13,2]:=16;
     themap[13,3]:=18;
     themap[13,4]:=0;
     themap[13,5]:=20;
     themap[13,6]:=0;
     themap[13,7]:=0;
     themap[13,8]:=16;
     themap[13,9]:=23;
     themap[13,10]:=0;
     themap[13,11]:=19;
     themap[13,12]:=18;
     themap[13,13]:=0;
     themap[13,14]:=0;
     themap[14,1]:=0;
     themap[14,2]:=22;
     themap[14,3]:=14;
     themap[14,4]:=24;
     themap[14,5]:=21;
     themap[14,6]:=0;
     themap[14,7]:=0;
     themap[14,8]:=22;
     themap[14,9]:=17;
     themap[14,10]:=24;
     themap[14,11]:=17;
     themap[14,12]:=21;
     themap[14,13]:=0;
     themap[14,14]:=0;
     themap[15,1]:=0;
     themap[15,2]:=0;
     themap[15,3]:=20;
     themap[15,4]:=0;
     themap[15,5]:=0;
     themap[15,6]:=0;
     themap[15,7]:=0;
     themap[15,8]:=0;
     themap[15,9]:=0;
     themap[15,10]:=0;
     themap[15,11]:=0;
     themap[15,12]:=0;
     themap[15,13]:=0;
     themap[15,14]:=0;
     themap[16,1]:=0;
     themap[16,2]:=0;
     themap[16,3]:=20;
     themap[16,4]:=0;
     themap[16,5]:=0;
     themap[16,6]:=0;
     themap[16,7]:=0;
     themap[16,8]:=0;
     themap[16,9]:=0;


     themap[16,10]:=0;
     themap[16,11]:=0;
     themap[16,12]:=0;
     themap[16,13]:=0;
     themap[16,14]:=0;
     themap[17,1]:=0;
     themap[17,2]:=0;
     themap[17,3]:=22;
     themap[17,4]:=15;
     themap[17,5]:=23;
     themap[17,6]:=0;
     themap[17,7]:=0;
     themap[17,8]:=0;
     themap[17,9]:=0;
     themap[17,10]:=19;
     themap[17,11]:=15;
     themap[17,12]:=23;
     themap[17,13]:=0;
     themap[17,14]:=0;
     themap[18,1]:=0;
     themap[18,2]:=0;
     themap[18,3]:=0;
     themap[18,4]:=22;
     themap[18,5]:=17;
     themap[18,6]:=24;
     themap[18,7]:=24;
     themap[18,8]:=24;
     themap[18,9]:=24;
     themap[18,10]:=14;
     themap[18,11]:=14;
     themap[18,12]:=18;
     themap[18,13]:=0;
     themap[18,14]:=0;
     themap[19,1]:=0;
     themap[19,2]:=0;
     themap[19,3]:=0;
     themap[19,4]:=0;
     themap[19,5]:=0;
     themap[19,6]:=0;
     themap[19,7]:=0;
     themap[19,8]:=0;
     themap[19,9]:=0;
     themap[19,10]:=22;
     themap[19,11]:=17;
     themap[19,12]:=21;
     themap[19,13]:=0;
     themap[19,14]:=0;
     themap[20,1]:=0;
     themap[20,2]:=0;
     themap[20,3]:=0;
     themap[20,4]:=0;
     themap[20,5]:=0;
     themap[20,6]:=0;
     themap[20,7]:=0;
     themap[20,8]:=0;
     themap[20,9]:=0;
     themap[20,10]:=0;
     themap[20,11]:=0;
     themap[20,12]:=0;
     themap[20,13]:=0;
     themap[20,14]:=0;

     savemap(mapdir+'/dungeon.map',themap);

     {dungeon.cod}
     themap[1,1]:=1;
     themap[1,2]:=1;
     themap[1,3]:=1;
     themap[1,4]:=1;
     themap[1,5]:=1;
     themap[1,6]:=1;
     themap[1,7]:=1;
     themap[1,8]:=1;
     themap[1,9]:=1;
     themap[1,10]:=1;
     themap[1,11]:=1;
     themap[1,12]:=1;
     themap[1,13]:=1;
     themap[1,14]:=1;
     themap[2,1]:=1;
     themap[2,2]:=1;
     themap[2,3]:=1;
     themap[2,4]:=1;
     themap[2,5]:=1;
     themap[2,6]:=1;
     themap[2,7]:=1;
     themap[2,8]:=1;
     themap[2,9]:=1;
     themap[2,10]:=0;
     themap[2,11]:=0;
     themap[2,12]:=0;
     themap[2,13]:=1;
     themap[2,14]:=1;
     themap[3,1]:=1;
     themap[3,2]:=1;
     themap[3,3]:=1;
     themap[3,4]:=1;
     themap[3,5]:=1;
     themap[3,6]:=1;
     themap[3,7]:=1;
     themap[3,8]:=1;
     themap[3,9]:=1;
     themap[3,10]:=0;
     themap[3,11]:=0;
     themap[3,12]:=0;
     themap[3,13]:=1;
     themap[3,14]:=1;
     themap[4,1]:=1;
     themap[4,2]:=1;
     themap[4,3]:=0;
     themap[4,4]:=0;
     themap[4,5]:=0;
     themap[4,6]:=1;
     themap[4,7]:=1;
     themap[4,8]:=1;
     themap[4,9]:=1;
     themap[4,10]:=0;
     themap[4,11]:=17;
     themap[4,12]:=0;
     themap[4,13]:=1;
     themap[4,14]:=1;
     themap[5,1]:=1;
     themap[5,2]:=1;
     themap[5,3]:=0;
     themap[5,4]:=0;
     themap[5,5]:=0;
     themap[5,6]:=1;
     themap[5,7]:=1;
     themap[5,8]:=1;
     themap[5,9]:=1;
     themap[5,10]:=1;
     themap[5,11]:=0;
     themap[5,12]:=1;
     themap[5,13]:=1;
     themap[5,14]:=1;
     themap[6,1]:=1;
     themap[6,2]:=0;
     themap[6,3]:=0;
     themap[6,4]:=0;
     themap[6,5]:=0;
     themap[6,6]:=1;
     themap[6,7]:=1;
     themap[6,8]:=1;
     themap[6,9]:=1;
     themap[6,10]:=1;
     themap[6,11]:=0;
     themap[6,12]:=1;
     themap[6,13]:=1;
     themap[6,14]:=1;
     themap[7,1]:=1;
     themap[7,2]:=0;
     themap[7,3]:=0;
     themap[7,4]:=1;
     themap[7,5]:=0;
     themap[7,6]:=1;
     themap[7,7]:=1;
     themap[7,8]:=1;
     themap[7,9]:=1;
     themap[7,10]:=1;
     themap[7,11]:=0;
     themap[7,12]:=1;
     themap[7,13]:=1;
     themap[7,14]:=1;
     themap[8,1]:=1;
     themap[8,2]:=0;
     themap[8,3]:=0;
     themap[8,4]:=0;
     themap[8,5]:=0;
     themap[8,6]:=0;
     themap[8,7]:=0;
     themap[8,8]:=0;
     themap[8,9]:=0;
     themap[8,10]:=0;
     themap[8,11]:=0;
     themap[8,12]:=1;
     themap[8,13]:=1;
     themap[8,14]:=1;
     themap[9,1]:=1;
     themap[9,2]:=0;
     themap[9,3]:=0;
     themap[9,4]:=1;
     themap[9,5]:=0;
     themap[9,6]:=1;
     themap[9,7]:=1;
     themap[9,8]:=1;
     themap[9,9]:=1;
     themap[9,10]:=1;
     themap[9,11]:=1;
     themap[9,12]:=1;
     themap[9,13]:=1;
     themap[9,14]:=1;
     themap[10,1]:=1;
     themap[10,2]:=0;
     themap[10,3]:=0;
     themap[10,4]:=0;
     themap[10,5]:=0;
     themap[10,6]:=1;
     themap[10,7]:=1;
     themap[10,8]:=0;
     themap[10,9]:=0;
     themap[10,10]:=0;
     themap[10,11]:=0;
     themap[10,12]:=0;
     themap[10,13]:=1;
     themap[10,14]:=1;
     themap[11,1]:=1;
     themap[11,2]:=0;
     themap[11,3]:=0;
     themap[11,4]:=1;
     themap[11,5]:=0;
     themap[11,6]:=1;
     themap[11,7]:=1;
     themap[11,8]:=0;
     themap[11,9]:=0;
     themap[11,10]:=1;
     themap[11,11]:=0;
     themap[11,12]:=0;
     themap[11,13]:=1;
     themap[11,14]:=1;
     themap[12,1]:=1;
     themap[12,2]:=0;
     themap[12,3]:=0;
     themap[12,4]:=0;
     themap[12,5]:=0;
     themap[12,6]:=0;
     themap[12,7]:=0;
     themap[12,8]:=16;
     themap[12,9]:=1;
     themap[12,10]:=1;
     themap[12,11]:=1;
     themap[12,12]:=0;
     themap[12,13]:=1;
     themap[12,14]:=1;
     themap[13,1]:=1;
     themap[13,2]:=0;
     themap[13,3]:=0;
     themap[13,4]:=1;
     themap[13,5]:=0;
     themap[13,6]:=1;
     themap[13,7]:=1;
     themap[13,8]:=0;
     themap[13,9]:=0;
     themap[13,10]:=1;
     themap[13,11]:=15;
     themap[13,12]:=0;
     themap[13,13]:=1;
     themap[13,14]:=1;
     themap[14,1]:=1;
     themap[14,2]:=0;
     themap[14,3]:=0;
     themap[14,4]:=0;
     themap[14,5]:=0;
     themap[14,6]:=1;
     themap[14,7]:=1;
     themap[14,8]:=0;
     themap[14,9]:=0;
     themap[14,10]:=0;
     themap[14,11]:=0;
     themap[14,12]:=0;
     themap[14,13]:=1;
     themap[14,14]:=1;
     themap[15,1]:=1;
     themap[15,2]:=1;
     themap[15,3]:=0;
     themap[15,4]:=1;
     themap[15,5]:=1;
     themap[15,6]:=1;
     themap[15,7]:=1;
     themap[15,8]:=1;
     themap[15,9]:=1;
     themap[15,10]:=1;
     themap[15,11]:=1;
     themap[15,12]:=1;
     themap[15,13]:=1;
     themap[15,14]:=1;
     themap[16,1]:=1;
     themap[16,2]:=1;
     themap[16,3]:=0;
     themap[16,4]:=1;
     themap[16,5]:=1;
     themap[16,6]:=1;
     themap[16,7]:=1;
     themap[16,8]:=1;
     themap[16,9]:=1;
     themap[16,10]:=1;
     themap[16,11]:=1;
     themap[16,12]:=1;
     themap[16,13]:=1;
     themap[16,14]:=1;
     themap[17,1]:=1;
     themap[17,2]:=1;
     themap[17,3]:=0;
     themap[17,4]:=0;
     themap[17,5]:=0;
     themap[17,6]:=1;
     themap[17,7]:=1;
     themap[17,8]:=1;
     themap[17,9]:=1;
     themap[17,10]:=0;
     themap[17,11]:=0;
     themap[17,12]:=0;
     themap[17,13]:=1;
     themap[17,14]:=1;
     themap[18,1]:=1;
     themap[18,2]:=1;
     themap[18,3]:=1;
     themap[18,4]:=19;
     themap[18,5]:=0;
     themap[18,6]:=0;
     themap[18,7]:=0;
     themap[18,8]:=0;
     themap[18,9]:=0;
     themap[18,10]:=0;
     themap[18,11]:=0;
     themap[18,12]:=0;
     themap[18,13]:=1;
     themap[18,14]:=1;
     themap[19,1]:=1;
     themap[19,2]:=1;
     themap[19,3]:=1;
     themap[19,4]:=1;
     themap[19,5]:=1;
     themap[19,6]:=1;
     themap[19,7]:=1;
     themap[19,8]:=1;
     themap[19,9]:=1;
     themap[19,10]:=0;
     themap[19,11]:=0;
     themap[19,12]:=0;
     themap[19,13]:=1;
     themap[19,14]:=1;
     themap[20,1]:=1;
     themap[20,2]:=1;
     themap[20,3]:=1;
     themap[20,4]:=1;
     themap[20,5]:=1;
     themap[20,6]:=1;
     themap[20,7]:=1;
     themap[20,8]:=1;
     themap[20,9]:=1;
     themap[20,10]:=1;
     themap[20,11]:=1;
     themap[20,12]:=1;
     themap[20,13]:=1;
     themap[20,14]:=1;

     savemap(mapdir+'/dungeon.cod',themap);

end;
{--------------------------------------------------------------------------}
procedure createcharts;

type

     chartrecord    =    record
                              value     :    array[1..20,1..2] of byte;
                              filename  :    array[1..20] of string;
                              number    :    array[1..20] of dicerecord;
                              diceroll  :    dicerecord;
                         end;
var
     thechart       :    chartrecord;
     error          :    boolean;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure savechart(filename:string;thechart:chartrecord);

var
     savefile   :    file of chartrecord;

begin
     assign(savefile,filename);
     rewrite(savefile);
     write(savefile,thechart);
     close(savefile);
     writeln(filename);
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

begin

     {wild.dat}
     with thechart do
          begin
               parse('2d10',diceroll);

               value[1,1]:=1;
               value[1,2]:=1;
               filename[1]:='roland.dat';
               parse('1',number[1]);

               value[2,1]:=2;
               value[2,2]:=2;
               filename[2]:='wyvern.dat';
               parse('1',number[2]);

               value[3,1]:=3;
               value[3,2]:=3;
               filename[3]:='centaur.dat';
               parse('1d3',number[3]);

               value[4,1]:=4;
               value[4,2]:=4;
               filename[4]:='spider.dat';
               parse('1d4',number[4]);

               value[5,1]:=5;
               value[5,2]:=5;
               filename[5]:='ant.dat';
               parse('1d6',number[5]);

               value[6,1]:=6;
               value[6,2]:=6;
               filename[6]:='beetle.dat';
               parse('1d4',number[6]);

               value[7,1]:=7;
               value[7,2]:=7;
               filename[7]:='berserke.dat';
               parse('1d3',number[7]);

               value[8,1]:=8;
               value[8,2]:=8;
               filename[8]:='orc.dat';
               parse('1d6',number[8]);

               value[9,1]:=9;
               value[9,2]:=9;
               filename[9]:='goblin.dat';
               parse('1d6',number[9]);

               value[10,1]:=10;
               value[10,2]:=10;
               filename[10]:='kobold.dat';
               parse('1d8',number[10]);

               value[11,1]:=11;
               value[11,2]:=11;
               filename[11]:='kobold.dat';
               parse('1d8',number[11]);

               value[12,1]:=12;
               value[12,2]:=12;
               filename[12]:='kobold.dat';
               parse('1d8',number[12]);

               value[13,1]:=13;
               value[13,2]:=13;
               filename[13]:='goblin.dat';
               parse('1d6',number[13]);

               value[14,1]:=14;
               value[14,2]:=14;
               filename[14]:='orc.dat';
               parse('1d6',number[14]);

               value[15,1]:=15;
               value[15,2]:=15;
               filename[15]:='wolf.dat';
               parse('1d4',number[15]);

               value[16,1]:=16;
               value[16,2]:=16;
               filename[16]:='bee.dat';
               parse('1d6',number[16]);

               value[17,1]:=17;
               value[17,2]:=17;
               filename[17]:='centiped.dat';
               parse('1d6',number[17]);

               value[18,1]:=18;
               value[18,2]:=18;
               filename[18]:='bandit.dat';
               parse('1d4',number[18]);

               value[19,1]:=19;
               value[19,2]:=19;
               filename[19]:='ogre.dat';
               parse('1d2',number[19]);

               value[20,1]:=20;
               value[20,2]:=20;
               filename[20]:='giant.dat';
               parse('1',number[20]);
          end;

     savechart(chartdir+'/wild.dat',thechart);

     {cave.dat}
     with thechart do
          begin
               parse('1d12',diceroll);

               value[1,1]:=1;
               value[1,2]:=1;
               filename[1]:='gargoyle.dat';
               parse('1d4',number[1]);




               value[2,1]:=2;
               value[2,2]:=2;
               filename[2]:='slime.dat';
               parse('1d8',number[2]);

               value[3,1]:=3;
               value[3,2]:=3;
               filename[3]:='ooze.dat';
               parse('1d8',number[3]);

               value[4,1]:=4;
               value[4,2]:=4;
               filename[4]:='spider.dat';
               parse('1d6',number[4]);

               value[5,1]:=5;
               value[5,2]:=5;
               filename[5]:='werewolf.dat';
               parse('1d6',number[5]);




               value[6,1]:=6;
               value[6,2]:=6;
               filename[6]:='ogre.dat';
               parse('1d4',number[6]);

               value[7,1]:=7;
               value[7,2]:=7;
               filename[7]:='baboon.dat';
               parse('1d6',number[7]);

               value[8,1]:=8;
               value[8,2]:=8;
               filename[8]:='centiped.dat';
               parse('2d4',number[8]);

               value[9,1]:=9;
               value[9,2]:=9;
               filename[9]:='minotaur.dat';
               parse('1d2',number[9]);

               value[10,1]:=10;
               value[10,2]:=10;
               filename[10]:='troll.dat';
               parse('1d2',number[10]);

               value[11,1]:=11;
               value[11,2]:=11;
               filename[11]:='shadow.dat';
               parse('1d6',number[11]);

               value[12,1]:=12;
               value[12,2]:=12;
               filename[12]:='skeleton.dat';
               parse('1d8',number[12]);
          end;

     savechart(chartdir+'/cave.dat',thechart);

     {castle.dat}
     with thechart do
          begin
               parse('1',diceroll);

               value[1,1]:=1;
               value[1,2]:=1;
               filename[1]:='soldier.dat';
               parse('1d4+4',number[1]);
          end;

     savechart(chartdir+'/castle.dat',thechart);

     {dungeon.dat}
     with thechart do
          begin
               parse('1d8',diceroll);

               value[1,1]:=1;
               value[1,2]:=2;
               filename[1]:='shadow.dat';
               parse('2d4',number[1]);

               value[2,1]:=3;
               value[2,2]:=3;
               filename[2]:='skeleton.dat';
               parse('1d8',number[2]);

               value[3,1]:=4;
               value[3,2]:=4;
               filename[3]:='slime.dat';
               parse('1d4',number[3]);

               value[4,1]:=5;
               value[4,2]:=5;
               filename[4]:='ooze.dat';
               parse('1d4',number[4]);

               value[5,1]:=6;
               value[5,2]:=6;
               filename[5]:='gargoyle.dat';
               parse('1',number[5]);

               value[6,1]:=7;
               value[6,2]:=7;
               filename[6]:='ghoul.dat';
               parse('2d4',number[6]);

               value[7,1]:=8;
               value[7,2]:=8;
               filename[7]:='wraith.dat';
               parse('1d8',number[7]);
          end;

     savechart(chartdir+'/dungeon.dat',thechart);


end;
{--------------------------------------------------------------------------}
procedure createsavegame;

var
     player    :    character_t;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure savegame(filename:string;player:character_t);

var
     savefile   :    file of character_t;

begin
     assign(savefile,filename);
     rewrite(savefile);
     write(savefile,player);
     close(savefile);
     writeln(filename);
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}


begin

     with player do
          begin
               name:='Landon';
               picfile:='mplayer.bmp';
               sex:='M';
               level:=2;
               endurance:=16;
               endurancemax:=16;
               experience:=0;
               coins:=200;
               numitems:=5;

               with item[1] do
                  begin
                     name:='sword';
                     item_type:=1;
                     value:=18;
                     picfile:='sword.bmp';
                     msg:='This is a sturdy sword';
                     data[1]:=0;
                     data[2]:=0;
                     data[3]:=1; data[4]:=2; data[5]:=8;
                     data[6]:=0; data[7]:=0; data[8]:=0;
                  end;
               with item[2] do
                  begin
                     name:='shield';
                     item_type:=2;
                     value:=20;
                     picfile:='shield.bmp';
                     msg:='This is an average shield';
                     data[1]:=4;
                     data[2]:=5;
                     data[3]:=0; data[4]:=0;
                     data[5]:=0; data[6]:=0;
                     data[7]:=0; data[8]:=0;
                  end;
               with item[3] do
                  begin
                     name:='plate mail';
                     item_type:=2;
                     value:=80;
                     picfile:='plate.bmp';
                     msg:='This armor provides good protection';
                     data[1]:=2;
                     data[2]:=30;
                     data[3]:=0; data[4]:=0;
                     data[5]:=0; data[6]:=0;
                     data[7]:=0; data[8]:=0;
                  end;
               with item[4] do
                  begin
                     name:='blue potion';
                     item_type:=3;
                     value:=100;
                     picfile:='potion-blue.bmp';
                     msg:='potion-blue.txt';
                     data[1]:=2; data[2]:=4; data[3]:=10;
                     data[4]:=4; data[5]:=2; data[6]:=3;
                     data[7]:=0; data[8]:=0;
                  end;
               with item[5] do
                  begin
                     name:='red potion';
                     item_type:=3;
                     value:=100;
                     picfile:='potion-red.bmp';
                     msg:='potion-red.txt';
                     data[1]:=1; data[2]:=4; data[3]:=12;
                     data[4]:=0; data[5]:=0; data[6]:=0;
                     data[7]:=0; data[8]:=0;
                  end;               
               numspells:=0;
               strength:=10;
               dexterity:=16;
               stages:=[];
               charges:=0;
               chargemax:=0;
          end;

     savegame(savedir+'/'+savedefault,player);

end;
{--------------------------------------------------------------------------}
procedure createitems;

var
     item      :    item_t;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure saveitem(filename:string;item:item_t);

var
     savefile   :    file of item_t;

begin
     assign(savefile,filename);
     rewrite(savefile);
     write(savefile,item);
     close(savefile);
     writeln(filename);
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

begin

{weapons}

   with item do
      begin
         name:='sword';
         item_type:=1;
         value:=18;
         picfile:='sword.bmp';
         msg:='This is a sturdy sword';
         data[1]:=0;
         data[2]:=0;
         data[3]:=1; data[4]:=2; data[5]:=8;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/sword.dat',item);

   with item do
      begin
         name:='battle axe';
         item_type:=1;
         value:=20;
         picfile:='axe.bmp';
         msg:='This is a large battle axe';
         data[1]:=2;
         data[2]:=0;
         data[3]:=1; data[4]:=4; data[5]:=10;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/axe.dat',item);

   with item do
      begin
         name:='dagger';
         item_type:=1;
         value:=4;
         picfile:='dagger.bmp';
         msg:='This is your typical dagger';
         data[1]:=0;
         data[2]:=0;
         data[3]:=1; data[4]:=2; data[5]:=4;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/dagger.dat',item);

   with item do
      begin
         name:='club';
         item_type:=1;
         value:=2;
         picfile:='club.bmp';
         msg:='This is a simple club';
         data[1]:=1;
         data[2]:=0;
         data[3]:=1; data[4]:=1; data[5]:=4;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/club.dat',item);

   with item do
      begin
         name:='staff';
         item_type:=1;
         value:=8;
         picfile:='staff.bmp';
         msg:='This is a finely-made staff';
         data[1]:=1;
         data[2]:=3;
         data[3]:=1; data[4]:=2; data[5]:=6;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/staff.dat',item);

   with item do
      begin
         name:='war hammer';
         item_type:=1;
         value:=12;
         picfile:='hammer.bmp';
         msg:='This is a heavy war hammer';
         data[1]:=1;
         data[2]:=1;
         data[3]:=1; data[4]:=3; data[5]:=6;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/hammer.dat',item);

   with item do
      begin
         name:='Luckblade';
         item_type:=1;
         value:=4500;
         picfile:='magicswd.bmp';
         msg:='This magical sword cuts cleanly and accurately';
         data[1]:=4;
         data[2]:=18;
         data[3]:=1; data[4]:=6; data[5]:=12;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/magicswd.dat',item);

   with item do
      begin
         name:='Wand of Dragon Fire';
         item_type:=1;
         value:=6200;
         picfile:='flamewnd.bmp';
         msg:='This wand burns enemies to a crisp';
         data[1]:=5;
         data[2]:=20;
         data[3]:=2; data[4]:=8; data[5]:=24;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/flamewnd.dat',item);

   with item do
      begin
         name:='Trollsfire';
         item_type:=1;
         value:=7500;
         picfile:='trollsfire.bmp';
         msg:='This flaming sword lights with green flames';
         data[1]:=4;
         data[2]:=24;
         data[3]:=3; data[4]:=10; data[5]:=24;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/trollsfire.dat',item);

   with item do
      begin
         name:='Sword of Chaos';
         item_type:=1;
         value:=7280;
         picfile:='chaos.bmp';
         msg:='This sword strikes with the power of darkness';
         data[1]:=4;
         data[2]:=22;
         data[3]:=81; data[4]:=10; data[5]:=24;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/chaos.dat',item);

{armor}

   with item do
      begin
         name:='shield';
         item_type:=2;
         value:=20;
         picfile:='shield.bmp';
         msg:='This is an average shield';
         data[1]:=4;
         data[2]:=5;
         data[3]:=0; data[4]:=0;
         data[5]:=0; data[6]:=0;
         data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/shield.dat',item);

   with item do
      begin
         name:='chain mail';
         item_type:=2;
         value:=65;
         picfile:='chain.bmp';
         msg:='This armor provides decent protection';
         data[1]:=2;
         data[2]:=20;
         data[3]:=0; data[4]:=0;
         data[5]:=0; data[6]:=0;
         data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/chain.dat',item);

   with item do
      begin
         name:='plate mail';
         item_type:=2;
         value:=80;
         picfile:='plate.bmp';
         msg:='This armor provides good protection';
         data[1]:=2;
         data[2]:=30;
         data[3]:=0; data[4]:=0;
         data[5]:=0; data[6]:=0;
         data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/shield.dat',item);

   with item do
      begin
         name:='glimmering gem shield';
         item_type:=2;
         value:=4000;
         picfile:='magicshl.bmp';
         msg:='This magical shield increases your defense greatly';
         data[1]:=5;
         data[2]:=24;
         data[3]:=0; data[4]:=0;
         data[5]:=0; data[6]:=0;
         data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/shield.dat',item);

{potions}

   with item do
      begin
         name:='blue potion';
         item_type:=3;
         value:=100;
         picfile:='potion-blue.bmp';
         msg:='potion-blue.txt';
         data[1]:=2; data[2]:=4; data[3]:=10;
         data[4]:=4; data[5]:=2; data[6]:=3;
         data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/potion-blue.dat',item);

   with item do
      begin
         name:='red potion';
         item_type:=3;
         value:=100;
         picfile:='potion-red.bmp';
         msg:='potion-red.txt';
         data[1]:=1; data[2]:=4; data[3]:=12;
         data[4]:=0; data[5]:=0; data[6]:=0;
         data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/potion-red.dat',item);

   with item do
      begin
         name:='green potion';
         item_type:=3;
         value:=300;
         picfile:='potion-green.bmp';
         msg:='potion-green.txt';
         data[1]:=2; data[2]:=15; data[3]:=25;
         data[4]:=4; data[5]:=3; data[6]:=6;
         data[7]:=1; data[8]:=100;
      end;
   saveitem(itemdir+'/potion-green.dat',item);


end;
{--------------------------------------------------------------------------}

begin {main}

     clrscr;
     gotoxy(75,1);
     writeln(version);
     writeln('WARNING:  this program will recreate data files for Ice Queen',
             ' that might have been destroyed by other utilities.');
     writeln;
     writeln('Restore all defaults? (y/n)');
     repeat
          ans:=readkey;
     until (ans in ['y','Y','n','N']);
     writeln;
     if (ans in ['n','N']) then
          begin
               writeln('Files unchanged.');
               writeln('Goodbye.');

          end
     else
          begin
               writeln('Creating files, please wait.');

               createmonsters;
               createmaps;
               createcharts;
               createsavegame;
               createitems;
               writeln;
               writeln('Press any key to continue.');
          end;


end. {main}
