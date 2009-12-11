{Combat Functions and Procedures}
{---------------------------------------------------------------------------}
procedure rollmonsters(var monster:monsterlist;nummonsters:integer;
                       monsterfile:stringtype);

var

     pasfile        :    file of monsterrecord;
     count          :    integer;
     tempmonster    :    monsterrecord;

begin
     if not(exist(monsterfile)) then
          exit;
     assign(pasfile,monsterfile);
     reset(pasfile);
     read(pasfile,tempmonster);
     close(pasfile);
     for count:=1 to nummonsters do
          begin
               monster[count]:=tempmonster;
               with monster[count] do
                    begin
                         endurancemax:=0;
                         for loop:=1 to hitdice do
                              endurancemax:=endurancemax + d(8);
                         if (hpbonus<0) and (endurancemax<(hpbonus*-1)) then
                              endurancemax:=1
                         else
                              endurancemax:=endurancemax + hpbonus;
                         if (endurancemax<=0) then
                              endurancemax:=1;
                         endurance:=endurancemax;
                         xpvalue:=(monster[count].xpvalue*xpmultiplier)
                                  + (endurance DIV 2);
                         coins:=droll(treasure);
                    end;
          end;
end;
{---------------------------------------------------------------------------}
procedure combatmenuprompt;

begin
     y:=450;
     settextstyle(default,horizontal,1);
     gwriteln(x,y,'       <press space>');
     ch:=readarrowkey;
end;
{---------------------------------------------------------------------------}
procedure clearcombatmenu;

begin

     setcolor(blue);
     setfillstyle(solidfill,blue);
     bar(40,300,200,460);
     setcolor(lightblue);
     rectangle(40,300,200,460);
     setcolor(lightcyan);
end;
{---------------------------------------------------------------------------}
procedure combatstats(player:playerrecord);

var
     tempstring     :    stringtype;
     hitbar         :    word;

begin
     setcolor(blue);
     setfillstyle(solidfill,blue);
     bar(420,300,600,460);
     setcolor(lightblue);
     rectangle(420,300,600,460);
     setcolor(lightcyan);
     calcstats(player);
     x:=510 - (textwidth(player.name) DIV 2);
     y:=300;
     outtextxy(x,y,player.name);
     gwriteln(x,y,'');
     x:=440;
     str(player.level,tempstring);
     tempstring:='Level: ' + tempstring;
     gwriteln(x,y,tempstring);
     x:=440;
     str(player.endurance,tempstring);
     tempstring:='HP: ' + tempstring + '/';
     gwrite(x,y,tempstring);
     str(player.endurancemax,tempstring);
     gwriteln(x,y,tempstring);
     setcolor(lightgray);
     line(438,366,541,366);
     line(438,366,438,371);
     setcolor(black);
     line(439,367,541,367);
     line(439,370,541,370);
     line(439,367,439,370);
     line(541,367,541,370);
     hitbar:=trunc((player.endurance/player.endurancemax)*100);
     case hitbar of
          0..20:setcolor(red);
          21..50:setcolor(yellow);
     else
          setcolor(green);
     end; {case}
     line(440,368,440+hitbar,368);
     line(440,369,440+hitbar,369);
     setcolor(black);
     line(441+hitbar,368,540,368);
     line(441+hitbar,369,540,369);
     setcolor(lightcyan);
     x:=440;
     y:=y+4;
     str(player.armorclass,tempstring);
     tempstring:='AC: ' + tempstring;
     gwriteln(x,y,tempstring);
     x:=440;
     str(player.thac0,tempstring);
     tempstring:='THAC0: ' + tempstring;
     gwriteln(x,y,tempstring);
     x:=440;
     gwrite(x,y,'Dmg: ');
     str(player.damage.rollnum,tempstring);
     tempstring:=tempstring + 'd';
     gwrite(x,y,tempstring);
     str(player.damage.dicetype,tempstring);
     gwrite(x,y,tempstring);
     if (player.damage.bonus<>0) then
          begin
               str(player.damage.bonus,tempstring);
               if (player.damage.bonus>0) then
                    tempstring:='+' + tempstring;
               gwrite(x,y,tempstring);
          end;
     gwriteln(x,y,'');
     x:=440;
     str(player.savingthrow,tempstring);
     tempstring:='Save: ' + tempstring;
     gwriteln(x,y,tempstring);

end;
{---------------------------------------------------------------------------}
procedure combatscreen(player:playerrecord;nummonsters:integer;
                       monster:monsterlist);

var
     row1width      :    integer;
     row2width      :    integer;
     tempstring     :    stringtype;

begin
     cleardevice;
     settextstyle(default,horizontal,1);

     {draw the monsters & write names}
     row1width:=(nummonsters * 120) + ((nummonsters - 1) * spacing);
     if (row1width>(480 + (3 * spacing))) then
          row1width:=480 + (3 * spacing);
     row2width:=((nummonsters - 4) * 120) + ((nummonsters - 5) * spacing);
     x:=(getmaxx DIV 2) - (row1width DIV 2);
     y:=0;
     if (nummonsters<=1) then
          begin
               drawpicturebyline(x,y,monster[nummonsters].picfile);
               setcolor(lightgray);
               tempstring:=monster[nummonsters].name;
               outtextxy(x+60-(textwidth(tempstring) DIV 2),y+120,tempstring);
               x:=x+120+spacing;
          end;
     if (nummonsters<=4)and(nummonsters>1) then
          for loop:=1 to nummonsters do
               begin
                    drawpicturebyline(x,y,monster[loop].picfile);
                    setcolor(lightgray);
                    str(loop,tempstring);
                    tempstring:=tempstring + '.' + monster[loop].name;
                    outtextxy(x+60-(textwidth(tempstring) DIV 2),y+120,tempstring);
                    x:=x+120+spacing;
               end;
     if (nummonsters>4) then
          begin
               for loop:=1 to 4 do
                    begin
                         drawpicturebyline(x,y,monster[loop].picfile);
                         setcolor(lightgray);
                         str(loop,tempstring);
                         tempstring:=tempstring + '.' + monster[loop].name;
                         outtextxy(x+60-(textwidth(tempstring) DIV 2),y+120,tempstring);
                         x:=x+120+spacing;
                    end;
               x:=(getmaxx DIV 2) - (row2width DIV 2);
               y:=120 + spacing;
               for loop:=5 to nummonsters do
                    begin
                         drawpicturebyline(x,y,monster[loop].picfile);
                         setcolor(lightgray);
                         str(loop,tempstring);
                         tempstring:=tempstring + '.' + monster[loop].name;
                         outtextxy(x+60-(textwidth(tempstring) DIV 2),y+120,tempstring);
                         x:=x+120+spacing;
                    end;
          end;
     settextstyle(sanseri,horizontal,1);
     clearcombatmenu;           {Create the combat menu window on the left}
     combatstats(player);       {Create the combat stats window on the right}
     x:=(640 DIV 2) - 60;   {Draw the player in the center}
     y:=340;
     drawpicturebyline(x,y,player.picfile);
end;
{---------------------------------------------------------------------------}
procedure attackmonster(var player:playerrecord;var themonster:monsterrecord;
                        playereffect:effectrecord;themonstereffect:effectrecord);

var
     dmg       :    integer;
     s         :    stringtype;
     flame     :    boolean;
     loop      :    integer;
     ac        :    integer;
     hitroll   :    integer;

begin
     clearcombatmenu;
     settextstyle(sanseri,horizontal,1);
     y:=300;
     gwriteln(x,y,'');
     ac:=themonster.armorclass;
     if (themonstereffect.glacier) and (ac>4) then
          ac:=4;
     hitroll:=d(20);
     if ((hitroll>=(player.thac0-ac))and(hitroll>1))or(hitroll=20) then
          begin
               gwriteln(x,y,'');
               gwriteln(x,y,'        You hit!');
               gwriteln(x,y,'');
               dmg:=droll(player.damage);
               if (dmg<1) then
                    dmg:=1;
               flame:=false;
               for loop:=1 to player.numitems do
                    if (player.item[loop]=flamewand) then
                         flame:=true;
               if (flame) and (themonstereffect.resistfire) then
                    dmg:=trunc(dmg/2)+1;
               str(dmg,s);
               s:='('+s+')';
               x:=120-(trunc(textwidth(s)/2));
               gwriteln(x,y,s);
               if (dmg>themonster.endurance) then
                    themonster.endurance:=0
               else
                    themonster.endurance:=themonster.endurance-dmg;
               if (themonster.endurance=0) then
                    begin
                         x:=120-(trunc(textwidth('KILLED')/2));
                         gwriteln(x,y,'KILLED');
                    end;
          end
     else
          begin
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               gwriteln(x,y,'       You missed');
          end;
end;
{---------------------------------------------------------------------------}
procedure remove(var numitems:byte;var item:itemarray;loc:integer);

var
     count     :    integer;

begin
     for count:=loc to (numitems-1) do
           item[count]:=item[count+1];
     numitems:=numitems-1;
end;
{---------------------------------------------------------------------------}
procedure combatuse(var player:playerrecord;itemnum:integer;
                    var nummonsters:integer;var monster:monsterlist;
                    var playereffect:effectrecord);

begin
     y:=360;
     case player.item[itemnum] of
              sword..axe:begin
                              gwriteln(x,y,'        Not usable.');
                         end;
    chainmail..flamewand:begin
                              gwriteln(x,y,'        Not usable.');
                         end;
              bluepotion:begin
                              if not(playereffect.blue) then
                                   begin
                                        gwriteln(x,y,'     You become faster');
                                        gwriteln(x,y,'       and stronger.');
                                        player.strength:=player.strength+d(4);
                                        if (player.strength>20) then
                                             player.strength:=20;
                                        player.dexterity:=player.dexterity+d(4);
                                        if (player.dexterity>20) then
                                             player.dexterity:=20;
                                        remove(player.numitems,player.item,itemnum);
                                        playereffect.blue:=true;
                                   end
                              else
                                   begin
                                        gwriteln(x,y,'     It has no effect.');
                                   end;
                         end;
               redpotion:begin
                              gwriteln(x,y,'    Healing soothes you.');
                              player.endurance:=player.endurance+d(6)+1;
                              if (player.endurance>player.endurancemax) then
                                   player.endurance:=player.endurancemax;
                              remove(player.numitems,player.item,itemnum);
                         end;
             greenpotion:begin
                              gwriteln(x,y,'      You feel POWER');
                              gwriteln(x,y,'          surging');
                              gwriteln(x,y,'     through your body!');
                              player.endurance:=player.endurancemax;
                              player.strength:=20;
                              player.dexterity:=20;
                              remove(player.numitems,player.item,itemnum);
                         end;
     end;

end;
{---------------------------------------------------------------------------}
procedure combatcast(var player:playerrecord;spellnum:integer;
                     var nummonsters:integer;var monster:monsterlist;
                     var playereffect:effectrecord;var monstereffect:effectlist);

var
     damagetype     :    stringtype;
     dmgroll        :    dicerecord;
     originaldmg    :    integer;
     dmg            :    integer;
     target         :    integer;
     count          :    integer;
     tempstring     :    stringtype;
     tempint        :    integer;
     errcode        :    integer;
     thespell       :    spell;
     powerroll      :    integer;
     monsterchart   :    chartrecord;
     pasfile        :    file of chartrecord;
     theroll        :    integer;
     val1           :    integer;
     val2           :    integer;
     monsterfile    :    stringtype;
     newmonster     :    monsterlist;
     numnewmonster  :    integer;
     saveroll       :    integer;


begin

     thespell:=player.spell[spellnum];
     damagetype:='';
     y:=360;
     case thespell of
           icestorm:begin
                         damagetype:='cold';
                         dmgroll.rollnum:=player.level;
                         if (dmgroll.rollnum>20) then
                              dmgroll.rollnum:=20;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=0;
                         dmg:=droll(dmgroll);
                    end;
          fireblast:begin
                         damagetype:='fire';
                         dmgroll.rollnum:=(((player.level-1) DIV 5)*2)+1;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=dmgroll.rollnum;
                         dmg:=droll(dmgroll);
                    end;
         web,freeze:begin
                         gwriteln(x,y,'     You make your foes');
                         gwriteln(x,y,'       easier to hit.');
                         for loop:=1 to nummonsters do
                              begin
                                   monster[loop].armorclass:=monster[loop].armorclass+2;
                                   if (monster[loop].armorclass>9) then
                                        monster[loop].armorclass:=9;
                              end;
                    end;
   callwild,shatter:begin
                         gwriteln(x,y,'     Not a battle spell');
                    end;
               heal:begin
                         gwriteln(x,y,'    Healing soothes you.');
                         player.endurance:=player.endurance+d(6)+1;
                         if (player.endurance>player.endurancemax) then
                              player.endurance:=player.endurancemax;
                         settextstyle(sanseri,horizontal,1);
                         combatstats(player);
                         settextstyle(default,horizontal,1);
                    end;
            courage:begin
                         if not(playereffect.courage) then
                              begin
                                   gwriteln(x,y,'     You become braver.');
                                   player.strength:=player.strength+d(4)+1;
                                   if (player.strength>20) then
                                        player.strength:=20;
                                   player.dexterity:=player.dexterity+d(4)+1;
                                   if (player.dexterity>20) then
                                        player.dexterity:=20;
                              end
                         else
                                   gwriteln(x,y,'     It has no effect.');
                         playereffect.courage:=true;
                    end;
         obliterate:begin
                         y:=320;
                         gwriteln(x,y,'      Select a target:');
                         gwriteln(x,y,'');
                         for count:=1 to nummonsters do
                              begin
                                   str(count,tempstring);
                                   ch:=tempstring[1];
                                   tempstring:='     ';
                                   tempstring:=tempstring + ch + ') ';
                                   tempstring:=tempstring + monster[count].name;
                                   gwriteln(x,y,tempstring);
                              end;
                         repeat
                              ans:=readarrowkey;
                         until (ans in ['1'..ch]);
                         val(ans,tempint,errcode);
                         clearcombatmenu;
                         y:=360;
                         gwrite(x,y,'     You ');
                         setcolor(magenta);
                         gwrite(x,y,'OBLITERATE');
                         setcolor(lightcyan);
                         gwriteln(x,y,' the');
                         x:=120-(trunc(textwidth(monster[tempint].name)/2));
                         gwriteln(x,y,monster[tempint].name);
                         monster[tempint].endurance:=0;
                     end;
             icicle:begin
                         damagetype:='cold';
                         dmgroll.rollnum:=(((player.level-1) DIV 5)*2)+1;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=dmgroll.rollnum;
                         dmg:=droll(dmgroll);
                    end;
              power:begin
                         powerroll:=d(20);
                         case powerroll of
                              1..4:begin
                                        gwriteln(x,y,'      You don''t think');
                                        gwriteln(x,y,'     anything happened.');
                                   end;
                                 5:begin
                                        gwriteln(x,y,'       Roland appears');
                                        gwriteln(x,y,'      and punches you!');
                                        dmg:=d(4);
                                        if (player.endurance<dmg) then
                                             player.endurance:=0
                                        else
                                             player.endurance:=player.endurance-dmg;
                                   end;
                              6..7:begin
                                        gwriteln(x,y,'      You levitate for');
                                        gwriteln(x,y,'          a moment.');
                                   end;
                              8..9:begin
                                        gwriteln(x,y,'      You hear jesters');
                                        gwriteln(x,y,'      laughing at you.');
                                   end;
                            10..11:begin
                                        gwriteln(x,y,'       Thousands of');
                                        gwriteln(x,y,'     butterflies appear');
                                        gwriteln(x,y,'      out of thin air.');
                                   end;
                            12..14:begin
                                        gwriteln(x,y,'    You are kissed by a');
                                        gwriteln(x,y,'          faerie.');
                                        player.endurance:=player.endurance+d(2);
                                        if (player.endurance>player.endurancemax) then
                                             player.endurance:=player.endurancemax;
                                   end;
                            15..16:begin
                                        gwriteln(x,y,'    Your left hand turns');
                                        gwriteln(x,y,'         into a claw.');
                                        player.strength:=player.strength+1;
                                        if (player.strength>20) then
                                             player.strength:=20;
                                   end;
                            17..18:begin
                                        gwriteln(x,y,'       A voice says,');
                                        gwriteln(x,y,'     "watch yourself"');
                                        player.dexterity:=player.dexterity+1;
                                        if (player.dexterity>20) then
                                             player.dexterity:=20;
                                   end;
                                19:begin
                                        if (nummonsters=8) then
                                             begin
                                                  gwriteln(x,y,'        You hear a');
                                                  gwriteln(x,y,'      rumbling noise');
                                             end
                                        else
                                             begin
                                                  {------roll monster-----}
                                                  if not(exist(cfg.wildchart)) then
                                                       exit;
                                                  assign(pasfile,cfg.wildchart);
                                                  reset(pasfile);
                                                  read(pasfile,monsterchart);
                                                  close(pasfile);
                                                  with monsterchart do
                                                     begin
                                                        theroll:=droll(diceroll);
                                                        for count:=1 to 20 do
                                                           begin
                                                              val1:=value[count,1];
                                                              val2:=value[count,2];
                                                              if (theroll in [val1..val2]) then
                                                                 begin
                                                                    monsterfile:=filename[count];
                                                                    numnewmonster:=1;
                                                                 end;
                                                           end;
                                                     end;
                                                  rollmonsters(newmonster,numnewmonster,monsterfile);
                                                  {-----------------------}
                                                  nummonsters:=nummonsters+1;
                                                  monster[nummonsters]:=newmonster[1];
                                                  tempstring:=monster[nummonsters].name;
                                                  tempstring:=capitalize(tempstring);
                                                  x:=120-(trunc(textwidth(tempstring)/2));
                                                  gwriteln(x,y,tempstring);
                                                  gwriteln(x,y,'');
                                                  tempstring:='appears';
                                                  x:=120-(trunc(textwidth(tempstring)/2));
                                                  gwriteln(x,y,tempstring);
                                             end;
                                   end;
                                20:begin
                                        y:=310;
                                        gwriteln(x,y,'      WHOA! MEGADAMAGE!');
                                        gwriteln(x,y,'');
                                        dmgroll.rollnum:=6;
                                        dmgroll.dicetype:=6;
                                        dmgroll.bonus:=6;
                                        dmg:=droll(dmgroll);
                                        thespell:=fireblast;
                                        case d(6) of
                                           2:damagetype:='fire';
                                           3:begin
                                                  damagetype:='cold';
                                                  thespell:=icicle;
                                             end;
                                           4:damagetype:='meteor';
                                           5:damagetype:='acid';
                                           6:damagetype:='poison';
                                        else
                                             damagetype:='lightning';
                                        end;
                                   end;
                         else
                                   begin
                                        gwriteln(x,y,'      You don''t think');
                                        gwriteln(x,y,'     anything happened.');
                                   end;
                         end;
                     end;
            glacier:begin
                         if not(playereffect.glacier) then
                              begin
                                   gwriteln(x,y,'     You''re skin takes');
                                   gwriteln(x,y,'       on a blue hue.');
                                   gwriteln(x,y,'');
                                   gwriteln(x,y,'       You feel cold.');
                              end
                         else
                              gwriteln(x,y,'     It has no effect.');
                         playereffect.glacier:=true;
                    end;
       dragonbreath:begin
                         damagetype:='fire';
                         dmg:=player.endurance;
                    end;
         resistfire:begin
                         if not(playereffect.resistfire) then
                              begin
                                   gwriteln(x,y,'    You become resistant');
                                   gwriteln(x,y,'          to fire.');
                              end
                         else
                              gwriteln(x,y,'     It has no effect.');
                         playereffect.resistfire:=true;
                    end;
         resistcold:begin
                         if not(playereffect.resistcold) then
                              begin
                                   gwriteln(x,y,'    You become resistant');
                                   gwriteln(x,y,'          to cold.');
                              end
                         else
                              gwriteln(x,y,'     It has no effect.');
                         playereffect.resistcold:=true;
                    end;
     end;
     if (dmg<1) then
          dmg:=1;
     if (thespell in [fireblast,icicle]) then
          begin
               y:=320;
               gwriteln(x,y,'      Select a target:');
               gwriteln(x,y,'');
               for count:=1 to nummonsters do
                    begin
                         str(count,tempstring);
                         ch:=tempstring[1];
                         tempstring:='     ';
                         tempstring:=tempstring + ch + ') ';
                         tempstring:=tempstring + monster[count].name;
                         gwriteln(x,y,tempstring);
                    end;
               repeat
                    ans:=readarrowkey;
               until (ans in ['1'..ch]);
               val(ans,tempint,errcode);
               clearcombatmenu;
               y:=340;
               if (monstereffect[count].resistfire)and(damagetype='fire') then
                    dmg:=dmg-player.level;
               if (monstereffect[count].resistcold)and(damagetype='cold') then
                    dmg:=dmg-player.level;
               if (dmg<1) then
                    dmg:=1;
               x:=120-(trunc(textwidth(monster[tempint].name)/2));
               gwriteln(x,y,monster[tempint].name);
               str(dmg,tempstring);
               tempstring:='takes (' + tempstring + ')';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
               tempstring:=damagetype + ' damage';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
               if (monster[tempint].endurance<=dmg) then
                    monster[tempint].endurance:=0
               else
                    monster[tempint].endurance:=monster[tempint].endurance-dmg;
               gwriteln(x,y,'');
               if (monster[tempint].endurance=0) then
                    gwriteln(x,y,'           KILLED');
          end;
     if (thespell in [dragonbreath,icestorm]) then
          begin
               y:=360;
               gwriteln(x,y,'     All monsters take');
               gwriteln(x,y,'          damage...');
               originaldmg:=dmg;
               for count:=1 to nummonsters do
                    begin
                         combatmenuprompt;
                         clearcombatmenu;
                         y:=360;
                         dmg:=originaldmg;
                         if (monstereffect[count].resistfire) and
                            (damagetype='fire') then
                              dmg:=dmg-player.level;
                         if (monstereffect[count].resistcold) and
                            (damagetype='cold') then
                              dmg:=dmg-player.level;
                         saveroll:=d(20);
                         if ((saveroll>=monster[count].savingthrow)and(saveroll>1))or(saveroll=20) then
                              dmg:=trunc(dmg/2);
                         if (dmg<1) then
                              dmg:=1;
                         if (nummonsters>1) then
                              begin
                                   str(count,tempstring);
                                   tempstring:=monster[count].name + ' ' + tempstring;
                              end
                         else
                              tempstring:=monster[count].name;
                         x:=120-(trunc(textwidth(tempstring)/2));
                         gwriteln(x,y,tempstring);
                         str(dmg,tempstring);
                         tempstring:='takes (' + tempstring + ')';
                         x:=120-(trunc(textwidth(tempstring)/2));
                         gwriteln(x,y,tempstring);
                         tempstring:=damagetype + ' damage';
                         x:=120-(trunc(textwidth(tempstring)/2));
                         gwriteln(x,y,tempstring);
                         if (monster[count].endurance<=dmg) then
                              monster[count].endurance:=0
                         else
                              monster[count].endurance:=monster[count].endurance-dmg;
                         gwriteln(x,y,'');
                         if (monster[count].endurance=0) then
                              gwriteln(x,y,'           KILLED');
                    end;
          end;
     if not(player.spell[spellnum] in [shatter,callwild]) then
          player.charges:=player.charges-1;

end;
{---------------------------------------------------------------------------}
procedure playerturn(var player:playerrecord;var nummonsters:integer;
                     var monster:monsterlist;var xppool:longint;
                     var coinpool:longint;var playereffect:effectrecord;
                     var monstereffect:effectlist);

var
     done           :    boolean;
     count          :    integer;
     tempstring     :    string[40];
     action         :    (attack,use,cast);
     tempint        :    integer;
     errcode        :    integer;
     loop           :    integer;
     deadmonster    :    boolean;

begin

     done:=false;
     repeat
          clearcombatmenu;
          settextstyle(sanseri,horizontal,1);
          y:=300;
          gwriteln(x,y,'');
          gwriteln(x,y,'     (A)ttack');
          gwriteln(x,y,'');
          gwriteln(x,y,'     (U)se an item');
          if (ring in player.stages) then
               begin
                    gwriteln(x,y,'');
                    gwriteln(x,y,'     (C)ast a spell');
                    repeat
                          ans:=readarrowkey;
                    until (ans in ['a','A','u','U','c','C']);
               end
          else
               begin
                    repeat
                          ans:=readarrowkey;
                    until (ans in ['a','A','u','U']);
               end;
          case ans of
             'a','A':action:=attack;
             'u','U':action:=use;
             'c','C':action:=cast;
          end;{case}
          clearcombatmenu;
          settextstyle(default,horizontal,1);
          y:=300;
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          if (action=attack) then
               begin
                    gwriteln(x,y,'           ATTACK');
                    gwriteln(x,y,'');
                    for count:=1 to nummonsters do
                         begin
                              str(count,tempstring);
                              ch:=tempstring[1];
                              tempstring:='     ';
                              tempstring:=tempstring + ch + ') ';
                              tempstring:=tempstring + monster[count].name;
                              gwriteln(x,y,tempstring);
                         end;
                    gwriteln(x,y,'     N)one');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..ch,'n','N']);
                    done:=not(ans in ['n','N']);
                    val(ans,tempint,errcode);
                    if done then
                         attackmonster(player,monster[tempint],playereffect,
                                       monstereffect[tempint]);
               end;
          if (action=use) then
               begin
                    gwriteln(x,y,'          USE ITEM');
                    gwriteln(x,y,'');
                    for count:=1 to player.numitems do
                         begin
                              if (player.item[count] in
                                  [sword..axe,chainmail..flamewand]) then
                                   setcolor(cyan)
                              else
                                   setcolor(lightcyan);
                              str(count,tempstring);
                              ch:=tempstring[1];
                              tempstring:='      ';
                              tempstring:=tempstring + ch + '. ';
                              tempstring:=tempstring + itemstring(player.item[count]);
                              gwriteln(x,y,tempstring);
                         end;
                    setcolor(lightcyan);
                    gwriteln(x,y,'      N)one');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..ch,'n','N']);
                    done:=not(ans in ['n','N']);
                    if done then
                         begin
                              clearcombatmenu;
                              y:=300;
                              gwriteln(x,y,'');
                              gwriteln(x,y,'');
                              gwriteln(x,y,'');
                              gwriteln(x,y,'');
                              val(ans,tempint,errcode);
                              if (player.item[tempint] in
                                  [sword..axe,chainmail..flamewand]) then
                                   done:=false;
                              combatuse(player,tempint,nummonsters,monster,playereffect);
                         end;
               end;
          if (action=cast) then
               begin
                    gwriteln(x,y,'         CAST SPELL');
                    gwriteln(x,y,'');
                    for count:=1 to player.numspells do
                    begin
                         if (player.spell[count] in [callwild,shatter]) then
                              setcolor(cyan)
                         else
                              setcolor(lightcyan);
                         str(count,tempstring);
                         ch:=tempstring[1];
                         tempstring:='      ';
                         tempstring:=tempstring + ch + '. ';
                         tempstring:=tempstring + spellstring(player.spell[count]);
                         gwriteln(x,y,tempstring);
                    end;
                    setcolor(lightcyan);
                    gwriteln(x,y,'      N)one');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..ch,'n','N']);
                    done:=not(ans in ['n','N']);
                    if done and (player.charges=0) then
                         begin
                              clearcombatmenu;
                              y:=340;
                              gwriteln(x,y,'       You''re out of');
                              gwriteln(x,y,'           magic.');
                              done:=false;
                         end;
                    if done then
                         begin
                              clearcombatmenu;
                              y:=300;
                              gwriteln(x,y,'');
                              gwriteln(x,y,'');
                              val(ans,tempint,errcode);
                              if (player.spell[tempint] in [callwild,shatter]) then
                                   done:=false;
                              combatcast(player,tempint,nummonsters,monster,
                                         playereffect,monstereffect);
                         end;
               end;
          if not(done) then
               combatmenuprompt;
     until (done);
     deadmonster:=true;
     while deadmonster do
          begin
               deadmonster:=false;
               for count:=1 to nummonsters do
                    if (monster[count].endurance=0) then
                         begin
                              tempint:=count;
                              deadmonster:=true;
                         end;
               if deadmonster then
                    begin
                         xppool:=xppool + monster[tempint].xpvalue;
                         coinpool:=coinpool + monster[tempint].coins;
                         for loop:=tempint to (nummonsters-1) do
                              monster[loop]:=monster[loop+1];
                         nummonsters:=nummonsters-1;
                    end;
          end;
     combatmenuprompt;
     if (player.endurance=0) then
          died;
     if (nummonsters>0) then
          combatscreen(player,nummonsters,monster);
end;
{---------------------------------------------------------------------------}
procedure monsterattack(var player:playerrecord;monsternum:integer;
                        var themonster:monsterrecord;
                        var playereffect:effectrecord;
                        var themonstereffect:effectrecord);

var
     dmg       :    integer;
     tempstring:    stringtype;
     ac        :    integer;
     hitroll   :    integer;

begin
     settextstyle(default,horizontal,1);
     ac:=player.armorclass;
     if (playereffect.glacier) and (ac>4) then
          ac:=4;
     y:=360;
     if (nummonsters>1) then
          begin
               str(monsternum,tempstring);
               tempstring:=themonster.name + ' ' + tempstring;
          end
     else
          tempstring:=themonster.name;
     x:=120-(trunc(textwidth(tempstring)/2));
     gwriteln(x,y,tempstring);
     hitroll:=d(20);
     if ((d(20)>=(themonster.thac0-ac))and(hitroll>1))or(hitroll=20) then
          begin
               tempstring:=themonster.attacktype + ' YOU!';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
               dmg:=droll(themonster.damage);
               if (dmg<1) then
                    dmg:=1;
               str(dmg,tempstring);
               tempstring:='('+tempstring+')';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
               if (dmg>player.endurance) then
                    player.endurance:=0
               else
                    player.endurance:=player.endurance-dmg;
               if (player.endurance=0) then
                    begin
                         gwriteln(x,y,'');
                         x:=120-(trunc(textwidth('KILLED')/2));
                         gwriteln(x,y,'KILLED');
                    end;
          end
     else
          begin
               gwriteln(x,y,'');
               tempstring:='misses';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
          end;

end;
{---------------------------------------------------------------------------}
procedure monstercast(var player:playerrecord;spellnum:integer;
                      monsternum:integer;var themonster:monsterrecord;
                      var playereffect:effectrecord;
                      var themonstereffect:effectrecord);

var
     tempstring     :    stringtype;
     thespell       :    spell;
     damagetype     :    stringtype;
     dmgroll        :    dicerecord;
     dmg            :    integer;
     count          :    integer;
     tempint        :    integer;
     monsterchart   :    chartrecord;
     pasfile        :    file of chartrecord;
     theroll        :    integer;
     val1           :    integer;
     val2           :    integer;
     monsterfile    :    stringtype;
     newmonster     :    monsterlist;
     numnewmonster  :    integer;
     saveroll       :    integer;

begin
     settextstyle(default,horizontal,1);
     y:=340;
     if (nummonsters>1) then
          begin
               str(monsternum,tempstring);
               tempstring:=themonster.name + ' ' + tempstring;
          end
     else
          tempstring:=themonster.name;
     x:=120-(trunc(textwidth(tempstring)/2));
     gwriteln(x,y,tempstring);
     thespell:=themonster.spell[spellnum];
     damagetype:='';
     case thespell of
           icestorm:begin
                         gwriteln(x,y,'       casts a spell');
                         damagetype:='cold';
                         dmgroll.rollnum:=themonster.hitdice;
                         if (dmgroll.rollnum>20) then
                              dmgroll.rollnum:=20;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=0;
                         dmg:=droll(dmgroll);
                    end;
          fireblast:begin
                         gwriteln(x,y,'       casts a spell');
                         damagetype:='fire';
                         dmgroll.rollnum:=(((themonster.hitdice-1) DIV 5)*2)+1;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=dmgroll.rollnum;
                         dmg:=droll(dmgroll);
                    end;
             freeze:begin
                         gwriteln(x,y,'    freezes you, slowing');
                         gwriteln(x,y,'         you down...');
                         player.dexterity:=player.dexterity-2;
                         if (player.dexterity<1) then
                              player.dexterity:=1;
                    end;
                web:begin
                         gwriteln(x,y,'      ties you up with');
                         gwriteln(x,y,'         sticky web');
                         player.dexterity:=player.dexterity-2;
                         if (player.dexterity<1) then
                              player.dexterity:=1;
                    end;
   callwild,shatter:begin
                         gwriteln(x,y,'       tries to cast');
                         gwriteln(x,y,'      a spell but fails');
                    end;
               heal:begin
                         gwriteln(x,y,'          is healed');
                         themonster.endurance:=themonster.endurance+d(6)+1;
                         if (themonster.endurance>themonster.endurancemax) then
                              themonster.endurance:=themonster.endurancemax;
                    end;
            courage:begin
                         if not(themonstereffect.courage) then
                              begin
                                   gwriteln(x,y,'     becomes faster and');
                                   gwriteln(x,y,'           stronger');
                                   themonster.armorclass:=themonster.armorclass-1;
                                   themonster.thac0:=themonster.thac0-1;
                                   themonster.damage.bonus:=themonster.damage.bonus+1;
                              end
                         else
                              begin
                                   gwriteln(x,y,'       tries to cast');
                                   gwriteln(x,y,'      a spell but fails');
                              end;
                         themonstereffect.courage:=true;
                    end;
         obliterate:begin
                         y:=320;
                         textcolor(magenta);
                         gwrite(x,y,'      OBLITERATES');
                         textcolor(lightcyan);
                         gwriteln(x,y,' you');
                         player.endurance:=0;
                     end;
             icicle:begin
                         gwriteln(x,y,'       casts a spell');
                         damagetype:='cold';
                         dmgroll.rollnum:=(((themonster.hitdice-1) DIV 5)*2)+1;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=dmgroll.rollnum;
                         dmg:=droll(dmgroll);
                    end;
              power:begin
                         case d(8) of
                              1..6:begin
                                        gwriteln(x,y,'       tries to cast');
                                        gwriteln(x,y,'      a spell but fails');
                                   end;
                                 7:begin
                                        gwriteln(x,y,'       casts a spell');
                                        if (nummonsters=8) then
                                             begin
                                                  gwriteln(x,y,'        You hear a');
                                                  gwriteln(x,y,'      rumbling noise');
                                             end
                                        else
                                             begin
                                                  {------roll monster-----}
                                                  if not(exist(cfg.wildchart)) then
                                                       exit;
                                                  assign(pasfile,cfg.wildchart);
                                                  reset(pasfile);
                                                  read(pasfile,monsterchart);
                                                  close(pasfile);
                                                  with monsterchart do
                                                     begin
                                                        theroll:=droll(diceroll);
                                                        for count:=1 to 20 do
                                                           begin
                                                              val1:=value[count,1];
                                                              val2:=value[count,2];
                                                              if (theroll in [val1..val2]) then
                                                                 begin
                                                                    monsterfile:=filename[count];
                                                                    numnewmonster:=1;
                                                                 end;
                                                           end;
                                                     end;
                                                  rollmonsters(newmonster,numnewmonster,monsterfile);
                                                  {-----------------------}
                                                  nummonsters:=nummonsters+1;
                                                  monster[nummonsters]:=newmonster[1];
                                                  tempstring:=monster[nummonsters].name;
                                                  tempstring:=capitalize(tempstring);
                                                  x:=120-(trunc(textwidth(tempstring)/2));
                                                  gwriteln(x,y,tempstring);
                                                  gwriteln(x,y,'');
                                                  tempstring:='appears';
                                                  x:=120-(trunc(textwidth(tempstring)/2));
                                                  gwriteln(x,y,tempstring);
                                             end;
                                   end;
                                 8:begin
                                        gwriteln(x,y,'       casts a spell');
                                        dmgroll.rollnum:=6;
                                        dmgroll.dicetype:=6;
                                        dmgroll.bonus:=6;
                                        dmg:=droll(dmgroll);
                                        thespell:=fireblast;
                                        case d(6) of
                                           2:damagetype:='fire';
                                           3:begin
                                                  damagetype:='cold';
                                                  thespell:=icicle;
                                             end;
                                           4:damagetype:='meteor';
                                           5:damagetype:='acid';
                                           6:damagetype:='poison';
                                        else
                                             damagetype:='lightning';
                                        end;
                                   end;
                         end;
                     end;
            glacier:begin
                         if not(themonstereffect.glacier) then
                              begin
                                   gwriteln(x,y,'         skin takes');
                                   gwriteln(x,y,'       on a blue hue.');
                              end
                         else
                              begin
                                   gwriteln(x,y,'       tries to cast');
                                   gwriteln(x,y,'      a spell but fails');
                              end;
                         themonstereffect.glacier:=true;
                    end;
       dragonbreath:begin
                         gwriteln(x,y,'          breathes');
                         damagetype:='fire';
                         dmg:=themonster.endurance;
                    end;
         resistfire:begin
                         if not(themonstereffect.resistfire) then
                              begin
                                   gwriteln(x,y,'      becomes resistant');
                                   gwriteln(x,y,'          to fire.');
                              end
                         else
                              begin
                                   gwriteln(x,y,'       tries to cast');
                                   gwriteln(x,y,'      a spell but fails');
                              end;
                         themonstereffect.resistfire:=true;
                    end;
         resistcold:begin
                         if not(themonstereffect.resistcold) then
                              begin
                                   gwriteln(x,y,'       becomes resistant');
                                   gwriteln(x,y,'          to cold.');
                              end
                         else
                              begin
                                   gwriteln(x,y,'       tries to cast');
                                   gwriteln(x,y,'      a spell but fails');
                              end;
                         themonstereffect.resistcold:=true;
                    end;
     end;
     if (dmg<1) then
          dmg:=1;
     if (thespell in [fireblast,icicle]) then
          begin
               if (playereffect.resistfire) and (damagetype='fire') then
                    dmg:=dmg-themonster.hitdice;
               if (playereffect.resistcold) and (damagetype='cold') then
                    dmg:=dmg-themonster.hitdice;
               if (dmg<1) then
                    dmg:=1;
               str(dmg,tempstring);
               tempstring:='you take (' + tempstring + ')';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
               tempstring:=damagetype + ' damage';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
               if (player.endurance<=dmg) then
                    player.endurance:=0
               else
                    player.endurance:=player.endurance-dmg;
               gwriteln(x,y,'');
               if (player.endurance=0) then
                    gwriteln(x,y,'           KILLED');
          end;
     if (thespell in [dragonbreath,icestorm]) then
          begin
               if (playereffect.resistfire) and (damagetype='fire') then
                    dmg:=dmg-themonster.hitdice;
               if (playereffect.resistcold) and (damagetype='cold') then
                    dmg:=dmg-themonster.hitdice;
               saveroll:=d(20);
               if ((saveroll>=player.savingthrow)and(saveroll>1))or(saveroll=20) then
                    dmg:=trunc(dmg/2);
               if (dmg<1) then
                    dmg:=1;
               str(dmg,tempstring);
               tempstring:='you take (' + tempstring + ')';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
               tempstring:=damagetype + ' damage';
               x:=120-(trunc(textwidth(tempstring)/2));
               gwriteln(x,y,tempstring);
               if (player.endurance<=dmg) then
                    player.endurance:=0
               else
                    player.endurance:=player.endurance-dmg;
               gwriteln(x,y,'');
               if (player.endurance=0) then
                    gwriteln(x,y,'           KILLED');
          end;
end;
{---------------------------------------------------------------------------}
procedure monsterturn(var player:playerrecord;var nummonsters:integer;
                      var monster:monsterlist;var xppool:longint;
                      var coinpool:longint;var playereffect:effectrecord;
                      var monstereffect:effectlist);

var
     action         :    (flee,cast,attack);
     loop           :    integer;
     tempint        :    integer;
     avgdmg         :    integer;
     deadmonster    :    boolean;
     count          :    integer;
     spellcounter   :    array[1..monstermax] of integer;
     tempstring     :    stringtype;
     fleehp         :    integer;

begin
     y:=300;
     settextstyle(sanseri,horizontal,1);
     setcolor(lightcyan);
     clearcombatmenu;
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     gwriteln(x,y,'          The');
     gwriteln(x,y,'        Monsters');
     gwriteln(x,y,'         Attack');
     combatmenuprompt;
     for loop:=1 to monstermax do
          spellcounter[loop]:=0;
     for loop:=1 to nummonsters do
        begin
          fleehp:=10;
          if (monster[loop].endurance>0) then
               begin
                    with monster[loop] do
                         begin
                              action:=attack;
                              if (alignment in ['n','N']) then
                                   fleehp:=20;
                              tempint:=trunc((endurance/endurancemax)*100);
                              if (tempint<=fleehp)and((d(6)+d(6)>morale)) then
                                   action:=flee;
                              with damage do
                                   avgdmg:=trunc(((rollnum+bonus)+(rollnum*dicetype+bonus))/2);
                              if not(action=flee) and (numspells>0)
                                 and (spellcounter[loop]<(numspells+2)) then
                                   begin
                                        tempint:=(numspells*25)-avgdmg;
                                        if (tempint>99) then
                                             tempint:=99;
                                        if (d(100)<=tempint) then
                                             action:=cast;
                                   end;
                              if (action=cast) then
                                   begin
                                        tempint:=d(numspells);
                                        case spell[tempint] of
                                          courage:if (monstereffect[loop].courage) then
                                                       action:=attack;
                                       resistcold:if (monstereffect[loop].resistcold) then
                                                       action:=attack;
                                       resistfire:if (monstereffect[loop].resistfire) then
                                                       action:=attack;
                                          glacier:if (monstereffect[loop].glacier) then
                                                       action:=attack;
                                        end;
                                   end;
                         end;
               end;
               clearcombatmenu;
               if (action=flee) then
                    begin
                         y:=360;
                         with monster[loop] do
                             begin
                                  str(loop,tempstring);
                                  tempstring:=name + ' ' +tempstring;
                                  x:=120-(trunc(textwidth(tempstring)/2));
                                  gwriteln(x,y,tempstring);
                                  gwriteln(x,y,'');
                                  tempstring:='runs away';
                                  x:=120-(trunc(textwidth(tempstring)/2));
                                  gwriteln(x,y,tempstring);
                                  endurance:=0;
                                  xpvalue:=0;
                                  coins:=0;
                             end;
                    end;
               if (action=cast) then
                    begin
                         monstercast(player,tempint,loop,monster[loop],
                                     playereffect,monstereffect[loop]);
                         spellcounter[loop]:=spellcounter[loop]+1;
                    end;
               if (action=attack) then
                    begin
                         monsterattack(player,loop,monster[loop],
                                       playereffect,monstereffect[loop]);
                    end;
               settextstyle(sanseri,horizontal,1);
               combatstats(player);
               settextstyle(default,horizontal,1);
               combatmenuprompt;
               if (player.endurance=0) then
                   died;
        end;
     deadmonster:=true;
     while deadmonster do
          begin
               deadmonster:=false;
               for count:=1 to nummonsters do
                    if (monster[count].endurance=0) then
                         begin
                              tempint:=count;
                              deadmonster:=true;
                         end;
               if deadmonster then
                    begin
                         xppool:=xppool + monster[tempint].xpvalue;
                         coinpool:=coinpool + monster[tempint].coins;
                         for loop:=tempint to (nummonsters-1) do
                              monster[loop]:=monster[loop+1];
                         nummonsters:=nummonsters-1;
                    end;
          end;
     if (nummonsters>0) then
          combatscreen(player,nummonsters,monster);
end;
{---------------------------------------------------------------------------}
procedure writeflee;

begin
     setcolor(lightcyan);
     settextstyle(sanseri,horizontal,1);
     outtextxy(40,360,'  You run away...');
end;
{---------------------------------------------------------------------------}
procedure combat(var player:playerrecord;var nummonsters:integer;
                 monster:monsterlist);

var
     oldplayer      :    playerrecord;
     xppool         :    longint;
     coinpool       :    longint;
     flee           :    boolean;
     tempstring     :    stringtype;
     playereffect   :    effectrecord;
     monstereffect  :    effectlist;
     loop           :    integer;

begin
     oldplayer:=player;
     flee:=false;
     xppool:=0;
     coinpool:=0;
     with playereffect do
          begin
               blue:=false;
               courage:=false;
               resistfire:=false;
               resistcold:=false;
               glacier:=false;
          end;
     for loop:=1 to nummonsters do
          with monstereffect[loop] do
               begin
                    blue:=false;
                    courage:=false;
                    resistfire:=false;
                    resistcold:=false;
                    glacier:=false;
               end;
     repeat
          calcstats(player);
          combatscreen(player,nummonsters,monster);
          setcolor(lightcyan);
          settextstyle(sanseri,horizontal,3);
          y:=300;
          gwriteln(x,y,'');
          gwriteln(x,y,'      (F)ight');
          y:=y+10;
          gwriteln(x,y,'        or');
          x:=x+5;
          y:=y+10;
          gwriteln(x,y,'      (R)un');
          repeat
               ch:=readarrowkey;
          until (ch in ['f','F','r','R']);
          clearcombatmenu;
          flee:=(ch in ['r','R']);
          if (d(10)<=d(10)) then              {Roll Initiative}
               begin
                    monsterturn(player,nummonsters,monster,xppool,coinpool,
                                playereffect,monstereffect);
                    if not(flee) then
                         begin
                              if (nummonsters>0) then
                                   playerturn(player,nummonsters,monster,xppool,
                                              coinpool,playereffect,monstereffect)
                         end
                    else
                         begin
                              writeflee;
                              coinpool:=0;
                         end;
               end
          else
               if not(flee) then
                    begin
                         playerturn(player,nummonsters,monster,xppool,
                                    coinpool,playereffect,monstereffect);
                         if (nummonsters>0) then
                              monsterturn(player,nummonsters,monster,xppool,coinpool,
                                          playereffect,monstereffect);
                    end
               else
                    begin
                         writeflee;
                         coinpool:=0;
                    end;
     until (flee)or(nummonsters=0);

     {readjust stats using oldplayer}
     player.strength:=oldplayer.strength;
     player.dexterity:=oldplayer.dexterity;

     with player do                     {Add xp and treasure}
          begin
               experience:=experience + xppool;
               coins:=coins + coinpool;
               setcolor(white);
               settextstyle(default,horizontal,1);
               y:=460;
               gwriteln(x,y,'');
               gwrite(x,y,'You gain:');
               str(xppool,tempstring);
               tempstring:='  ' + tempstring + ' exp, ';
               gwrite(x,y,tempstring);
               str(coinpool,tempstring);
               tempstring:=tempstring + ' coin(s)';
               gwrite(x,y,tempstring);
               prompt;
          end;
     calcstats(player);

end;
