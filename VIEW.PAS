{Calc Stats, View Stats, and Drop Item Procedures}
{---------------------------------------------------------------------------}
procedure calcstats(var player:playerrecord);

{Calculates the player stats based on level, xp, etc. and returns it.}

type
     itemset        =    set of item;

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
                    1:thac0:=thac0+5;
                    2:thac0:=thac0+4;
                    3:thac0:=thac0+3;
                 4..5:thac0:=thac0+2;
                 6..8:thac0:=thac0+1;
               13..15:thac0:=thac0-1;
               16..17:thac0:=thac0-2;
                   18:thac0:=thac0-3;
                   19:thac0:=thac0-4;
                   20:thac0:=thac0-5;
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
                    1:armorclass:=armorclass+5;
                    2:armorclass:=armorclass+4;
                    3:armorclass:=armorclass+3;
                 4..5:armorclass:=armorclass+2;
                 6..8:armorclass:=armorclass+1;
               13..15:armorclass:=armorclass-1;
               16..17:armorclass:=armorclass-2;
                   18:armorclass:=armorclass-3;
                   19:armorclass:=armorclass-4;
                   20:armorclass:=armorclass-5;
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
                         1:damage.bonus:=damage.bonus-5;
                         2:damage.bonus:=damage.bonus-4;
                         3:damage.bonus:=damage.bonus-3;
                      4..5:damage.bonus:=damage.bonus-2;
                      6..8:damage.bonus:=damage.bonus-1;
                    13..15:damage.bonus:=damage.bonus+1;
                    16..17:damage.bonus:=damage.bonus+2;
                        18:damage.bonus:=damage.bonus+3;
                        19:damage.bonus:=damage.bonus+4;
                        20:damage.bonus:=damage.bonus+5;
                    end;{case}
          end;
end;
{---------------------------------------------------------------------------}
procedure dropitem(var player:playerrecord);

var
     tempstring     :    stringtype;
     tempinteger    :    integer;
     tempcode       :    integer;
     count          :    integer;

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(sanseri,horizontal,3);
     with player do
          if (numitems>0) then
               begin
                    setcolor(lightblue);
                    gwriteln(x,y,'   ITEMS');
                    setcolor(white);
                    for count:=1 to numitems do
                         begin
                              str(count,tempstring);
                              tempstring:=tempstring + '. ' + itemstring(item[count]);
                              gwriteln(x,y,tempstring);
                         end;
                    gwriteln(x,y,'Drop which one?');
                    str(numitems,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    gwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    tempstring:=itemstring(item[tempinteger]);
                    gwrite(x,y,tempstring);
                    gwriteln(x,y,' will be gone forever.  Drop? (y/n)');
                    drawitem(280,(numitems+7)*textheight('M'),item[tempinteger]);
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['y','Y','n','N']);
                    if (ans in ['y','Y']) then
                         begin
                              for count:=tempinteger to (numitems-1) do
                                   item[count]:=item[count+1];
                              numitems:=numitems - 1;
                         end;
               end;
end;
{---------------------------------------------------------------------------}
procedure gwritelncol1(var x,y:integer;gstring:stringtype);

begin
     x:=col1;
     gwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure gwritelncol2(var x,y:integer;gstring:stringtype);

begin
     x:=col2;
     gwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure gwritelncol3(var x,y:integer;gstring:stringtype);

begin
     x:=col3;
     gwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure viewstats(var player:playerrecord);

var
     tempstring     :    stringtype;
     count          :    integer;
     score          :    integer;
     totalscore     :    integer;
     tempreal       :    real;
     stageloop      :    stage;
     s2             :    stringtype;

begin
     repeat
          cleardevice;
          calcstats(player);
          with player do
               begin
                    drawpicturebyline(20,20,picfile);
                    settextstyle(triplex,horizontal,4);
                    setcolor(white);
                    x:=240;
                    y:=25;
                    gwriteln(x,y,name);
                    gwriteln(x,y,'');
                    settextstyle(sanseri,horizontal,2);
                    x:=200;
                    str(level,tempstring);
                    tempstring:='level: ' + tempstring;
                    gwrite(x,y,tempstring);
                    gwrite(x,y,'     ');
                    if (sex in ['m','M']) then
                         gwriteln(x,y,'male')
                    else
                         gwriteln(x,y,'female');
                    y:=140;
                    gwriteln(x,y,'');
                    setcolor(lightred);
                    str(endurance,tempstring);
                    tempstring:='Endurance: ' + tempstring;
                    gwrite(x,y,tempstring);
                    str(endurancemax,tempstring);
                    tempstring:='/' + tempstring;
                    gwriteln(x,y,tempstring);
                    gwriteln(x,y,'');
                    setcolor(lightgray);
                    str(armorclass,tempstring);
                    tempstring:='Armor Class: ' + tempstring;
                    gwritelncol1(x,y,tempstring);
                    str(thac0,tempstring);
                    tempstring:='To Hit Roll: ' + tempstring;
                    gwritelncol1(x,y,tempstring);
                    str(strength,tempstring);
                    tempstring:='Strength: ' + tempstring;
                    gwritelncol1(x,y,tempstring);
                    str(dexterity,tempstring);
                    tempstring:='Dexterity: ' + tempstring;
                    gwritelncol1(x,y,tempstring);
                    str(savingthrow,tempstring);
                    tempstring:='Saving Throw: ' + tempstring;
                    gwritelncol1(x,y,tempstring);
                    x:=col1;
                    gwrite(x,y,'Damage: ');
                    str(damage.rollnum,tempstring);
                    tempstring:=tempstring + 'd';
                    gwrite(x,y,tempstring);
                    str(damage.dicetype,tempstring);
                    gwrite(x,y,tempstring);
                    str(damage.bonus,tempstring);
                    if (damage.bonus>0) then
                         begin
                              tempstring:='+' + tempstring;
                              gwrite(x,y,tempstring);
                         end;
                    if (damage.bonus<0) then
                         gwrite(x,y,tempstring);
                    str(experience,tempstring);
                    gwriteln(x,y,'');
                    tempstring:='Experience: ' + tempstring;
                    gwritelncol1(x,y,tempstring);

                    score:=0;
                    totalscore:=0;
                    for stageloop:=ring to endgame do
                         begin
                              totalscore:=totalscore+1;
                              if (stageloop in stages) then
                                   score:=score+1;
                         end;
                    tempreal:=(score/totalscore)*100;
                    score:=trunc(tempreal);
                    str(score,tempstring);
                    tempstring:='Score: ' + tempstring + '%';
                    gwritelncol1(x,y,tempstring);

                    gwriteln(x,y,'');
                    setcolor(yellow);
                    str(coins,tempstring);
                    tempstring:='Coins: ' + tempstring;
                    gwritelncol1(x,y,tempstring);
                    y:=140;
                    gwriteln(x,y,'');
                    setcolor(lightblue);
                    for count:=1 to numitems do
                         begin
                              tempstring:=itemstring(item[count]);
                              gwritelncol2(x,y,tempstring);
                         end;
                    y:=140;
                    gwriteln(x,y,'');
                    setcolor(lightmagenta);
                    for count:=1 to numspells do
                         begin
                              tempstring:=spellstring(spell[count]);
                              gwritelncol3(x,y,tempstring);
                         end;
                    if (ring in stages) then
                         begin
                              settextstyle(sanseri,horizontal,1);
                              gwritelncol3(x,y,'');
                              str(charges,tempstring);
                              tempstring:='Ring Charges: ' + tempstring;
                              str(chargemax,s2);
                              tempstring:=tempstring + '/' + s2;
                              gwritelncol3(x,y,tempstring);
                         end;
               end;
          setcolor(lightgreen);
          settextstyle(triplex,horizontal,3);
          y:=420;
          x:=320 - (textwidth('(D)rop or (E)xit') DIV 2);
          gwriteln(x,y,'(D)rop or (E)xit');
          repeat
               ans:=readarrowkey;
          until (ans in ['d','D','e','E']);
          case ans of
               'd','D':dropitem(player);
               'e','E':exit;
          end;{case}
     until FALSE
end;
