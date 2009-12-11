{The Elf Skull Inn}
{---------------------------------------------------------------------------}
procedure clearesi;

begin
     setfillstyle(solidfill,black);
     bar(0,175,640,480);
end;
{---------------------------------------------------------------------------}
procedure esi_gossip;

begin
     setcolor(lightred);
     gwriteln(x,y,'You overhear some gossip...');
     gwriteln(x,y,'');
     case d(8) of
        1:writefile(250,'040.txt');
        2:writefile(250,'041.txt');
        3:writefile(250,'042.txt');
        4:writefile(250,'043.txt');
        5:writefile(250,'044.txt');
        6:writefile(250,'045.txt');
        7:writefile(250,'046.txt');
        8:writefile(250,'047.txt');
     end;{case}

end;
{---------------------------------------------------------------------------}
procedure esi_dilvish(var player:playerrecord);

var
     tempmonster    :    monsterlist;

begin
     setcolor(green);
     writefile(200,'048.txt');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['y','Y']) then
          begin
               clearesi;
               writefile(175,'049.txt');
               repeat
                    ans:=readarrowkey;
               until (ans in ['a','A','s','S']);
               player.stages:=player.stages + [dilvish];
               if (ans in ['a','A']) then
                    begin
                         nummonsters:=1;
                         rollmonsters(tempmonster,nummonsters,'dilvish.dat');
                         monster[1]:=tempmonster[1];
                         rollmonsters(tempmonster,nummonsters,'prudence.dat');
                         monster[2]:=tempmonster[1];
                         rollmonsters(tempmonster,nummonsters,'spirit.dat');
                         monster[3]:=tempmonster[1];
                         rollmonsters(tempmonster,nummonsters,'marcus.dat');
                         monster[4]:=tempmonster[1];
                         nummonsters:=4;
                         combat(player,nummonsters,monster);
                         cleardevice;
                         drawpicturebyline(70,10,'esi.ln1');
                         settextstyle(small,horizontal,6);
                         setcolor(green);
                         y:=175;
                         gwriteln(x,y,'');
                         gwriteln(x,y,'');
                         if (nummonsters=0) then
                              begin
                                   gwriteln(x,y,'You killed the elf and his companions.');
                              end
                         else
                              gwriteln(x,y,'You escape and climb back up through the trap door.');
                         gwriteln(x,y,'You quickly go back to the bar.');
                    end
               else
                    begin
                         clearesi;
                         writefile(175,'050.txt');
                         prompt;
                         clearesi;
                         writefile(175,'051.txt');
                         repeat
                              ans:=readarrowkey;
                         until (ans in ['y','Y','n','N']);
                         clearesi;
                         y:=175;
                         if (ans in ['y','Y']) and 
                            not((player.numspells=spellmax) or not(ring in player.stages))then
                              with player do
                                   begin
                                        gwriteln(x,y,'You learn SHATTER.');
                                        chargemax:=chargemax + 1;
                                        if(chargemax>ringmax)then
                                             chargemax:=ringmax;
                                        charges:=charges+1;
                                        if(charges>chargemax)then
                                             charges:=chargemax;
                                        numspells:=numspells + 1;
                                        spell[numspells]:=shatter;
                                   end
                         else
                              if (player.numspells=spellmax) then
                                   gwriteln(x,y,'Sorry, you can''t learn any more spells.')
                              else
                                   if not(ring in player.stages) then
                                        gwriteln(x,y,'You need a ring to store your spells.')
                                   else
                                             gwriteln(x,y,'You humbly decline his offer.');
                         gwriteln(x,y,'Dilvish and his companions bid you farewell.');
                    end;
          end;
end;
{---------------------------------------------------------------------------}
procedure esi_encounter(var player:playerrecord);

begin
     setcolor(lightblue);
     case d(6) of
        1:begin
               if not(baltar in player.stages) then
                    begin
                         writefile(200,'052.txt');
                         repeat
                              ans:=readarrowkey;
                         until (ans in ['y','Y','n','N']);
                         clearesi;
                         if (ans in ['y','Y']) then
                              writefile(175,'058.txt')
                         else
                              begin
                                   clearesi;
                                   writefile(175,'059.txt');
                                   repeat
                                        ans:=readarrowkey;
                                   until (ans in ['y','Y','n','N']);
                                   clearesi;
                                   if (ans in ['n','N']) then
                                        writefile(175,'060.txt')
                                   else
                                        begin
                                             nummonsters:=1;
                                             rollmonsters(monster,nummonsters,'baltar.dat');
                                             combat(player,nummonsters,monster);
                                             cleardevice;
                                             drawpicturebyline(70,10,'esi.ln1');
                                             settextstyle(small,horizontal,6);
                                             setcolor(lightblue);
                                             y:=175;
                                             gwriteln(x,y,'');
                                             gwriteln(x,y,'');
                                             if (nummonsters=0) then
                                                  begin
                                                       player.stages:=player.stages+[baltar];
                                                       gwriteln(x,y,'The crowd goes wild as you defeat Baltar!');
                                                  end
                                             else
                                                  gwriteln(x,y,'You are able to unlock the cage and escape.');
                                             gwriteln(x,y,'You go back to the bar.');
                                        end;
                              end;
                    end
               else
                    esi_gossip;
          end;
        2:begin
               writefile(200,'053.txt');
          end;
        3:begin
               writefile(200,'054.txt');
          end;
        4:begin
               writefile(200,'055.txt');
          end;
        5:begin
               writefile(200,'056.txt');
          end;
        6:begin
               writefile(200,'057.txt');
          end;
     end;{case}

end;
{---------------------------------------------------------------------------}
procedure esi_drink(var player:playerrecord);

var
     tempstring     :    stringtype;
     drinkprice     :    integer;

begin
     y:=175;
     gwriteln(x,y,'''''What''ll ya have?'''' asks Ahab the one-eyed bartender.');
     gwriteln(x,y,'He points to a sign over the bar...');
     gwriteln(x,y,'');
     gwriteln(x,y,'     (1) beer           (1 coins)');
     gwriteln(x,y,'     (2) ale            (1 coins)');
     gwriteln(x,y,'     (3) mead           (2 coins)');
     gwriteln(x,y,'     (4) wine           (2 coins)');
     gwriteln(x,y,'     (5) rum            (3 coins)');
     gwriteln(x,y,'     (6) whiskey        (3 coins)');
     gwriteln(x,y,'     (7) gin            (3 coins)');
     gwriteln(x,y,'     (8) vodka          (3 coins)');
     gwriteln(x,y,'     (9) Gorgon''s Milk   (5 coins)');
     gwriteln(x,y,'     (N) No thanks');
     str(player.coins,tempstring);
     settextstyle(default,horizontal,1);
     setcolor(white);
     outtextxy(250,460,('You have ' + tempstring + ' coins'));
     setcolor(yellow);
     settextstyle(small,horizontal,6);
     gwriteln(x,y,'');
     gwriteln(x,y,'What do you take?');
     repeat
          ans:=readarrowkey;
     until (ans in ['1'..'9','n','N']);
     if (ans in ['n','N']) then
          begin
               setcolor(lightblue);
               gwriteln(x,y,'                         Ahab grumbles');
               settextstyle(small,horizontal,6);
               prompt;
               exit;
          end;
     case ans of
          '1':drinkprice:=1;
          '2':drinkprice:=1;
          '3':drinkprice:=2;
          '4':drinkprice:=2;
          '5':drinkprice:=3;
          '6':drinkprice:=3;
          '7':drinkprice:=3;
          '8':drinkprice:=3;
          else
               drinkprice:=5;
     end;
     if (player.coins<drinkprice) then
          begin
               setcolor(green);
               broke;
          end
     else
          begin
               clearesi;
               y:=175;
               setcolor(red);
               gwriteln(x,y,'You sit down and have you''re drink.');
               player.coins:=player.coins - drinkprice;
               gwriteln(x,y,'');
               case d(100) of
                   1..20:begin
                              writefile(200,'061.txt');
                         end;
                  21..80:begin
                              esi_gossip;
                         end;
                  81..90:begin
                              gwriteln(x,y,'Ahab leans over to tell you a secret.');
                              gwriteln(x,y,'     ''''Should ye wish to stay the night, I could send a little');
                              gwriteln(x,y,'     company up to yer room, if ya know what I mean.''''');
                              gwriteln(x,y,'Ahab lifts the patch over his eye to give you a wink.');
                         end;
                  91..95:begin
                              if (dilvish in player.stages) then
                                   esi_gossip
                              else
                                   esi_dilvish(player);
                         end;
                 96..100:begin
                              esi_encounter(player);
                         end;
                end;{case}
               settextstyle(small,horizontal,6);
               prompt;
          end;

end;
{---------------------------------------------------------------------------}
procedure esi_room(var player:playerrecord);

var
     roomprice      :    longint;
     company        :    boolean;


begin
     y:=175;
     gwriteln(x,y,'''''Rooms are 5 coins per night,'''' says Ahab.');
     roomprice:=5;
     gwriteln(x,y,'');
     gwrite(x,y,'Do you want a room?  (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['y','Y']) then
          begin
               gwriteln(x,y,'  y');
               gwriteln(x,y,'''How about a little company tonight?  Only 20 coins.''');
               gwriteln(x,y,'');
               gwriteln(x,y,'You respond?  (y/n)');
               repeat
                    ans:=readarrowkey;
               until (ans in ['y','Y','n','N']);
               company:=(ans in ['y','Y']);
               if (company) then
                    roomprice:=roomprice+20;
               if (player.coins<roomprice) then
                    begin
                         clearesi;
                         setcolor(green);
                         broke;
                         exit;
                    end
               else
                    player.coins:=player.coins - roomprice;
               clearesi;
               y:=175;
               setcolor(magenta);
               gwriteln(x,y,'You stay the night at the Elf Skull Inn.');
               gwriteln(x,y,'');
               player.charges:=player.chargemax;
               if (company) then
                    begin
                         writefile(200,'062.txt');
                         prompt;
                         clearesi;
                         y:=175;
                         if (d(100)<=1) then
                              begin
                                   writefile(175,'063.txt');
                                   prompt;
                                   nummonsters:=1;
                                   rollmonsters(monster,nummonsters,'succubus.dat');
                                   combat(player,nummonsters,monster);
                                   cleardevice;
                                   drawpicturebyline(70,10,'esi.ln1');
                                   settextstyle(small,horizontal,6);
                                   x:=10;
                                   y:=175;
                                   setcolor(magenta);
                                   gwriteln(x,y,'Maybe you should enjoy your room alone from now on...');
                              end
                         else
                              begin
                                   x:=10;
                                   gwriteln(x,y,'You enjoy yourselves, but don''t get much rest.');
                                   player.endurance:=player.endurance + d(2);
                                   if (player.endurance>player.endurancemax) then
                                        player.endurance:=player.endurancemax;
                              end;
                    end
               else
                    begin
                         gwriteln(x,y,'Loud parties and bouts of laughter keep you up half the night,');
                         gwriteln(x,y,'but eventually you get to sleep.');
                         player.endurance:=player.endurance + d(3);
                         if (player.endurance>player.endurancemax) then
                              player.endurance:=player.endurancemax;
                    end;
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure esi_dice(var player:playerrecord);

var
     tempstring     :    stringtype;
     bet            :    word;
     errcode        :    integer;
     roll           :    array[1..2] of integer;
     loop           :    integer;
     total          :    integer;

begin
     y:=175;
     gwriteln(x,y,'You walk over to the craps table.');
     gwriteln(x,y,'');
     gwriteln(x,y,'Do you play?  (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['y','Y']) then
          begin
               gwriteln(x,y,'');
               gwrite(x,y,'You bet (up to 1000 coins): ');
               gread(x,y,tempstring);
               val(tempstring,bet,errcode);
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               if (bet<1) then
                    begin
                         gwriteln(x,y,'What''s the point of playing for nothing?');
                         prompt;
                         exit;
                    end;
               if (bet>1000) then
                    begin
                         gwriteln(x,y,'Sorry, they don''t accept such high bets.');
                         prompt;
                         exit;
                    end;
               if (player.coins<bet) then
                    begin
                         setcolor(lightcyan);
                         broke;
                         exit;
                    end;
               clearesi;
               y:=175;
               setcolor(cyan);
               gwriteln(x,y,'You have placed your bet, now press space to roll the dice.');
               repeat
                    ch:=readarrowkey;
               until (ch=' ');
               for loop:=1 to 2 do
                    begin
                         roll[loop]:=d(6);
                         case roll[loop] of
                              1:drawpicturebyline(200+((loop-1)*50),200,'die1.ln1');
                              2:drawpicturebyline(200+((loop-1)*50),200,'die2.ln1');
                              3:drawpicturebyline(200+((loop-1)*50),200,'die3.ln1');
                              4:drawpicturebyline(200+((loop-1)*50),200,'die4.ln1');
                              5:drawpicturebyline(200+((loop-1)*50),200,'die5.ln1');
                              6:drawpicturebyline(200+((loop-1)*50),200,'die6.ln1');
                         end;{case}
                    end;
               setcolor(cyan);
               x:=10;
               y:=250;
               total:=roll[1] + roll[2];
               if (total=2) or (total=12) then
                    begin
                         gwriteln(x,y,'Sorry, you lose.');
                         player.coins:=player.coins - bet;
                         prompt;
                         exit;
                    end;
               if (total=7) then
                    begin
                         gwriteln(x,y,'Excellent!  You win!');
                         player.coins:=player.coins + bet;
                         prompt;
                         exit;
                    end;
               gwriteln(x,y,'Roll again... (press space)');
               repeat
                    ch:=readarrowkey;
               until (ch=' ');
               for loop:=1 to 2 do
                    begin
                         roll[loop]:=d(6);
                         case roll[loop] of
                              1:drawpicturebyline(200+((loop-1)*50),300,'die1.ln1');
                              2:drawpicturebyline(200+((loop-1)*50),300,'die2.ln1');
                              3:drawpicturebyline(200+((loop-1)*50),300,'die3.ln1');
                              4:drawpicturebyline(200+((loop-1)*50),300,'die4.ln1');
                              5:drawpicturebyline(200+((loop-1)*50),300,'die5.ln1');
                              6:drawpicturebyline(200+((loop-1)*50),300,'die6.ln1');
                         end;{case}
                    end;
               setcolor(cyan);
               x:=10;
               y:=350;
               if (total<>(roll[1]+roll[2])) then
                    begin
                         gwriteln(x,y,'Very unfortunate, you lose.');
                         player.coins:=player.coins - bet;
                    end
               else
                    begin
                         gwriteln(x,y,'Congratulations.  You win!');
                         player.coins:=player.coins + bet;
                    end;
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure esi_magic(var player:playerrecord);

var
     theitem        :    item;
     price          :    integer;

begin
     y:=175;
     setcolor(lightcyan);
     gwriteln(x,y,'The Magic Merchant welcomes you warmly to examine his wares.');
     gwriteln(x,y,'');
     gwriteln(x,y,'     1) Red Potion    ONLY 100 coins!');
     gwriteln(x,y,'     2) Blue Potion   ONLY 120 coins!');
     gwriteln(x,y,'     3) Green Potion  ONLY 300 coins!');
     gwriteln(x,y,'     4) Ring Charge   ONLY 400 coins!');
     gwriteln(x,y,'     N)one');
     gwriteln(x,y,'');
     gwriteln(x,y,'''''What do you like?'''' grins the Magic Merchant.');
     gwriteln(x,y,'');
     repeat
          ans:=readarrowkey;
     until (ans in ['1'..'4','n','N']);
     if (ans in ['n','N']) then
          exit;
     case ans of
          '1':begin
                   theitem:=redpotion;
                   price:=100;
              end;
          '2':begin
                   theitem:=bluepotion;
                   price:=120;
              end;
          '3':begin
                   theitem:=greenpotion;
                   price:=300;
              end;
          '4':begin
                   price:=400;
                   if not(ring in player.stages) then
                        gwriteln(x,y,'But you don''t have a ring!')
                   else
                        begin
                             if (price>player.coins) then
                                  begin
                                       setcolor(brown);
                                       broke;
                                       exit;
                                  end;
                             if (player.charges=ringmax) then
                                  begin
                                       gwriteln(x,y,'Your ring cannot contain more charges.');
                                       prompt;
                                       exit;
                                  end;
                             player.charges:=player.charges+1;
                             player.chargemax:=player.chargemax+1;
                             player.coins:=player.coins-price;
                             gwriteln(x,y,'''''Pleasure doing business with you!''''');
                             prompt;
                        end;
              end;
     end;{case}
     if (ans in ['1'..'3']) then
          begin
               if (player.numitems=itemmax) then
                    begin
                         setcolor(lightgray);
                         outtextxy(10,420,'  Sorry, but you don''t have room in your pack!');
                         prompt;
                         exit;
                    end;
               if (price>player.coins) then
                    begin
                         setcolor(brown);
                         broke;
                         exit;
                    end;
               player.numitems:=player.numitems+1;
               player.item[player.numitems]:=theitem;
               player.coins:=player.coins-price;
               gwriteln(x,y,'');
               gwriteln(x,y,'Sold!');
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure esi_arm(var player:playerrecord);

var
     opponent       :    byte;
     tempstring     :    stringtype;
     bet            :    word;
     errcode        :    integer;
     win            :    boolean;
     done           :    boolean;
     position       :    shortint;

begin
     setcolor(lightgreen);
     writefile(175,'064.txt');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['y','Y']) then
          begin
               clearesi;
               y:=175;
               setcolor(lightgreen);
               gwrite(x,y,'Place your wager (up to 100 coins): ');
               gread(x,y,tempstring);
               val(tempstring,bet,errcode);
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               if (bet<1) then
                    begin
                         gwriteln(x,y,'What''s the point of playing for nothing?');
                         prompt;
                         exit;
                    end;
               if (bet>100) then
                    begin
                         gwriteln(x,y,'''''Too high for my taste.''''');
                         prompt;
                         exit;
                    end;
               if (player.coins<bet) then
                    begin
                         gwriteln(x,y,'You secretly bet money you don''t have.');
                         prompt;
                    end;
               clearesi;
               x:=10;
               y:=175;
               setcolor(lightgreen);
               gwriteln(x,y,'Ready.  Set.  Go!  (press space)');
               done:=false;
               position:=0;
               opponent:=d(6)+12;
               repeat
                    repeat
                         ch:=readarrowkey;
                    until (ch=' ');
                    case position of
                        -1:begin
                                if ((d(20)+player.strength-10)>(d(20)+opponent)) then
                                     position:=0
                                else
                                     position:=-2;
                           end;
                         0:begin
                                if ((d(20)+player.strength)>(d(20)+opponent)) then
                                     position:=1
                                else
                                     position:=-1;
                           end;
                         1:begin
                                if ((d(20)+player.strength+10)>(d(20)+opponent)) then
                                     position:=2
                                else
                                     position:=0;
                           end;
                    end;{case}
                    clearesi;
                    y:=175;
                    case position of
                        -2:begin
                                gwriteln(x,y,'You have lost!');
                                done:=true;
                                win:=false;
                           end;
                        -1:begin
                                gwriteln(x,y,'You are losing...  (press space)');
                           end;
                         0:begin
                                gwriteln(x,y,'You both continue to struggle.  (press space)');
                           end;
                         1:begin
                                gwriteln(x,y,'You are winning...  (press space)');
                           end;
                         2:begin
                                gwriteln(x,y,'You defeat the wimp.');
                                done:=true;
                                win:=true;
                           end;
                    end;{case}
               until (done);
               gwriteln(x,y,'');
               if (win) then
                    begin
                         gwriteln(x,y,'The wimp hands you your money.');
                         player.coins:=player.coins+bet;
                    end
               else
                    begin
                         gwriteln(x,y,'It''s time for you to pay up.');
                         gwriteln(x,y,'');
                         if (bet>player.coins) then
                              begin
                                   gwriteln(x,y,'''''We don''t like people who bet with no money!''''');
                                   gwriteln(x,y,'They attack.');
                                   prompt;
                                   nummonsters:=d(4)+2;
                                   rollmonsters(monster,nummonsters,'brawler.dat');
                                   combat(player,nummonsters,monster);
                                   cleardevice;
                                   drawpicturebyline(70,10,'esi.ln1');
                                   settextstyle(small,horizontal,6);
                                   x:=10;
                                   y:=175;
                                   setcolor(lightgreen);
                                   gwriteln(x,y,'After the fight you go back to the bar.');
                              end
                         else
                              begin
                                   gwriteln(x,y,'''''Thanks,'''' he laughs.  ''''Come back any time.''''');
                                   player.coins:=player.coins-bet;
                              end;
                    end;
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure esi_knife(var player:playerrecord);

var
     opponent       :    byte;
     tempstring     :    stringtype;
     bet            :    word;
     errcode        :    integer;
     win            :    boolean;
     score          :    array[1..2] of byte;
     loop           :    integer;

begin
     setcolor(lightgray);
     writefile(175,'065.txt');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['y','Y']) then
          begin
               clearesi;
               y:=175;
               setcolor(lightgray);
               gwrite(x,y,'Place your wager (up to 100 coins): ');
               gread(x,y,tempstring);
               val(tempstring,bet,errcode);
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               if (bet<1) then
                    begin
                         gwriteln(x,y,'What''s the point of playing for nothing?');
                         prompt;
                         exit;
                    end;
               if (bet>100) then
                    begin
                         gwriteln(x,y,'''''Ahem.  I don''t carry that much money.''''');
                         prompt;
                         exit;
                    end;
               if (player.coins<bet) then
                    begin
                         gwriteln(x,y,'You secretly bet money you don''t have.');
                         prompt;
                    end;
               clearesi;
               x:=10;
               y:=175;
               setcolor(lightgray);
               score[1]:=0;
               score[2]:=0;
               opponent:=d(6)+12;
               for loop:=1 to 3 do
                    begin
                         clearesi;
                         x:=10;
                         y:=175;
                         setcolor(lightgray);
                         case loop of
                              1:gwriteln(x,y,'First throw.');
                              2:gwriteln(x,y,'Second throw.');
                              3:gwriteln(x,y,'Third throw.');
                         end;
                         gwriteln(x,y,'');
                         gwrite(x,y,'He throws...  ');
                         setcolor(lightred);
                         case (d(20)+opponent) of
                            38..40:begin
                                        gwriteln(x,y,'BULLSEYE! (20 pts)');
                                        score[1]:=score[1] + 20;
                                   end;
                            30..37:begin
                                        gwriteln(x,y,'good shot. (10 pts)');
                                        score[1]:=score[1] + 10;
                                   end;
                            20..29:begin
                                        gwriteln(x,y,'decent shot. (5 pts)');
                                        score[1]:=score[1] + 5;
                                   end;
                            10..19:begin
                                        gwriteln(x,y,'barely hit the board. (3 pts)');
                                        score[1]:=score[1] + 3;
                                   end;
                            else
                                   begin
                                        gwriteln(x,y,'missed the board completely. (0 pts)');
                                        score[1]:=score[1] + 0;
                                   end;
                         end;{case}
                         setcolor(lightgray);
                         gwriteln(x,y,'');
                         gwrite(x,y,'You throw... (press space)  ');
                         repeat
                              ch:=readarrowkey;
                         until (ch=' ');
                         setcolor(lightred);
                         case (d(20)+player.dexterity) of
                            38..40:begin
                                        gwriteln(x,y,'BULLSEYE! (20 pts)');
                                        score[2]:=score[2] + 20;
                                   end;
                            30..37:begin
                                        gwriteln(x,y,'they are impressed. (10 pts)');
                                        score[2]:=score[2] + 10;
                                   end;
                            20..29:begin
                                        gwriteln(x,y,'you''re not too quick... (5 pts)');
                                        score[2]:=score[2] + 5;
                                   end;
                            10..19:begin
                                        gwriteln(x,y,'barely hit the board. (3 pts)');
                                        score[2]:=score[2] + 3;
                                   end;
                            else
                                   begin
                                        gwriteln(x,y,'they all laugh at you. (0 pts)');
                                        score[2]:=score[2] + 0;
                                   end;
                         end;{case}
                         setcolor(lightgray);
                         prompt;
                    end;
               clearesi;
               x:=10;
               y:=175;
               setcolor(lightgray);
               win:=(score[1]<score[2]);
               gwriteln(x,y,'');
               if (win) then
                    begin
                         gwriteln(x,y,'He shamefully hands you the money.');
                         player.coins:=player.coins+bet;
                    end
               else
                    begin
                         gwriteln(x,y,'The winner looks at you expectantly.');
                         gwriteln(x,y,'');
                         if (bet>player.coins) then
                              begin
                                   gwriteln(x,y,'''''Don''t have the money?!''''');
                                   gwriteln(x,y,'They attack.');
                                   prompt;
                                   nummonsters:=d(6)+2;
                                   rollmonsters(monster,nummonsters,'bandit.dat');
                                   combat(player,nummonsters,monster);
                                   cleardevice;
                                   drawpicturebyline(70,10,'esi.ln1');
                                   settextstyle(small,horizontal,6);
                                   x:=10;
                                   y:=175;
                                   setcolor(lightgray);
                                   gwriteln(x,y,'After the fight you go back to the bar.');
                              end
                         else
                              begin
                                   gwriteln(x,y,'''''Pleasure doing business with you.''''');
                                   player.coins:=player.coins-bet;
                              end;
                    end;
               prompt;
          end;

end;
{---------------------------------------------------------------------------}
procedure esi_wheel(var player:playerrecord);

const
     delayvalue     =    1000;

var
     password       :    stringtype;
     done           :    boolean;

begin
     x:=10;
     y:=175;
     setcolor(red);
     gwriteln(x,y,'You walk over to one of Roland''s Roving Jesters who is clad in');
     gwriteln(x,y,'red and yellow.  He guardes a barred door.');
     gwriteln(x,y,'');
     gwriteln(x,y,'''''What do you want?'''' he asks.');
     gwriteln(x,y,'');
     gwrite(x,y,'You say:  ');
     gread(x,y,password);
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     if not(capitalize(password)='CRYSTAL SHARD') then
          begin
               setcolor(yellow);
               gwriteln(x,y,'''''Bobo warned me about you.  I can''t let you in.''''');
               prompt;
          end
     else
          begin
               setcolor(yellow);
               gwriteln(x,y,'He opens the door for you...');
               prompt;
               done:=false;
               repeat
                    clearesi;
                    x:=10;
                    y:=175;
                    setcolor(red);
                    settextstyle(small,horizontal,6);
                    gwriteln(x,y,'Welcome to Roland McDoland''s');
                    gwriteln(x,y,'    Wheel of Fortune!');
                    gwriteln(x,y,'');
                    gwriteln(x,y,'');
                    gwriteln(x,y,'For ONLY 500 coins you can spin');
                    gwriteln(x,y,'the wheel of fortune!');
                    gwriteln(x,y,'');
                    gwriteln(x,y,'Do you want to spin?  (y/n)');
                    drawpicturebyline(350,175,'wheel.ln1');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['y','Y','n','N']);
                    done:=(ans in ['n','N']);
                    if (ans in ['y','Y']) then
                         begin
                              if (player.coins<500) then
                                   begin
                                        setcolor(yellow);
                                        broke;
                                        exit;
                                   end;
                              player.coins:=player.coins - 500;
                              setcolor(yellow);
                              gwriteln(x,y,'');
                              gwriteln(x,y,'');
                              gwriteln(x,y,'You spin the wheel...');
                              prompt;
                              clearesi;
                              x:=15;
                              y:=300;
                              setcolor(red);
                              gwriteln(x,y,'                 press space to stop the wheel');
                              x:=165;
                              y:=180;
                              repeat
                                   repeat
                                        drawpicturebyline(x,y,'wheel1.ln1');
                                        delay(delayvalue);
                                        drawpicturebyline(x,y,'wheel2.ln1');
                                        delay(delayvalue);
                                        drawpicturebyline(x,y,'wheel3.ln1');
                                        delay(delayvalue);
                                        drawpicturebyline(x,y,'wheel4.ln1');
                                        delay(delayvalue);
                                   until KEYPRESSED;
                                   ch:=readkey;
                              until (ch=' ');
                              y:=350;
                              settextstyle(default,horizontal,1);
                              setcolor(white);
                              case (d(8)+d(8)+d(8)+d(8)) of
                                 4:begin
                                        writefile(350,'066.txt');
                                        drawpicturebyline(165,180,'wheel1.ln1');
                                        drawpicturebyline(300,220,'wheart.ln1');
                                        player.endurancemax:=player.endurancemax+100;
                                        player.endurance:=player.endurance+100;
                                   end;
                                32:begin
                                        writefile(350,'067.txt');
                                        drawpicturebyline(165,180,'wheel3.ln1');
                                        drawpicturebyline(300,220,'bskull.ln1');
                                        prompt;
                                        died;
                                   end;
                              else
                                   case d(8) of
                                      1:begin
                                             writefile(350,'068.txt');
                                             drawpicturebyline(165,180,'wheel3.ln1');
                                             drawpicturebyline(300,220,'moon.ln1');
                                             if (player.coins>1000) then
                                                  player.coins:=player.coins - 1000
                                             else
                                                  player.coins:=0;
                                             if (player.experience>1000) then
                                                  player.experience:=player.experience - 1000
                                             else
                                                  player.experience:=0;
                                        end;
                                      2:begin
                                             writefile(350,'069.txt');
                                             drawpicturebyline(165,180,'wheel1.ln1');
                                             drawpicturebyline(300,220,'candle.ln1');
                                             if (player.strength<20) then
                                                  player.strength:=player.strength + 1;
                                        end;
                                      3:begin
                                             writefile(350,'070.txt');
                                             drawpicturebyline(165,180,'wheel3.ln1');
                                             drawpicturebyline(300,220,'lit.ln1');
                                             if (player.dexterity>1) then
                                                  player.dexterity:=player.dexterity - 1;
                                        end;
                                      4:begin
                                             writefile(350,'071.txt');
                                             drawpicturebyline(165,180,'wheel1.ln1');
                                             drawpicturebyline(300,220,'heart.ln1');
                                             player.endurancemax:=player.endurancemax+1;
                                             player.endurance:=player.endurance+1;
                                        end;
                                      5:begin
                                             writefile(350,'072.txt');
                                             drawpicturebyline(165,180,'wheel3.ln1');
                                             drawpicturebyline(300,220,'skull.ln1');
                                             if (player.endurancemax>1) then
                                                  player.endurancemax:=player.endurancemax - 1;
                                             if (player.endurance>1) then
                                                  player.endurance:=player.endurance - 1;
                                        end;
                                      6:begin
                                             writefile(350,'073.txt');
                                             drawpicturebyline(165,180,'wheel1.ln1');
                                             drawpicturebyline(300,220,'water.ln1');
                                             if (player.dexterity<20) then
                                                  player.dexterity:=player.dexterity + 1;
                                        end;
                                      7:begin
                                             writefile(350,'074.txt');
                                             drawpicturebyline(165,180,'wheel3.ln1');
                                             drawpicturebyline(300,220,'eye.ln1');
                                             if (player.strength>1) then
                                                  player.strength:=player.strength - 1;
                                        end;
                                      8:begin
                                             writefile(350,'075.txt');
                                             drawpicturebyline(165,180,'wheel1.ln1');
                                             drawpicturebyline(300,220,'sun.ln1');
                                             player.coins:=player.coins + 1000;
                                             player.experience:=player.experience + 1000;
                                        end;
                                   end;{case}
                              end;{case}
                              prompt;
                         end;
               until (done);
          end;
end;
{---------------------------------------------------------------------------}
procedure elfskullinn(var player:playerrecord);

var
     password    :    stringtype;
     tempstring  :    stringtype;

begin
     cleardevice;
     drawpicturebyline(70,10,'esi.ln1');
     setcolor(yellow);
     settextstyle(small,horizontal,5);
     writefile(180,'039.txt');
     prompt;
     repeat
          clearesi;
          homecursor(x,y);
          y:=240;
          setcolor(yellow);
          settextstyle(small,horizontal,6);
          gwriteln(x,y,'     1) Look around');
          gwriteln(x,y,'     2) Order a drink');
          gwriteln(x,y,'     3) Rent a room');
          gwriteln(x,y,'     4) Try your luck at dice');
          y:=240;
          x:=320;
          gwriteln(x,y,'     5) Visit the Magic Merchant');
          x:=320;
          gwriteln(x,y,'     6) Arm wrestling table');
          x:=320;
          gwriteln(x,y,'     7) Knife throwing board');
          x:=320;
          gwriteln(x,y,'     8) Go over to the jester');
          gwriteln(x,y,'');
          gwriteln(x,y,'                       (V)iew your stats');
          gwriteln(x,y,'                    (E)xit the Elf Skull Inn');
          str(player.coins,tempstring);
          settextstyle(default,horizontal,1);
          setcolor(white);
          outtextxy(240,460,('You have ' + tempstring + ' coins'));
          repeat
               ans:=readarrowkey;
          until (ans in ['1'..'8','e','E','v','V']);
          clearesi;
          setcolor(yellow);
          settextstyle(small,horizontal,6);
          homecursor(x,y);
          case ans of
            'e','E':exit;
            'v','V':begin
                         viewstats(player);
                         cleardevice;
                         drawpicturebyline(70,10,'esi.ln1');
                    end;
                '1':begin
                         setcolor(yellow);
                         settextstyle(small,horizontal,5);
                         writefile(180,'039.txt');
                         prompt;
                    end;
                '2':begin
                         esi_drink(player);
                    end;
                '3':begin
                         esi_room(player);
                    end;
                '4':begin
                         esi_dice(player);
                    end;
                '5':begin
                         esi_magic(player);
                    end;
                '6':begin
                         esi_arm(player);
                    end;
                '7':begin
                         esi_knife(player);
                    end;
                '8':begin
                         esi_wheel(player);
                    end;
          end;{case}

     until FALSE;
end;
