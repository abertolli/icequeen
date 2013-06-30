{
	MNVIEW.PAS
	Monster Viewer for Ice Queen
	Copyright (C) 1999-2005 Angelo Bertolli
}

program MonsterViewer;

uses crt;

{$I h/game.pas}
{$I h/monster.pas}

var
     ch             :    char;
     int            :    integer;
     loop           :    integer;
     monster        :    monsterrecord;
     dosname        :    string;
     pasfile        :    file of monsterrecord;

{$I extras.pas}

begin {main}
  repeat
     clrscr;
     writeln('Ice Queen Monster Viewer ',version);
     writeln;
     writeln;
     repeat
          write('View which file:  ');
          readln(dosname);
          if not(exist(dosname)) then
               writeln('File does not exist.');
     until exist(dosname);
     assign(pasfile,monsterdir+dosname);
     reset(pasfile);
     read(pasfile,monster);
     close(pasfile);
     writeln('File read, press any key to continue.');
     ch:=readkey;
     clrscr;
     writeln;
     writeln;
     with monster do
          begin
               write('Monster name:  ');
               writeln(name);
               write('Monster picture file:  ');
               writeln(picfile);
               write('Gender:  ');
               writeln(sex);
               write('Alignment:  ');
               writeln(alignment);

               write('Hit Dice:  ');
               write(hitdice);
               if (hpbonus<0) then
                    writeln(hpbonus)
               else
                    if (hpbonus>0) then
                         writeln('+',hpbonus)
                    else
                         writeln;
               endurance:=0;
               endurancemax:=0;
               write('Armor Class:  ');
               writeln(armorclass);
               write('THAC0:  ');
               writeln(thac0);
               with damage do
                    begin
                         write('Damage:  ');
                         write(rollnum,'d',dicetype);
                         if (bonus<0) then
                              writeln(bonus)
                         else
                              if (bonus>0) then
                                   writeln('+',bonus)
                              else
                                   writeln;
                    end;
               write('Attack type:  ');
               writeln(name,' ',attacktype,' you!');
               write('Saving Throw:  ');
               writeln(savingthrow);
               write('Morale (2-12):  ');
               write(morale,' ');
               case morale of
                    2:writeln('(runs from a speck of dust)');
                 3..5:writeln('(cowardly)');
                 6..8:writeln('(cautious)');
                9..11:writeln('(brave)');
                   12:writeln('(fearless)');
               else
                    writeln('(what the heck?!!)');
               end;{case}
               write('Experience value (basic):  ');
               writeln(xpvalue);
               write('EXPERIENCE:  The game will multiply the xpv by ');
               writeln(xpmultiplier);
               writeln('    and then add half the monster''s HP to it for');
               writeln('    total xpv.');
               with treasure do
                    begin
                         write('Coins:  ');
                         write(rollnum,'d',dicetype);
                         if (bonus<0) then
                              writeln(bonus)
                         else
                              if (bonus>0) then
                                   writeln('+',bonus)
                              else
                                   writeln;
                    end;
               coins:=0;
               write('spells ');
               writeln('(',numspells,')');
               for loop:=1 to numspells do
                    begin
                         case spell[loop] of
                              icestorm       :write('icestorm':15);
                              fireblast      :write('fire blast':15);
                              web            :write('web':15);
                              callwild       :write('call wild':15);
                              heal           :write('heal':15);
                              courage        :write('courage':15);
                              freeze         :write('freeze':15);
                              obliterate     :write('obliterate':15);
                              icicle         :write('icicle':15);
                              power          :write('power':15);
                              shatter        :write('shatter':15);
                              glacier        :write('glacier':15);
                              dragonbreath   :write('dragon breath':15);
                              resistfire     :write('resist fire':15);
                              resistcold     :write('resist cold':15);
                         else
                              write('error');
                         end;{case}
                         if ((loop MOD 2)=0) then
                              writeln
                         else
                              write('          ');
                    end;
          end;
     writeln;
     writeln('<Enter> to continue, <ESC> to quit.');
     repeat
          ch:=readkey;
     until (ch in [#27,#13])
  until (ch in [#27]);
end. {main}
