program CastleWinds;

{version 1.2a}

uses crt,graph;

const
     default        =    0;
     triplex        =    1;
     small          =    2;
     sanseri        =    3;
     gothic         =    4;
     horizontal     =    0;
     vertical       =    1;
     rowmax         =    14;
     colmax         =    20;
     monstermax     =    8;
     skillmax       =    8;
     itemmax        =    9;

type
     stringtype     =    string[20];
     stringline     =    string[100];
     matrix         =    array[1..colmax,1..rowmax] of integer;
     itemarray      =    array[1..itemmax] of integer;
     skillarray     =    array[1..skillmax] of integer;
     recordtype     =    record
                              name           :    stringtype;
                              picfile        :    stringtype;
                              endurance      :    integer;
                              endurancemax   :    integer;
                              combatskill    :    integer;
                              attack         :    integer;
                              defense        :    integer;
                              sex            :    char;
                              luck           :    integer;
                              coins          :    integer;
                              numitems       :    integer;
                              item           :    itemarray;
                              numskills      :    integer;
                              skill          :    skillarray;
                         end;
     monsterlist    =    array[1..monstermax] of recordtype;
     intset         =    set of 1..20;

var
     ch             :    char;
     x,y            :    integer;
     loop           :    integer;
     loop2          :    integer;
     lineoftext     :    stringline;
     count          :    integer;
     device         :    integer;
     mode           :    integer;
     surfacemap     :    matrix;
     surfacecode    :    matrix;
     cavemap        :    matrix;
     cavecode       :    matrix;
     castlemap      :    matrix;
     castlecode     :    matrix;
     row            :    integer;
     col            :    integer;
     ans            :    char;
     printport      :    stringtype;
     stages         :    intset;
     nummonsters    :    integer;
     player         :    recordtype;
     monster        :    monsterlist;
     tempstring     :    stringtype;
     tempchar       :    char;
     tempset        :    intset;
     tempcode       :    integer;
     tempinteger    :    integer;
     moneypool      :    integer;

{$I iceinc.pas}
{$I init.pas}
{$I combat.pas}
{---------------------------------------------------------------------------}
procedure combat(var player:recordtype;nummonsters:integer;
monster:monsterlist;var moneypool:integer);

var
     courage        :    boolean;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure gotaway;

begin
     settextstyle(sanseri,horizontal,1);
     clearleft(x,y);
     y:=y + 50;
     leftwriteln(x,y,'You run away...');
     leftprompt;
end;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure gomonsters(var player:recordtype;var nummonsters:integer;
var monster:monsterlist);

var
     chance         :    integer;
     damage         :    integer;

begin
     for loop:=1 to nummonsters do
          with monster[loop] do
               begin
                    settextstyle(sanseri,horizontal,1);
                    clearleft(x,y);
                    gwriteln(x,y,'');
                    str(loop,tempstring);
                    tempstring:=name + ' ' + tempstring;
                    leftwriteln(x,y,tempstring);
                    gwriteln(x,y,'');
                    if (d(100)<=70)and(endurance<=3) then
                         begin
                              leftwriteln(x,y,' runs away...');
                              leftprompt;
                              for loop2:=loop to nummonsters do
                                   if (loop2<>nummonsters) then
                                        monster[loop2]:=monster[loop2 + 1];
                              nummonsters:=nummonsters - 1;
                              combatscreen(player,nummonsters,monster);
                              combatstats(player);
                         end
                    else
                         if (d(100)<=20)and(numskills>0) then
                              begin

                                   {* monster use skill *}

                              end
                         else
                              begin
                                   leftwriteln(x,y,'attacks...');
                                   gwriteln(x,y,'');
                                   chance:=attack - player.defense;
                                   if (chance<1) then
                                        chance:=5;
                                   if (chance>95) then
                                        chance:=95;
                                   if (d(75)<=chance) then
                                        begin
                                             damage:=d(chance DIV 4) + (chance DIV 4);
                                             str(damage,tempstring);
                                             tempstring:='HIT - ' + tempstring;
                                             leftwriteln(x,y,tempstring);
                                             leftprompt;
                                             player.endurance:=player.endurance - damage;
                                             combatstats(player);
                                             if (player.endurance<1) then
                                                  died;
                                        end
                                   else
                                        begin
                                             leftwriteln(x,y,'MISS');
                                             leftprompt;
                                        end;
                              end;
               end;
end;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure goplayer(var player:recordtype;var nummonsters:integer;
var monster:monsterlist;var moneypool:integer;var courage:boolean);

var
     done           :    boolean;
     chance         :    integer;
     damage         :    integer;

begin
     done:=false;
     repeat
          with player do
               begin
                    clearleft(x,y);
                    settextstyle(sanseri,horizontal,1);
                    leftwriteln(x,y,'(A)ttack, (U)se,');
                    gwriteln(x,y,'');
                    leftwriteln(x,y,'or');
                    gwriteln(x,y,'');
                    leftwriteln(x,y,'(S)kill');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['a','A','u','U','s','S']);
                    clearleft(x,y);
                    if (ans in ['a','A']) then
                         begin
                              done:=true;
                              if not(nummonsters=1) then
                                   begin
                                        gwriteln(x,y,'');
                                        gwriteln(x,y,'');
                                        leftwriteln(x,y,'WHICH ONE?');
                                        str(nummonsters,tempstring);
                                        repeat
                                             ans:=readarrowkey;
                                        until (ans in ['1'..tempstring[1]]);
                                        val(ans,tempinteger,tempcode);
                                        clearleft(x,y);
                                   end
                              else
                                   tempinteger:=1;
                              gwriteln(x,y,'');
                              leftwriteln(x,y,'You attack...');
                              gwriteln(x,y,'');
                              chance:=attack - monster[tempinteger].defense;
                              if (chance<5) then
                                   chance:=5;
                              if (chance>95) then
                                   chance:=95;
                              if (d(75)<=chance) then
                                   begin
                                        damage:=d(chance DIV 4) + (chance DIV 4);
                                        str(damage,tempstring);
                                        tempstring:='HIT - ' + tempstring;
                                        leftwriteln(x,y,tempstring);
                                        monster[tempinteger].endurance:=monster[tempinteger].endurance - damage;
                                        if (monster[tempinteger].endurance<1) then
                                             begin
                                                  leftwriteln(x,y,'killed');
                                                  leftprompt;
                                                  moneypool:=moneypool + monster[tempinteger].coins;
                                                  for loop2:=tempinteger to nummonsters do
                                                       if (loop2<>nummonsters) then
                                                            monster[loop2]:=monster[loop2 + 1];
                                                  nummonsters:=nummonsters - 1;
                                                  combatscreen(player,nummonsters,monster);
                                                  combatstats(player);
                                             end
                                        else
                                             leftprompt;
                                   end
                              else
                                   begin
                                        leftwriteln(x,y,'MISS');
                                        leftprompt;
                                   end;
                         end
                    else
                         if (ans in ['u','U']) then
                              if (numitems=0) then
                                   begin
                                        gwriteln(x,y,'');
                                        leftwriteln(x,y,'You have');
                                        gwriteln(x,y,'');
                                        leftwriteln(x,y,'no items');
                                        leftprompt;
                                   end
                              else
{...........................................................................}
          begin
               settextstyle(default,horizontal,1);
               leftwriteln(x,y,'USE ITEM');
               gwriteln(x,y,'');
               for loop:=1 to numitems do
                    begin
                         str(loop,tempstring);
                         tempstring:=tempstring + ') ' + itemstring(item[loop]);
                         if (item[loop] in [4,5,6]) then
                              setcolor(lightcyan)
                         else
                              setcolor(cyan);
                         x:=midleft('USE ITEM') - 18;
                         gwriteln(x,y,tempstring);
                    end;
               x:=midleft('USE ITEM') - 18;
               setcolor(lightcyan);
               gwriteln(x,y,'N) none');
               repeat
                    ans:=readarrowkey;
               until (ans in ['1'..tempstring[1],'n','N']);
               settextstyle(sanseri,horizontal,1);
               if not(ans in ['n','N']) then
                    begin
                         val(ans,tempinteger,tempcode);
                         if not(item[tempinteger] in [4,5,6]) then
                              begin
                                   clearleft(x,y);
                                   gwriteln(x,y,'');
                                   gwriteln(x,y,'');
                                   leftwriteln(x,y,'NOT USABLE');
                                   leftprompt;
                              end
                         else
                              begin
                                   clearleft(x,y);
                                   case item[tempinteger] of
                                        4:begin
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'Your');
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'attack skill');
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'increases!');
                                               attack:=attack + d(8) + 12;
                                               combatstats(player);
                                               for loop:=tempinteger to numitems do
                                                    if (loop<>numitems) then
                                                         item[loop]:=item[loop + 1];
                                               numitems:=numitems - 1;
                                               leftprompt;
                                          end;
                                        5:begin
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'Your are');
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'healed');
                                               endurance:=endurance + d(6) + 4;
                                               if (endurance>endurancemax) then
                                                    endurance:=endurancemax;
                                               combatstats(player);
                                               for loop:=tempinteger to numitems do
                                                    if (loop<>numitems) then
                                                         item[loop]:=item[loop + 1];
                                               numitems:=numitems - 1;
                                               leftprompt;
                                          end;
                                        6:begin
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'You become');
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'super charged!');
                                               endurance:=endurancemax;
                                               attack:=attack + d(4) + 20;
                                               defense:=defense + d(4) + 20;
                                               combatstats(player);
                                               for loop:=tempinteger to numitems do
                                                    if (loop<>numitems) then
                                                         item[loop]:=item[loop + 1];
                                               numitems:=numitems - 1;
                                               leftprompt;
                                          end;
                                   end;{case}
                                   done:=true;
                              end;
                    end;
          end
{...........................................................................}
                         else
                              if (numskills=0) then
                                   begin
                                        gwriteln(x,y,'');
                                        leftwriteln(x,y,'You have');
                                        gwriteln(x,y,'');
                                        leftwriteln(x,y,'no skills');
                                        leftprompt;
                                   end
                              else
{...........................................................................}
          begin
               settextstyle(default,horizontal,1);
               leftwriteln(x,y,'USE SKILL');
               gwriteln(x,y,'');
               for loop:=1 to numskills do
                    begin
                         str(loop,tempstring);
                         tempstring:=tempstring + ') ' + skillstring(skill[loop]);
                         if (skill[loop] in [4,11]) then
                              setcolor(cyan)
                         else
                              setcolor(lightcyan);
                         x:=midleft('USE SKILL') - 18;
                         gwriteln(x,y,tempstring);
                    end;
               x:=midleft('USE SKILL') - 18;
               gwriteln(x,y,'N) none');
               repeat
                    ans:=readarrowkey;
               until (ans in ['1'..tempstring[1],'n','N']);
               settextstyle(sanseri,horizontal,1);
               if not(ans in ['n','N']) then
                    begin
                         val(ans,tempinteger,tempcode);
                         if(skill[tempinteger] in [4,11]) then
                              begin
                                   clearleft(x,y);
                                   gwriteln(x,y,'');
                                   gwriteln(x,y,'');
                                   leftwriteln(x,y,'NO EFFECT');
                                   leftprompt;
                              end;
                              {*}
                         clearleft(x,y);
                         case skill[tempinteger] of
                              2:begin
                                     if not(nummonsters=1) then
                                          begin
                                               gwriteln(x,y,'');
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'WHICH ONE?');
                                               str(nummonsters,tempstring);
                                               repeat
                                                    ans:=readarrowkey;
                                               until (ans in ['1'..tempstring[1]]);
                                               val(ans,tempinteger,tempcode);
                                               clearleft(x,y);
                                            end
                                     else
                                          tempinteger:=1;
                                     gwriteln(x,y,'');
                                     leftwriteln(x,y,'FIRE BLAST!');
                                     gwriteln(x,y,'');
                                     damage:=d(6) + d(6) + d(6) + d(6);
                                     with monster[tempinteger] do
                                          begin
                                               if (d(100)<=luck) then
                                                    damage:=damage DIV 2;
                                               for loop:=1 to numskills do
                                                    if (skill[loop]=14) then
                                                         damage:=damage DIV 4;
                                          end;
                                     str(damage,tempstring);
                                     tempstring:='HIT - ' + tempstring;
                                     leftwriteln(x,y,tempstring);
                                     monster[tempinteger].endurance:=monster[tempinteger].endurance - damage;
                                     if (monster[tempinteger].endurance<1) then
                                          begin
                                               leftwriteln(x,y,'killed');
                                               leftprompt;
                                               moneypool:=moneypool + monster[tempinteger].coins;
                                               for loop2:=tempinteger to nummonsters do
                                                    if (loop2<>nummonsters) then
                                                         monster[loop2]:=monster[loop2 + 1];
                                               nummonsters:=nummonsters - 1;
                                               combatscreen(player,nummonsters,monster);
                                               combatstats(player);
                                          end
                                     else
                                          leftprompt;
                                end;
                              5:begin
                                     gwriteln(x,y,'');
                                     leftwriteln(x,y,'Your are');
                                     gwriteln(x,y,'');
                                     leftwriteln(x,y,'healed');
                                     endurance:=endurance + d(6);
                                     if (endurance>endurancemax) then
                                          endurance:=endurancemax;
                                     combatstats(player);
                                     leftprompt;
                                end;
                              6:if not(courage) then
                                     begin
                                          gwriteln(x,y,'');
                                          leftwriteln(x,y,'Your');
                                          gwriteln(x,y,'');
                                          leftwriteln(x,y,'attack skill');
                                          gwriteln(x,y,'');
                                          leftwriteln(x,y,'increases!');
                                          attack:=attack + d(6) + d(6);
                                          combatstats(player);
                                          courage:=true;
                                          leftprompt;
                                     end
                                else
                                     begin
                                          gwriteln(x,y,'');
                                          leftwriteln(x,y,'The spell');
                                          gwriteln(x,y,'');
                                          leftwriteln(x,y,'fizzles');
                                          leftprompt;
                                     end;
                              8:begin
                                     if not(nummonsters=1) then
                                          begin
                                               gwriteln(x,y,'');
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'WHICH ONE?');
                                               str(nummonsters,tempstring);
                                               repeat
                                                    ans:=readarrowkey;
                                               until (ans in ['1'..tempstring[1]]);
                                               val(ans,tempinteger,tempcode);
                                               clearleft(x,y);
                                            end
                                     else
                                          tempinteger:=1;
                                     leftwriteln(x,y,'YOU OBLITERATE');
                                     gwriteln(x,y,'');
                                     leftwriteln(x,y,'THE');
                                     gwriteln(x,y,'');
                                     leftwriteln(x,y,monster[tempinteger].name);
                                     leftprompt;
                                     for loop2:=tempinteger to nummonsters do
                                          if (loop2<>nummonsters) then
                                               monster[loop2]:=monster[loop2 + 1];
                                     nummonsters:=nummonsters - 1;
                                     combatscreen(player,nummonsters,monster);
                                     combatstats(player);
                                end;
                              9:begin
                                     if not(nummonsters=1) then
                                          begin
                                               gwriteln(x,y,'');
                                               gwriteln(x,y,'');
                                               leftwriteln(x,y,'WHICH ONE?');
                                               str(nummonsters,tempstring);
                                               repeat
                                                    ans:=readarrowkey;
                                               until (ans in ['1'..tempstring[1]]);
                                               val(ans,tempinteger,tempcode);
                                               clearleft(x,y);
                                            end
                                     else
                                          tempinteger:=1;
                                     leftwriteln(x,y,'YOU THROW');
                                     leftwriteln(x,y,'A CHILLING ICICLE!');
                                     gwriteln(x,y,'');
                                     damage:=d(4) + d(4);
                                     with monster[tempinteger] do
                                          begin
                                               if (d(100)<=luck) then
                                                    damage:=damage DIV 2;
                                               for loop:=1 to numskills do
                                                    if (skill[loop]=15) then
                                                         damage:=damage DIV 4;
                                          end;
                                     str(damage,tempstring);
                                     tempstring:='HIT - ' + tempstring;
                                     leftwriteln(x,y,tempstring);
                                     monster[tempinteger].endurance:=monster[tempinteger].endurance - damage;
                                     if (monster[tempinteger].endurance<1) then
                                          begin
                                               leftwriteln(x,y,'killed');
                                               leftprompt;
                                               moneypool:=moneypool + monster[tempinteger].coins;
                                               for loop2:=tempinteger to nummonsters do
                                                    if (loop2<>nummonsters) then
                                                         monster[loop2]:=monster[loop2 + 1];
                                               nummonsters:=nummonsters - 1;
                                               combatscreen(player,nummonsters,monster);
                                               combatstats(player);
                                          end
                                     else
                                          leftprompt;
                                end;
                             10:;
                         end;{case}
                         done:=true;
                    end;
          end;
{...........................................................................}
               end;
     until done;
end;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

begin
     moneypool:=0;
     courage:=false;
     calccombat(player);
     combatscreen(player,nummonsters,monster);
     repeat
          combatstats(player);
          settextstyle(sanseri,horizontal,2);
          clearleft(x,y);
          leftwriteln(x,y,'(F)ight');
          gwriteln(x,y,'');
          leftwriteln(x,y,'or');
          gwriteln(x,y,'');
          leftwriteln(x,y,'(R)un');
          repeat
               ans:=readarrowkey;
          until (ans in ['r','R','f','F']);
          if (ans in ['r','R']) then
               begin
                    if (d(100)<=35) then
                         begin
                              gotaway;
                              exit;
                         end
                    else
                         begin
                              gomonsters(player,nummonsters,monster);
                              gotaway;
                              exit;
                         end;
               end
          else
               begin
                    if (d(100)<=50) then
                         begin
                              goplayer(player,nummonsters,monster,moneypool,courage);
                              gomonsters(player,nummonsters,monster)
                         end
                    else
                         begin
                              gomonsters(player,nummonsters,monster);
                              if (nummonsters>0) then
                                   goplayer(player,nummonsters,monster,moneypool,courage);
                         end;
                    if (nummonsters=0) then
                         begin
                              clearleft(x,y);
                              settextstyle(sanseri,horizontal,1);
                              gwriteln(x,y,'');
                              leftwriteln(x,y,'YOU WIN!');
                              gwriteln(x,y,'');
                              leftwriteln(x,y,'You find');
                              gwriteln(x,y,'');
                              str(moneypool,tempstring);
                              tempstring:=tempstring + ' coins';
                              leftwriteln(x,y,tempstring);
                              leftprompt;
                              player.coins:=player.coins + moneypool;
                              exit;
                         end;
               end;
     until FALSE;
end;

{$I surface.pas}
{$I mainmenu.pas}
{===========================================================================}

begin {main}

     gfilesloc(device,mode,'c:\tp\bgi');
     initgame(surfacemap,surfacecode,cavemap,cavecode,castlemap,castlecode,
     printport,stages);
     titlescreen;
     mainmenu;

     closegraph;
end.  {main}
