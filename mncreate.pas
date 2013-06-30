{
	MNCREATE.PAS
	Monster Creator for Ice Queen
	Copyright (C) 1999-2005 Angelo Bertolli
}

program MonsterCreator;

uses crt;

{$I ../game.h}
{$I ../monster.h}

var
     ch             :    char;
     int            :    integer;
     loop           :    integer;
     monster        :    monsterrecord;
     dosname        :    string;
     pasfile        :    file of monsterrecord;
     goahead        :    boolean;

{$I extras.pas}

begin {main}
  repeat
     clrscr;
     writeln('Ice Queen Monster Creator ',version);
     writeln;
     writeln;
     with monster do
          begin
               write('Enter monster name:  ');
               readln(name);
               write('Monster picture file:  ');
               readln(picfile);
               write('Gender [m]:  ');
               readln(sex);
               if not(sex in ['f','F'])then
                    sex:='M';
               write('Alignment (L/N/C capitalize):  ');
               readln(alignment);
               if not(alignment in ['L','N','C'])then
                    alignment:='C';
               write('Hit Dice (1-100):  ');
               readln(hitdice);
               if not(hitdice in [1..100]) then
                    hitdice:=1;
               write('HP bonus + ');
               readln(hpbonus);
               endurance:=0;
               endurancemax:=0;
               write('Armor Class (-20 to 20):  ');
               readln(armorclass);
               thac0:=20-hitdice;
               if(hpbonus>0)then
                    thac0:=thac0-1;
               with damage do
                    begin
                         writeln('DAMAGE = <rollnum>d<dicetype>+<bonus>');
                         write('     rollnum:  ');
                         readln(rollnum);
                         write('     dicetype:  ');
                         readln(dicetype);
                         write('     bonus:  ');
                         readln(bonus);
                    end;
               write('Attack type [attacks]:  ');
               readln(attacktype);
               write('Saving Throw (0 to calculate same as fighter):  ');
               readln(savingthrow);
               if(savingthrow=0)then
                    case hitdice of
                         1..3:savingthrow:=16;
                         4..6:savingthrow:=14;
                         7..9:savingthrow:=12;
                       10..12:savingthrow:=10;
                       13..15:savingthrow:=9;
                       16..18:savingthrow:=8;
                       19..21:savingthrow:=7;
                       22..24:savingthrow:=6;
                       25..27:savingthrow:=5;
                       28..30:savingthrow:=4;
                       31..33:savingthrow:=3;
                    else
                         savingthrow:=2;
                    end;{case}
               write('Morale (2-12):  ');
               readln(morale);
               write('EXPERIENCE:  The game will multiply the xpv by ');
               writeln(xpmultiplier);
               writeln('    and then add half the monster''s HP to it for');
               writeln('    total xpv.');
               write('Experience value (basic):  ');
               readln(xpvalue);
               if(xpvalue<=0)then
                    xpvalue:=1;
               with treasure do
                    begin
                         writeln('COINS = <rollnum>d<dicetype>+<bonus>');
                         write('     rollnum:  ');
                         readln(rollnum);
                         write('     dicetype:  ');
                         readln(dicetype);
                         write('     bonus:  ');
                         readln(bonus);
                    end;
               coins:=0;
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
               {stages}
          end;
     writeln;
     writeln;

     write('Enter Save File Name:  ');
     readln(dosname);
     goahead:=false;
     if exist(dosname) then
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
               assign(pasfile,monsterdir+dosname);
               rewrite(pasfile);
               write(pasfile,monster);
               close(pasfile);
               writeln('Saved.');
          end;
     writeln;
     writeln('<Enter> to continue, <ESC> to quit.');
     repeat
          ch:=readkey;
     until (ch in [#27,#13]);
  until (ch in [#27]);
end. {main}
