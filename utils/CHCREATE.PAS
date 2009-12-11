program CharacterCreator;

uses crt;

const
     version        =    'v1.0';
     spellmax       =    8;
     itemmax        =    9;
     maxlevel       =    12;
     stagemax       =    20;
     ringmax        =    20;

type
     stringtype     =    string[20];
     item           =    (sword,shield,axe,bluepotion,redpotion,greenpotion,
                          chainmail,platemail,dagger,club,staff,hammer,
                          magicsword,magicshield,flamewand);
     spell          =    (icestorm,fireblast,web,callwild,heal,courage,freeze,
                          obliterate,icicle,power,shatter,glacier,
                          dragonbreath,resistfire,resistcold);
     stage          =    (ring,endgame);
     itemarray      =    array[1..itemmax] of item;
     spellarray     =    array[1..spellmax] of spell;
     dicerecord     =    record
                              rollnum        :    word;
                              dicetype       :    word;
                              bonus          :    integer;
                         end;
     playerrecord   =    record
                              name           :    stringtype;
                              picfile        :    stringtype;
                              sex            :    char;
                              level          :    byte;
                              endurance      :    word;
                              endurancemax   :    word;
                              armorclass     :    integer;
                              thac0          :    shortint;
                              damage         :    dicerecord;
                              savingthrow    :    byte;
                              experience     :    longint;
                              coins          :    longint;
                              numitems       :    byte;
                              item           :    itemarray;
                              numspells      :    byte;
                              spell          :    spellarray;
                              strength       :    byte;
                              dexterity      :    byte;
                              stages         :    set of stage;
                              charges        :    byte;
                              chargemax      :    byte;
                         end;

var
     ch             :    char;
     int            :    integer;
     loop           :    integer;
     player         :    playerrecord;
     dosname        :    stringtype;
     pasfile        :    file of playerrecord;
     goahead        :    boolean;

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
               write('Character picture file [mplayer.ln1]:  ');
               readln(picfile);
               if(picfile='')then
                    picfile:='mplayer.ln1';
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
     if exist(dosname) then
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
               assign(pasfile,dosname);
               rewrite(pasfile);
               write(pasfile,player);
               close(pasfile);
               writeln('Saved.');
               ch:=readkey;
          end
     else
          writeln('Bye.');

end. {main}
