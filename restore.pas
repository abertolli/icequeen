{
	RESTORE.PAS
	Ice Queen Defaults Program
	Resets all default settings for Ice Queen
	Copyright (C) 1999-2005 Angelo Bertolli
}

program Restore;

{This program resets all defaults, creating monster files, map and code files,
wandering monster charts, and the config.dat file to go with them.}

uses crt, dataio, dice;

const
    {$I const.inc}

var
     ch             :    char;
     ans            :    char;
     loop           :    integer;
{--------------------------------------------------------------------------}
procedure createmonster(
               monsterid      :    string;
               name           :    string;
               picfile        :    string;
               sex            :    char;
               alignment      :    char;
               hitdice        :    byte;
               hpbonus        :    shortint;
               armorclass     :    integer;
               damage         :    string; {dice}
               attacktype     :    string;
               savingthrow    :    byte;
               morale         :    byte;
               xpvalue        :    longint;
               treasure       :    string; {dice}
               numspells      :    byte;
               spellstr       :    string);

var
     int            :    integer;
     monster        :    monsterrecord;
     spell          :    spellarray;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure savemonster(monsterid:string;monster:monsterrecord);

var
        savefile        : text;
        loop            : integer;

begin
     assign(savefile,monsterdata);
     append(savefile);
     writeln(savefile,'~'+monsterid);
     with monster do
        begin
        writeln(savefile,name);
        writeln(savefile,picfile);
        writeln(savefile,sex);
        writeln(savefile,alignment);
        writeln(savefile,hitdice);
        writeln(savefile,hpbonus);
        {endurance}
        {endurancemax}
        writeln(savefile,armorclass);
        writeln(savefile,thac0);
        writeln(savefile,damage);
        writeln(savefile,attacktype);
        writeln(savefile,savingthrow);
        writeln(savefile,morale);
        writeln(savefile,xpvalue);
        writeln(savefile,treasure);
        {coins}
        writeln(savefile,numspells);
        for loop:=1 to numspells do
             writeln(savefile,spell[loop]);
        end;
     writeln(savefile,'~');
     close(savefile);
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

begin

     for loop:=1 to numspells do
          begin
               case spellstr[loop] of
                    '1':spell[loop]:=icestorm;
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
                    writeln(name,': spell ',spellstr[loop],' not found.');
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

     savemonster(monsterid,monster);
     write(' ',monsterid);

end;
{--------------------------------------------------------------------------}
procedure createmonsters;

var
    savefile    :   file;


begin

    assign(savefile,monsterdata);
    if exist(monsterdata) then
    begin
        reset(savefile);
        truncate(savefile);
    end
    else
    begin
        rewrite(savefile);
    end;
    close(savefile);

{name,file,picture,gender,alignment,HD,+HD,AC,DMG,attack,save,morale,basexpv,coins,numspells,spells}
{
'1':icestorm        '2':fireblast       '3':web
'4':callwild        '5':heal            '6':courage
'7':freeze          '8':obliterate      '9':icicle
'A':power           'B':shatter         'C':glacier
'D':dragonbreath    'E':resistfire      'F':resistcold
}
write(monsterdata,':');
createmonster('wyvern','wyvern','wyvern.bmp','M','C',7,0,3,'3d8','thrashes',14,9,850,'2d8',0,'');
createmonster('centaur','centaur','centaur.bmp','M','N',4,0,5,'1d6','kicks',14,8,75,'2d6',0,'');
createmonster('spider','crab spider','spider.bmp','M','N',2,0,7,'1d8','bites',16,7,25,'0',0,'');
createmonster('werewolf','werewolf','werewolf.bmp','M','C',4,0,5,'2d4','swipes',14,8,125,'2d6',0,'');
createmonster('ant','giant ant','ant.bmp','M','N',4,0,3,'2d6','bites',16,12,125,'0',0,'');
createmonster('beetle','fire beetle','beetle.bmp','M','N',1,2,4,'2d4','bites',16,7,15,'0',0,'');
createmonster('wolf','wolf','wolf.bmp','M','N',2,2,7,'1d6','bites',16,8,25,'0',0,'');
createmonster('berserker','berserker','berserke.bmp','M','C',1,1,7,'1d10+2','smashes',16,12,19,'2d6',0,'');
createmonster('goblin','goblin','goblin.bmp','M','C',1,-1,6,'1d6','spears',17,6,5,'3d6',0,'');
createmonster('kobold','kobold','kobold.bmp','M','C',1,-4,7,'1d4-1','pokes',17,4,1,'4d10',0,'');
createmonster('orc','orc','orc.bmp','M','C',1,0,6,'1d8','slashes',16,8,10,'3d6',0,'');
createmonster('bandit','bandit','bandit.bmp','M','C',1,-2,6,'1d6','attacks',15,6,5,'3d8+8',0,'');
createmonster('ogre','ogre','ogre.bmp','M','C',4,1,5,'1d8+2','clubs',14,10,125,'4d8',0,'');
createmonster('baboon','rock baboon','baboon.bmp','M','N',2,0,6,'1d4','scratches',16,8,20,'1d4',0,'');
createmonster('bee','giant bee','bee.bmp','M','N',1,-4,7,'1d3','stings',16,9,1,'0',0,'');
createmonster('centipede','gnt centipede','centiped.bmp','M','N',1,-4,9,'1d3','bites',17,7,1,'0',0,'');
createmonster('minotaur','minotaur','minotaur.bmp','M','C',6,0,6,'2d6','gores',14,12,275,'2d8',0,'');
createmonster('troll','troll','troll.bmp','M','C',6,3,4,'2d6+2','attacks',14,10,650,'3d6',0,'');
createmonster('giant','hill giant','giant.bmp','M','C',8,0,4,'2d8','decimates',12,8,650,'1000',0,'');
createmonster('displacer','displacer','displace.bmp','M','N',6,0,4,'3d4','swipes',14,8,500,'1d20',0,'');
createmonster('manticore','manticore','manticor.bmp','M','C',6,1,4,'3d6','punctures',14,9,650,'1d100',0,'');
createmonster('salamander','frost lizard','salamand.bmp','F','C',12,0,3,'4d6','claws',10,9,2125,'1d10+200',1,'F');
createmonster('soldier','Winter Soldier','soldier.bmp','M','N',2,1,3,'1d6+1','spears',16,10,25,'2d6',0,'');
createmonster('dragon','Red Dragon','dragon.bmp','M','C',10,0,-1,'4d8','claws',10,12,2500,'10d100+5000',2,'DDDE');
createmonster('icequeen','Ice Queen','icequeen.bmp','F','C',12,0,9,'1d4+1','stabs',10,12,6500,'10d10+10',6,'11179C');
createmonster('roland','Roland McDoland','roland.bmp','M','C',20,20,-10,'2d6+3','kicks',1,12,18500,'100d100+100',1,'8');
createmonster('slime','green slime','slime.bmp','M','N',2,0,20,'1d4','attacks',16,7,30,'0',0,'');
createmonster('shadow','shadow','shadow.bmp','M','C',2,2,7,'1d4','attacks',16,12,35,'0',0,'');
createmonster('skeleton','skeleton','skeleton.bmp','M','C',1,0,7,'1d8','slashes',16,12,10,'1d6',0,'');
createmonster('gargoyle','gargoyle','gargoyle.bmp','M','C',4,0,5,'2d4','claws',12,11,175,'1d4',0,'');
createmonster('ghoul','ghoul','ghoul.bmp','M','C',2,0,6,'2d3','gropes',16,9,25,'1d6',0,'');
createmonster('ooze','purple ooze','ooze.bmp','M','N',1,0,9,'1d4','attacks',16,5,10,'1d4',0,'');
createmonster('wraith','wraith','wraith.bmp','M','C',4,0,3,'1d6','attacks',14,11,175,'0',0,'');
createmonster('dilvish','Dilvish','dilvish.bmp','M','N',4,0,1,'1d8+2','slashes',11,10,125,'2d10',2,'32');
createmonster('prudence','Prudence','prudence.bmp','F','L',5,5,4,'1d6+2','spears',14,12,175,'1d10',0,'');
createmonster('spirit','Spirit','spirit.bmp','F','N',4,0,3,'1d6','hits',15,10,125,'1d10',1,'5');
createmonster('marcus','Marcus','marcus.bmp','M','N',5,0,4,'1d6+3','attacks',13,8,175,'5d10',0,'');
createmonster('baltar','Baltar','baltar.bmp','M','C',5,5,2,'1d8+3','slices',14,10,175,'3d10',0,'');
createmonster('succubus','Succubus','succubus.bmp','F','C',6,0,0,'1d6','claws',14,12,500,'1d10+10',0,'');
createmonster('brawler','Brawler','brawler.bmp','M','N',2,1,9,'1d2+1','punches',16,8,25,'1d10',0,'');
createmonster('knight','Ice Knight','knight.bmp','M','C',6,6,2,'1d8+1','strikes',14,11,350,'4d8',0,'');
writeln;

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

var
     thechart       :    chartrecord;
     error          :    boolean;
     savefile       :    file;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure clearchart(var chart:chartrecord);

var
    loop        :   integer;

begin
    with chart do
    begin
        diceroll:='0';
        for loop:=1 to 20 do
        begin
            value[loop,1]:=0;
            value[loop,2]:=0;
            number[loop]:='0';
            monsterid[loop]:='none';
        end;
    end;
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure savechart(chartid:string;thechart:chartrecord);

var
     savefile   :    text;
     loop       :    integer;

begin
     assign(savefile,chartdata);
     append(savefile);
     writeln(savefile,'~'+chartid);
     with thechart do
     begin
        writeln(savefile,diceroll);
        for loop:=1 to 20 do
            writeln(savefile,value[loop,1],' ',value[loop,2],' ',number[loop],':',monsterid[loop]);
        writeln(savefile,'~');
     end;
     close(savefile);
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

begin
    assign(savefile,chartdata);
    if exist(chartdata) then
    begin
        reset(savefile);
        truncate(savefile);
    end
    else
    begin
        rewrite(savefile);
    end;
    close(savefile);

    write(chartdata,':');
    clearchart(thechart);
     with thechart do
          begin
               diceroll:='2d10';

               value[1,1]:=1;
               value[1,2]:=1;
               number[1]:='1';
               monsterid[1]:='roland';

               value[2,1]:=2;
               value[2,2]:=2;
               number[2]:='1';
               monsterid[2]:='wyvern';

               value[3,1]:=3;
               value[3,2]:=3;
               number[3]:='1d3';
               monsterid[3]:='centaur';

               value[4,1]:=4;
               value[4,2]:=4;
               number[4]:='1d4';
               monsterid[4]:='spider';

               value[5,1]:=5;
               value[5,2]:=5;
               number[5]:='1d6';
               monsterid[5]:='ant';

               value[6,1]:=6;
               value[6,2]:=6;
               number[6]:='1d4';
               monsterid[6]:='beetle';

               value[7,1]:=7;
               value[7,2]:=7;
               number[7]:='1d3';
               monsterid[7]:='berserker';

               value[8,1]:=8;
               value[8,2]:=8;
               number[8]:='1d6';
               monsterid[8]:='orc';

               value[9,1]:=9;
               value[9,2]:=9;
               number[9]:='1d6';
               monsterid[9]:='goblin';

               value[10,1]:=10;
               value[10,2]:=10;
               number[10]:='1d8';
               monsterid[10]:='kobold';

               value[11,1]:=11;
               value[11,2]:=11;
               number[11]:='1d8';
               monsterid[11]:='kobold';

               value[12,1]:=12;
               value[12,2]:=12;
               number[12]:='1d8';
               monsterid[12]:='kobold';

               value[13,1]:=13;
               value[13,2]:=13;
               number[13]:='1d6';
               monsterid[13]:='goblin';

               value[14,1]:=14;
               value[14,2]:=14;
               number[14]:='1d6';
               monsterid[14]:='orc';

               value[15,1]:=15;
               value[15,2]:=15;
               number[15]:='1d4';
               monsterid[15]:='wolf';

               value[16,1]:=16;
               value[16,2]:=16;
               number[16]:='1d6';
               monsterid[16]:='bee';

               value[17,1]:=17;
               value[17,2]:=17;
               number[17]:='1d6';
               monsterid[17]:='centipede';

               value[18,1]:=18;
               value[18,2]:=18;
               number[18]:='1d4';
               monsterid[18]:='bandit';

               value[19,1]:=19;
               value[19,2]:=19;
               number[19]:='1d2';
               monsterid[19]:='ogre';

               value[20,1]:=20;
               value[20,2]:=20;
               number[20]:='1';
               monsterid[20]:='giant';
          end;
     savechart('wilderness',thechart);
     write(' wilderness');

    clearchart(thechart);
     with thechart do
          begin
               diceroll:='1d12';

               value[1,1]:=1;
               value[1,2]:=1;
               number[1]:='1d4';
               monsterid[1]:='gargoyle';

               value[2,1]:=2;
               value[2,2]:=2;
               number[2]:='1d8';
               monsterid[2]:='slime';

               value[3,1]:=3;
               value[3,2]:=3;
               monsterid[3]:='ooze';
               number[3]:='1d8';

               value[4,1]:=4;
               value[4,2]:=4;
               monsterid[4]:='spider';
               number[4]:='1d6';

               value[5,1]:=5;
               value[5,2]:=5;
               monsterid[5]:='werewolf';
               number[5]:='1d6';

               value[6,1]:=6;
               value[6,2]:=6;
               monsterid[6]:='ogre';
               number[6]:='1d4';

               value[7,1]:=7;
               value[7,2]:=7;
               monsterid[7]:='baboon';
               number[7]:='1d6';

               value[8,1]:=8;
               value[8,2]:=8;
               monsterid[8]:='centipede';
               number[8]:='2d4';

               value[9,1]:=9;
               value[9,2]:=9;
               monsterid[9]:='minotaur';
               number[9]:='1d2';

               value[10,1]:=10;
               value[10,2]:=10;
               monsterid[10]:='troll';
               number[10]:='1d2';

               value[11,1]:=11;
               value[11,2]:=11;
               monsterid[11]:='shadow';
               number[11]:='1d6';

               value[12,1]:=12;
               value[12,2]:=12;
               monsterid[12]:='skeleton';
               number[12]:='1d8';
          end;
     savechart('cave',thechart);
     write(' cave');

    clearchart(thechart);
     with thechart do
          begin
               diceroll:='1';

               value[1,1]:=1;
               value[1,2]:=1;
               monsterid[1]:='soldier';
               number[1]:='1d4+4';
          end;
     savechart('castle',thechart);
     write(' castle');

    clearchart(thechart);
     with thechart do
          begin
               diceroll:='1d8';

               value[1,1]:=1;
               value[1,2]:=2;
               monsterid[1]:='shadow';
               number[1]:='2d4';

               value[2,1]:=3;
               value[2,2]:=3;
               monsterid[2]:='skeleton';
               number[2]:='1d8';

               value[3,1]:=4;
               value[3,2]:=4;
               monsterid[3]:='slime';
               number[3]:='1d4';

               value[4,1]:=5;
               value[4,2]:=5;
               monsterid[4]:='ooze';
               number[4]:='1d4';

               value[5,1]:=6;
               value[5,2]:=6;
               monsterid[5]:='gargoyle';
               number[5]:='1';

               value[6,1]:=7;
               value[6,2]:=7;
               monsterid[6]:='ghoul';
               number[6]:='2d4';

               value[7,1]:=8;
               value[7,2]:=8;
               monsterid[7]:='wraith';
               number[7]:='1d8';
          end;
     savechart('dungeon',thechart);
     write(' dungeon');

    writeln;
end;


procedure createsavegame;

var
     player    :    character_t;

procedure savegame(filename:string;player:character_t);

var
     savefile   :    text;
     loop       :   integer;
     st         :   stage;

begin
     assign(savefile,filename);
     rewrite(savefile);
     with player do
     begin
        writeln(savefile,name);
        writeln(savefile,picfile);
        writeln(savefile,sex);
        writeln(savefile,level);
        writeln(savefile,endurance);
        writeln(savefile,endurancemax);
        writeln(savefile,armorclass);
        writeln(savefile,thac0);
        writeln(savefile,damage);
        writeln(savefile,savingthrow);
        writeln(savefile,experience);
        writeln(savefile,coins);
        writeln(savefile,numitems);
        for loop:=1 to numitems do
            writeln(savefile,item[loop]);
        writeln(savefile,numspells);
        for loop:=1 to numspells do
            writeln(savefile,spell[loop]);
        writeln(savefile,strength);
        writeln(savefile,dexterity);
        writeln(savefile,charges);
        writeln(savefile,chargemax);
        for st:=ring to endgame do
            if (st in stages) then
                writeln(savefile,st);
    end;
    close(savefile);
    writeln(filename);

end;


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
               item[1]:=sword;
               item[2]:=shield;
               item[3]:=platemail;
               item[4]:=bluepotion;
               item[5]:=redpotion;

{
               with item[1] do
                  begin
                     name:='sword';
                     item_type:=weapon;
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
                     item_type:=shield;
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
                     item_type:=armor;
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
                     item_type:=potion;
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
                     item_type:=potion;
                     value:=100;
                     picfile:='potion-red.bmp';
                     msg:='potion-red.txt';
                     data[1]:=1; data[2]:=4; data[3]:=12;
                     data[4]:=0; data[5]:=0; data[6]:=0;
                     data[7]:=0; data[8]:=0;
                  end;
}
               numspells:=0;
               strength:=10;
               dexterity:=16;
               stages:=[];
               charges:=0;
               chargemax:=0;
          end;

     savegame(savedir+'/'+savedefault,player);

end;


{
procedure createitems;

var
     item      :    item_t;

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

begin


   with item do
      begin
         name:='sword';
         item_type:=weapon;
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
         item_type:=weapon;
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
         item_type:=weapon;
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
         item_type:=weapon;
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
         item_type:=weapon;
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
         item_type:=weapon;
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
         item_type:=weapon;
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
         item_type:=weapon;
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
         item_type:=weapon;
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
         item_type:=weapon;
         value:=7280;
         picfile:='chaos.bmp';
         msg:='This sword strikes with the power of darkness';
         data[1]:=4;
         data[2]:=22;
         data[3]:=81; data[4]:=10; data[5]:=24;
         data[6]:=0; data[7]:=0; data[8]:=0;
      end;
   saveitem(itemdir+'/chaos.dat',item);


   with item do
      begin
         name:='shield';
         item_type:=shield;
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
         item_type:=armor;
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
         item_type:=armor;
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
         item_type:=armor;
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


   with item do
      begin
         name:='blue potion';
         item_type:=potion;
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
         item_type:=potion;
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
         item_type:=potion;
         value:=300;
         picfile:='potion-green.bmp';
         msg:='potion-green.txt';
         data[1]:=2; data[2]:=15; data[3]:=25;
         data[4]:=4; data[5]:=3; data[6]:=6;
         data[7]:=1; data[8]:=100;
      end;
   saveitem(itemdir+'/potion-green.dat',item);


end;
}
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
               {createitems;}
               writeln;
               writeln('Press any key to continue.');
          end;


end. {main}
