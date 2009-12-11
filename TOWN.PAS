{Town Procedures and functions}
{---------------------------------------------------------------------------}
procedure savegame(player:playerrecord);

var
     dosname        :    stringtype;
     pasfile        :    file of playerrecord;
     goahead        :    boolean;

begin
     goahead:=false;
     cleardevice;
     homecursor(x,y);
     setcolor(lightgray);
     settextstyle(sanseri,horizontal,3);
     gwriteln(x,y,'[default: '+cfg.savegame+']');
     gwriteln(x,y,'');
     settextstyle(sanseri,horizontal,4);
     gwrite(x,y,'Enter Save File Name: ');
     setcolor(lightblue);
     gread(x,y,dosname);
     if (dosname='') then
          dosname:=cfg.savegame;
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     setcolor(lightgray);
     if exist(dosname) then
          begin
               gwriteln(x,y,'File exists.');
               gwriteln(x,y,'Overwrite? (y/n)');
               repeat
                    ans:=readarrowkey;
               until (ans in ['n','N','y','Y']);
               if (ans in ['y','Y']) then
                    goahead:=true;
          end
     else
          goahead:=true;
     if goahead then
          begin
               assign(pasfile,dosname);
               rewrite(pasfile);
               write(pasfile,player);
               close(pasfile);
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               gwriteln(x,y,'Saved.');
               settextstyle(default,horizontal,2);
               prompt;
          end;
end;
{--------------------------------------------------------------------------}
procedure broke;

begin
     settextstyle(sanseri,horizontal,5);
     outtextxy(1,200,'  You do not have the funds!!');
     settextstyle(default,horizontal,2);
     prompt;
end;
{---------------------------------------------------------------------------}
procedure buyequipment(var player:playerrecord);

var
     theitem        :    item;
     price          :    integer;

begin
     setcolor(black);
     settextstyle(triplex,horizontal,3);
     outtextxy(10,420,'               (B)uy, (S)ell, or (E)xit');
     setcolor(white);
     with player do
          if (numitems=itemmax) then
               begin
                    setcolor(lightgray);
                    outtextxy(10,420,'  Sorry, but you don''t have room in your pack!');
                    settextstyle(default,horizontal,2);
                    prompt;
               end
          else
               begin
                    settextstyle(default,horizontal,1);
                    outtextxy(120,160,'(1) SWORD');
                    outtextxy(120,170,'   10 coins');
                    outtextxy(120,260,'(2) SHIELD');
                    outtextxy(120,270,'   10 coins');
                    outtextxy(120,360,'(3) AXE');
                    outtextxy(120,370,'    7 coins');
                    outtextxy(270,160,'(4) CHAIN MAIL');
                    outtextxy(270,170,'   40 coins');
                    outtextxy(270,260,'(5) PLATE MAIL');
                    outtextxy(270,270,'   60 coins');
                    outtextxy(270,360,'(6) DAGGER');
                    outtextxy(270,370,'    3 coins');
                    outtextxy(420,160,'(7) CLUB');
                    outtextxy(420,170,'    3 coins');
                    outtextxy(420,260,'(8) STAFF');
                    outtextxy(420,270,'    5 coins');
                    outtextxy(420,360,'(9) HAMMER OF WAR');
                    outtextxy(420,370,'    5 coins');
                    settextstyle(sanseri,horizontal,2);
                    setcolor(lightgray);
                    x:=10;
                    y:=420;
                    gwrite(x,y,'Which item:  ');
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['1'..'9']);
                    case ans of
                         '1':begin
                                  theitem:=sword;
                                  price:=10;
                             end;
                         '2':begin
                                  theitem:=shield;
                                  price:=10;
                             end;
                         '3':begin
                                  theitem:=axe;
                                  price:=7;
                             end;
                         '4':begin
                                  theitem:=chainmail;
                                  price:=40;
                             end;
                         '5':begin
                                  theitem:=platemail;
                                  price:=60;
                             end;
                         '6':begin
                                  theitem:=dagger;
                                  price:=3;
                             end;
                         '7':begin
                                  theitem:=club;
                                  price:=3;
                             end;
                         '8':begin
                                  theitem:=staff;
                                  price:=5;
                             end;
                         '9':begin
                                  theitem:=hammer;
                                  price:=5;
                             end;
                    end;{case}
                    gwrite(x,y,itemstring(theitem));
                    gwrite(x,y,' -- ARE YOU SURE (y/n)');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['y','Y','n','N']);
                    if (ans in ['y','Y']) and (coins<price) then
                         begin
                              setcolor(red);
                              broke;
                         end;
                    if (ans in ['y','Y']) and not(coins<price) then
                         begin
                              numitems:=numitems + 1;
                              item[numitems]:=theitem;
                              coins:=coins - price;
                         end;
               end;
end;
{---------------------------------------------------------------------------}
procedure sellequipment(var player:playerrecord);

var
     price          :    integer;
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
                    gwriteln(x,y,'Sell which one?');
                    str(numitems,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    gwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    tempstring:=itemstring(item[tempinteger]);
                    case item[tempinteger] of
                         sword          :price:=5;
                         shield         :price:=5;
                         axe            :price:=4;
                         bluepotion     :price:=50;
                         redpotion      :price:=50;
                         greenpotion    :price:=150;
                         chainmail      :price:=20;
                         platemail      :price:=30;
                         dagger         :price:=2;
                         club           :price:=1;
                         staff          :price:=2;
                         hammer         :price:=3;
                         magicsword     :price:=1500;
                         magicshield    :price:=1500;
                         flamewand      :price:=2500;
                    end;{case}
                    gwrite(x,y,'Sell '+ tempstring);
                    str(price,tempstring);
                    gwriteln(x,y,' for ' + tempstring + ' coins? (y/n)');
                    drawitem(280,(numitems+7)*textheight('M'),item[tempinteger]);
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['y','Y','n','N']);
                    if (ans in ['y','Y']) then
                         begin
                              for count:=tempinteger to (numitems-1) do
                                   item[count]:=item[count + 1];
                              numitems:=numitems - 1;
                              coins:=coins + price;
                         end;
               end;
end;
{---------------------------------------------------------------------------}
procedure weaponshop(var player:playerrecord);

var
     tempstring     :    stringtype;

begin
     repeat
          cleardevice;
          settextstyle(gothic,horizontal,5);
          homecursor(x,y);
          setcolor(darkgray);
          outtextxy(x+3,y+3,'    Ye Olde Equipment Shop');
          setcolor(lightgray);
          outtextxy(x,y,'    Ye Olde Equipment Shop');
          gwriteln(x,y,'');
          settextstyle(triplex,horizontal,3);
          y:=420;
          gwriteln(x,y,'               (B)uy, (S)ell, or (E)xit');
          str(player.coins,tempstring);
          settextstyle(default,horizontal,1);
          setcolor(white);
          outtextxy(240,400,('You have ' + tempstring + ' coins'));
          drawitem(150,100,sword);
          drawitem(150,200,shield);
          drawitem(150,300,axe);
          drawitem(300,100,chainmail);
          drawitem(300,200,platemail);
          drawitem(300,300,dagger);
          drawitem(450,100,club);
          drawitem(450,200,staff);
          drawitem(450,300,hammer);
          repeat
               ans:=readarrowkey;
          until (ans in ['e','E','b','B','s','S']);
          case ans of
               'e','E':exit;
               'b','B':buyequipment(player);
               's','S':sellequipment(player);
          end;
     until FALSE;
end;
{---------------------------------------------------------------------------}
procedure useitem(var player:playerrecord);

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
          if (numitems=0) then
               begin
                    cleardevice;
                    settextstyle(sanseri,horizontal,5);
                    outtextxy(150,150,'You have no items');
                    settextstyle(default,horizontal,2);
                    prompt;
               end;
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
                    gwriteln(x,y,'Use which one?');
                    str(numitems,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    gwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    if not(item[tempinteger] in [bluepotion,redpotion,greenpotion]) then
                         begin
                              gwriteln(x,y,'Cannot be used here!');
                         end
                    else
                         begin
                              tempstring:=itemstring(item[tempinteger]);
                              gwrite(x,y,tempstring);
                              gwriteln(x,y,' will be used up.  Use? (y/n)');
                              drawitem(280,(numitems+7)*textheight('M'),item[tempinteger]);
                              repeat
                                   ans:=readarrowkey;
                              until(ans in ['y','Y','n','N']);
                              if (ans in ['y','Y']) then
                                   begin
                                        setcolor(green);
                                        cleardevice;
                                        settextstyle(sanseri,horizontal,2);
                                        case item[tempinteger] of
                                             bluepotion     :writefile(1,'004.txt');
                                             redpotion      :begin
                                                                  writefile(1,'005.txt');
                                                                  endurance:=endurance + d(6)+1;
                                                                  if (endurance>endurancemax) then
                                                                       endurance:=endurancemax;
                                                             end;
                                             greenpotion    :begin
                                                                  writefile(1,'006.txt');
                                                                  endurance:=endurancemax;
                                                             end;
                                        end;{case}
                                        for count:=tempinteger to numitems do
                                             if (count<>numitems) then
                                                  item[count]:=item[count + 1];
                                        numitems:=numitems - 1;
                                   end;
                         end;
                    settextstyle(default,horizontal,2);
                    prompt;
               end;
end;
{---------------------------------------------------------------------------}
procedure magicbuyequipment(var player:playerrecord);

var
     theitem        :    item;
     price          :    integer;
     getring        :    boolean;

begin
     setcolor(black);
     settextstyle(triplex,horizontal,3);
     outtextxy(10,420,'            (B)uy, (S)ell, (L)earn or (E)xit');
     setcolor(white);
     with player do
          if (numitems=itemmax) then
               begin
                    setcolor(lightgray);
                    outtextxy(10,420,'  Sorry, but you don''t have room in your pack!');
                    settextstyle(default,horizontal,2);
                    prompt;
               end
          else
               begin
                    settextstyle(default,horizontal,1);
                    outtextxy(110,160,'(1) BLUE POTION');
                    outtextxy(110,170,'    100 coins');
                    outtextxy(110,260,'(2) RED POTION');
                    outtextxy(110,270,'    100 coins');
                    outtextxy(110,360,'(3) GREEN POTION');
                    outtextxy(110,370,'    300 coins');
                    outtextxy(340,340,'(4) RING OF POWER');
                    outtextxy(340,350,'     800 coins');
                    settextstyle(sanseri,horizontal,2);
                    setcolor(red);
                    x:=10;
                    y:=420;
                    gwrite(x,y,'Which item:  ');
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['1'..'4']);
                    getring:=false;
                    case ans of
                         '1':begin
                                  theitem:=bluepotion;
                                  price:=100;
                             end;
                         '2':begin
                                  theitem:=redpotion;
                                  price:=100;
                             end;
                         '3':begin
                                  theitem:=greenpotion;
                                  price:=300;
                             end;
                         '4':begin
                                  getring:=true;
                                  price:=800;
                             end;
                    end;{case}
                    if (getring) then
                         gwrite(x,y,'Ring of Power')
                    else
                         gwrite(x,y,itemstring(theitem));
                    gwrite(x,y,' -- ARE YOU SURE (y/n)');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['y','Y','n','N']);
                    if (ans in ['y','Y']) and (coins<price) then
                         begin
                              setcolor(red);
                              broke;
                         end;
                    if (ans in ['y','Y']) and not(coins<price) then
                         if (getring) then
                              begin
                                   setcolor(lightgray);
                                   if (ring in stages) then
                                        begin
                                             setfillstyle(solidfill,black);
                                             bar(1,420,640,480);
                                             settextstyle(triplex,horizontal,3);
                                             outtextxy(200,420,'You already have one.');
                                             settextstyle(default,horizontal,2);
                                             prompt;
                                        end
                                   else
                                        begin
                                             stages:=stages + [ring];
                                             coins:=coins - price;
                                             if not(numspells=spellmax)then
                                                  begin
                                                       chargemax:=1;
                                                       charges:=1;
                                                       numspells:=1;
                                                       spell[numspells]:=power;
                                                  end;
                                        end;
                              end
                         else
                              begin
                                   numitems:=numitems + 1;
                                   item[numitems]:=theitem;
                                   coins:=coins - price;
                              end;
               end;
end;
{---------------------------------------------------------------------------}
procedure learnspell(var player:playerrecord);

var
     thespell       :    spell;
     price          :    integer;
     present        :    boolean;

begin
     setcolor(black);
     settextstyle(triplex,horizontal,3);
     outtextxy(10,420,'            (B)uy, (S)ell, (L)earn or (E)xit');
     setcolor(white);
     with player do
          if (numspells=spellmax) or not(ring in stages) then
               begin
                    setcolor(lightgray);
                    if (ring in stages) then
                         outtextxy(80,420,'Sorry, you can''t learn any more spells.')
                    else
                         outtextxy(100,420,'You need a ring to store your spells.');
                    settextstyle(default,horizontal,2);
                    prompt;
               end
          else
               begin
                    setfillstyle(solidfill,black);
                    bar(380,280,460,360);
                    settextstyle(default,horizontal,1);
                    outtextxy(360,240,'(1) CALL WILD');
                    outtextxy(360,250,'   100 coins');
                    outtextxy(360,270,'(2) COURAGE');
                    outtextxy(360,280,'   300 coins');
                    outtextxy(360,300,'(3) WEB');
                    outtextxy(360,310,'   400 coins');
                    outtextxy(360,330,'(4) HEAL');
                    outtextxy(360,340,'   500 coins');
                    outtextxy(360,360,'(5) FIRE BLAST');
                    outtextxy(360,370,'   600 coins');
                    settextstyle(sanseri,horizontal,2);
                    setcolor(red);
                    x:=10;
                    y:=420;
                    gwrite(x,y,'Which spell:  ');
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['1'..'5']);
                    case ans of
                         '1':begin
                                  thespell:=callwild;
                                  price:=100;
                             end;
                         '2':begin
                                  thespell:=courage;
                                  price:=300;
                             end;
                         '3':begin
                                  thespell:=web;
                                  price:=400;
                             end;
                         '4':begin
                                  thespell:=heal;
                                  price:=500;
                             end;
                         '5':begin
                                  thespell:=fireblast;
                                  price:=600;
                             end;
                    end;{case}
                    gwrite(x,y,spellstring(thespell));
                    gwrite(x,y,' -- ARE YOU SURE (y/n)');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['y','Y','n','N']);
                    if (ans in ['y','Y']) and (coins<price) then
                         begin
                              setcolor(lightblue);
                              broke;
                         end;
                    if (ans in ['y','Y']) and not(coins<price) then
                         begin
                              present:=false;
                              for loop:=1 to numspells do
                                   if (spell[loop]=thespell) then
                                        present:=true;
                              if (present) then
                                   begin
                                        setcolor(lightgreen);
                                        settextstyle(sanseri,horizontal,5);
                                        outtextxy(1,200,'    You already know that!!');
                                        settextstyle(default,horizontal,2);
                                        prompt;
                                   end
                              else
                                   begin
                                        chargemax:=chargemax + 1;
                                        if(chargemax>ringmax)then
                                             chargemax:=ringmax;
                                        charges:=charges+1;
                                        if(charges>chargemax)then
                                             charges:=chargemax;
                                        numspells:=numspells + 1;
                                        spell[numspells]:=thespell;
                                        coins:=coins - price;
                                   end;
                         end;
               end;
end;
{----------------------------------------------------------------------------}
procedure magicshop(var player:playerrecord);

var
     tempstring     :    stringtype;

begin
     repeat
          cleardevice;
          settextstyle(gothic,horizontal,5);
          homecursor(x,y);
          setcolor(magenta);
          outtextxy(x+3,y+3,'          Magic Shop');
          setcolor(cyan);
          outtextxy(x,y,'          Magic Shop');
          gwriteln(x,y,'');
          settextstyle(triplex,horizontal,3);
          y:=420;
          gwriteln(x,y,'            (B)uy, (S)ell, (L)earn or (E)xit');
          str(player.coins,tempstring);
          settextstyle(default,horizontal,1);
          setcolor(white);
          outtextxy(240,400,('You have ' + tempstring + ' coins'));
          drawpicturebyline(20,280,'wizard.ln1');
          drawitem(150,100,bluepotion);
          drawitem(150,200,redpotion);
          drawitem(150,300,greenpotion);
          drawpicturebyline(320,100,'skilbook.ln1');
          drawpicturebyline(380,280,'ring.ln1');
          repeat
               ans:=readarrowkey;
          until (ans in ['e','E','b','B','s','S','l','L']);
          case ans of
               'e','E':exit;
               'b','B':magicbuyequipment(player);
               's','S':sellequipment(player);
               'l','L':learnspell(player);
          end;
     until FALSE;
end;
{---------------------------------------------------------------------------}
procedure fakebattle(var player:playerrecord);

begin
     cleardevice;
     setcolor(red);
     settextstyle(sanseri,horizontal,4);
     outtextxy(1,200,'You must now battle the Great Demon...');
     prompt;
     cleardevice;
     x:=(getmaxx DIV 2) - 100;
     drawpicturebyline(x,1,'gdemon.ln1');
     x:=(getmaxx DIV 2) - 60;
     drawpicturebyline(x,300,player.picfile);
     setcolor(red);
     settextstyle(sanseri,horizontal,2);
     x:=(getmaxx DIV 2) - (textwidth('(A)ttack or (R)un') DIV 2);
     outtextxy(x,240,'(A)ttack or (R)un');
     repeat
          ch:=readarrowkey;
     until (ch in ['a','A','r','R']);
     setfillstyle(solidfill,black);
     bar(1,240,640,300);
     if (ch in ['r','R']) then
          begin
               x:=(getmaxx DIV 2) - (textwidth('You''re legs won''t move!') DIV 2);
               outtextxy(x,240,'You''re legs won''t move!')
          end
     else
          begin
               x:=(getmaxx DIV 2) - (textwidth('You miss!') DIV 2);
               outtextxy(x,240,'You miss!');
          end;
     ch:=readarrowkey;
     bar(1,240,640,300);
     settextstyle(sanseri,horizontal,2);
     outtextxy(1,240,'The Great Demon decimates you for 9999 points of damage!');
     ch:=readarrowkey;
     bar(1,240,640,300);
     settextstyle(sanseri,horizontal,4);
     outtextxy(100,240,'Everything starts to go black...');
     player.endurance:=1;
end;
{---------------------------------------------------------------------------}
procedure castspell(var player:playerrecord;area:location);

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
          if (numspells=0) then
               begin
                    cleardevice;
                    settextstyle(sanseri,horizontal,5);
                    outtextxy(150,150,'You have no spells');
                    settextstyle(default,horizontal,2);
                    prompt;
               end;
     with player do
          if (numspells>0) then
               begin
                    setcolor(lightblue);
                    gwriteln(x,y,'   SPELLS');
                    setcolor(white);
                    for count:=1 to numspells do
                         begin
                              str(count,tempstring);
                              tempstring:=tempstring + '. ' + spellstring(spell[count]);
                              gwriteln(x,y,tempstring);
                         end;
                    gwriteln(x,y,'Use which one?');
                    str(numspells,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    gwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    tempstring:=spellstring(spell[tempinteger]);
                    gwrite(x,y,'Use ');
                    gwrite(x,y,tempstring);
                    gwriteln(x,y,'? (y/n)');
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['y','Y','n','N']);
                    if(charges<1)then
                         begin
                              setcolor(lightblue);
                              settextstyle(sanseri,horizontal,3);
                              gwriteln(x,y,'');
                              gwriteln(x,y,'  Your ring is out of power for today.');
                              gwriteln(x,y,'  Sleep and try again tomorrow.');
                              ans:='n';
                         end;
                    if (ans in ['y','Y']) then
                         begin
                              setcolor(green);
                              cleardevice;
                              settextstyle(sanseri,horizontal,2);
                              case spell[tempinteger] of
                                   icestorm,fireblast,icicle
                                           :begin
                                                 settextstyle(sanseri,horizontal,4);
                                                 outtextxy(120,180,'That''s a battle-time spell');
                                                 settextstyle(default,horizontal,2);
        {equal out the unused charge}            charges:=charges+1;
                                            end;
                                   web:writefile(1,'027.txt');
                                   callwild:if (area=wilderness) then
                                                 writefile(1,'024.txt')
                                            else
                                                 if (area=dungeon) then
                                                      writefile(1,'025.txt')
                                                 else
                                                      writefile(1,'007.txt');
                                   heal:begin
                                             writefile(1,'008.txt');
                                             endurance:=endurance + d(6) +1;
                                             if (endurance>endurancemax) then
                                                  endurance:=endurancemax;
                                        end;
                                   obliterate:begin
                                                   writefile(1,'026.txt');
        {equal out the unused charge}              charges:=charges+1;
                                              end;
                                   power:case d(20) of
                                       1..3:begin
                                                 writefile(1,'009.txt');
                                                 endurance:=endurance + d(2);
                                                 if (endurance>endurancemax) then
                                                      endurance:=endurancemax;
                                            end;
                                       4..6:begin
                                                 writefile(1,'010.txt');
                                                 endurance:=endurance - d(2);
                                            end;
                                       7..9:if (area=wilderness) then
                                                 writefile(1,'023.txt')
                                            else
                                                 writefile(1,'011.txt');
                                     10..12:writefile(1,'012.txt');
                                     13..15:writefile(1,'028.txt');
                                         16:if (area=town) then
                                                 writefile(1,'032.txt')
                                            else
                                                 fakebattle(player);
                                         17:begin
                                                 writefile(1,'033.txt');
                                                 endurance:=endurancemax;
                                            end;
                                     18..20:writefile(1,'013.txt');
                                     end;{case}
                                  shatter:writefile(1,'014.txt');
                                  dragonbreath:if(area=wilderness)then
                                                    writefile(1,'029.txt')
                                               else
                                                    if (area=dungeon) then
                                                         writefile(1,'030.txt')
                                                    else
                                                         writefile(1,'031.txt');
                                  resistfire:writefile(1,'034.txt');
                                  resistcold:writefile(1,'035.txt');
                                  courage:writefile(1,'036.txt');
                                  glacier:writefile(1,'037.txt');
                                  freeze:writefile(1,'038.txt');
                              end;{case}
                              charges:=charges-1;
                         end;
                    prompt;
                    if(endurance=0)then
                         died;
               end;
end;
{---------------------------------------------------------------------------}
procedure clearpub;

begin
     setfillstyle(solidfill,black);
     bar(1,120,640,480);
end;
{---------------------------------------------------------------------------}
procedure buydrink(var coins:longint);

const
     drinkprice     =    2;

var
     tempstring     :    stringtype;

begin
     y:=135;
     gwriteln(x,y,'               All Drinks -- 2 coins');
     gwriteln(x,y,'');
     gwriteln(x,y,'                     (1) ale');
     gwriteln(x,y,'                     (2) beer');
     gwriteln(x,y,'                     (3) wine');
     gwriteln(x,y,'                     (4) whiskey');
     gwriteln(x,y,'                     (5) special');
     gwriteln(x,y,'                     (N) none');
     gwriteln(x,y,'');
     gwriteln(x,y,'      "Our special drink is the Beholder''s Spit."');
     str(coins,tempstring);
     settextstyle(default,horizontal,1);
     setcolor(white);
     outtextxy(240,400,('You have ' + tempstring + ' coins'));
     setcolor(lightmagenta);
     settextstyle(sanseri,horizontal,3);
     gwriteln(x,y,'');
     gwriteln(x,y,'                 What do you take?');
     repeat
          ans:=readarrowkey;
     until (ans in ['1'..'5','n','N']);
     if (ans in ['n','N']) then
          exit;
     if (coins<drinkprice) then
          begin
               setcolor(lightred);
               broke;
          end
     else
          begin
               clearpub;
               settextstyle(sanseri,horizontal,4);
               setcolor(red);
               case ans of
                  '1','2','3':outtextxy(1,180,'      Hey, that''s not bad.  (Burp)');
                  '4':outtextxy(1,200,'          My, that''s good stuff!');
                  '5':outtextxy(1,220,' Whoa!  It really burns as it goes down!');
               end;{case}
               coins:=coins - drinkprice;
               settextstyle(default,horizontal,2);
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure skulldice(var player:playerrecord);

const
     skullprice     =    100;

var
     blackdice      :    integer;
     whitedice      :    integer;
     skulldice      :    integer;
     thepicture     :    stringtype;
     present        :    boolean;
     tempstring     :    stringtype;

begin
     str(skullprice,tempstring);
     tempstring:='   It will cost '+tempstring+' coins to play a game of Skull Dice';
     outtextxy(1,180,tempstring);
     str(player.coins,tempstring);
     settextstyle(default,horizontal,1);
     setcolor(white);
     outtextxy(240,400,('You have ' + tempstring + ' coins'));
     setcolor(lightmagenta);
     settextstyle(sanseri,horizontal,3);
     outtextxy(1,420,'                  Go ahead? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['n','N']) then
          exit;
     with player do
          if (coins<skullprice) then
               begin
                    setcolor(lightred);
                    broke;
               end
          else
               begin
                    coins:=coins - skullprice;
                    blackdice:=0;
                    whitedice:=0;
                    skulldice:=0;
                    for loop:=1 to 4 do
                         begin
                              case d(6) of
                                   1:begin
                                          blackdice:=blackdice + 1;
                                          thepicture:='blackdie.ln1';
                                     end;
                                   2,3:begin
                                            whitedice:=whitedice + 1;
                                            thepicture:='whitedie.ln1';
                                       end;
                                   4,5,6:begin
                                              skulldice:=skulldice + 1;
                                              thepicture:='skulldie.ln1';
                                         end;
                              end;{case}
                              drawpicturebyline(loop*115,240,thepicture);
                         end;
                    x:=10;
                    y:=300;
                    setcolor(yellow);
                    settextstyle(sanseri,horizontal,3);
                    if (skulldice=4) then
                         begin
                              gwriteln(x,y,'"Ha, ha!  You lose!  And now the game begins,"  with');
                              gwriteln(x,y,'that Roland pulls out his french fry wand.  You quickly');
                              gwriteln(x,y,'dodge his attacks.  Then, Roland just obliterates you.');
                              settextstyle(default,horizontal,2);
                              prompt;
                              died;
                         end
                    else
                         if (skulldice=3) then
                              gwriteln(x,y,'     "Watch out!  Almost had to kill ya there."')
                         else
                              if (blackdice=4) then
                                   begin
                                        gwriteln(x,y,'   "YOU WIN THE GRAND PRIZE!  I will teach you the');
                                        gwriteln(x,y,'   obliterate spell."');
                                        if (numspells=spellmax) then
                                             gwriteln(x,y,'       Too bad you can''t learn anymore spells.')
                                        else
                                             begin
                                                  present:=false;
                                                  for loop:=1 to numspells do
                                                       if (spell[loop]=obliterate) then
                                                            present:=true;
                                                  if (present) then
                                                       gwriteln(x,y,'    But you already know how to obliterate things.')
                                                  else
                                                       if (ring in stages) then
                                                            begin
                                                                 chargemax:=chargemax + 1;
                                                                 if(chargemax>ringmax)then
                                                                      chargemax:=ringmax;
                                                                 charges:=charges+1;
                                                                 if(charges>chargemax)then
                                                                      charges:=chargemax;
                                                                 numspells:=numspells + 1;
                                                                 spell[numspells]:=obliterate;
                                                            end
                                                       else
                                                            gwriteln(x,y,'        Too bad you don''t have a ring, huh?');
                                             end;
                                   end
                              else
                                   if (whitedice=4) then
                                        begin
                                             gwriteln(x,y,'"You are the proud owner of a Ring of Power."');
                                             if (ring in stages) then
                                                  begin
                                                       gwriteln(x,y,'You already have one...');
                                                       gwriteln(x,y,'Roland enchants your ring with an extra charge.');
                                                       chargemax:=chargemax + 1;
                                                       if (chargemax>ringmax) then
                                                            charges:=ringmax;
                                                       charges:=chargemax;
                                                  end
                                             else
                                                  begin
                                                       stages:=stages + [ring];
                                                       if not(numspells=spellmax)then
                                                            begin
                                                                 chargemax:=1;
                                                                 charges:=1;
                                                                 numspells:=1;
                                                                 spell[numspells]:=power;
                                                            end;
                                                  end;
                                        end
                                   else
                                        if (blackdice=3) then
                                             begin
                                                  gwriteln(x,y,'"Great!  Here''s a green potion with your name on it."');
                                                  if (numitems=itemmax) then
                                                       gwriteln(x,y,'You must decline since you cannot carry anymore.')
                                                  else
                                                       begin
                                                            numitems:=numitems + 1;
                                                            item[numitems]:=greenpotion;
                                                       end;
                                             end
                                        else
                                             if (whitedice=3) then
                                                  begin
                                                       gwriteln(x,y,'       "You win.  Your prize is a blue potion."');
                                                       if (numitems=itemmax) then
                                                            gwriteln(x,y,'You must decline since you cannot carry anymore.')
                                                       else
                                                            begin
                                                                 numitems:=numitems + 1;
                                                                 item[numitems]:=bluepotion;
                                                            end;
                                                  end
                                             else
                                                  gwriteln(x,y,'                "Sorry, no prize."');
                    settextstyle(default,horizontal,2);
                    prompt;
               end;
end;
{---------------------------------------------------------------------------}
procedure tip(var coins:longint);

const
     tipprice       =    1;

begin
     if (coins<tipprice) then
          begin
               setcolor(lightred);
               broke;
          end
     else
          begin
               coins:=coins - tipprice;
               outtextxy(1,140,'You toss Roland a coin and he tells you:  ');
               case d(8) of
                    1:writefile(240,'015.txt');
                    2:writefile(240,'016.txt');
                    3:writefile(240,'017.txt');
                    4:writefile(240,'018.txt');
                    5:writefile(240,'019.txt');
                    6:writefile(240,'020.txt');
                    7:writefile(240,'021.txt');
                    8:writefile(240,'022.txt');
               end;
               settextstyle(default,horizontal,2);
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure pub(var player:playerrecord);

var
     password    :    stringtype;
     tempstring  :    stringtype;

begin
     cleardevice;
     drawpicturebyline(2,1,'pub.ln1');
     drawpicturebyline(40,160,'dwarf.ln1');
     settextstyle(sanseri,horizontal,3);
     setcolor(magenta);
     x:=210;
     y:=200;
     gwriteln(x,y,'Bobo the Dwarf is the bouncer here.');
     x:=210;
     gwriteln(x,y,'   "What''s the password?"');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     setcolor(lightmagenta);
     gwrite(x,y,'You respond:  ');
     gread(x,y,password);
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     setcolor(magenta);
     if not(capitalize(password)='CRYSTAL SHARD') then
          begin
               gwriteln(x,y,'"Sorry, no password, no entrance,"  Bobo shoves');
               gwriteln(x,y,'you off.');
               settextstyle(default,horizontal,2);
               prompt;
          end
     else
          begin
               gwriteln(x,y,'"Great!  Come on in!"  You enter the Metallic Beholder');
               gwriteln(x,y,'Pub.');
               settextstyle(default,horizontal,2);
               prompt;
               repeat
                    clearpub;
                    drawpicturebyline(240,140,'roland.ln1');
                    settextstyle(sanseri,horizontal,3);
                    setcolor(lightmagenta);
                    outtextxy(1,280,'      "So, what''ll it be," asks Roland McDoland');
                    settextstyle(triplex,horizontal,3);
                    homecursor(x,y);
                    y:=420;
                    gwriteln(x,y,'            (B)uy, (P)lay, (T)ip or (E)xit');
                    str(player.coins,tempstring);
                    settextstyle(default,horizontal,1);
                    setcolor(white);
                    outtextxy(240,400,('You have ' + tempstring + ' coins'));
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['e','E','b','B','p','P','t','T']);
                    clearpub;
                    settextstyle(sanseri,horizontal,3);
                    setcolor(magenta);
                    homecursor(x,y);
                    case ans of
                         'e','E':exit;
                         'b','B':buydrink(player.coins);
                         'p','P':skulldice(player);
                         't','T':tip(player.coins);
                    end;{case}
               until FALSE;
          end;
end;
{---------------------------------------------------------------------------}
procedure inn(var player:playerrecord);

const
     innprice      =    5;

var
     tempstring     :    stringtype;

begin
     cleardevice;
     settextstyle(gothic,horizontal,5);
     homecursor(x,y);
     setcolor(darkgray);
     outtextxy(x+1,y+1,'     The Eagle Talon Inn');
     setcolor(cyan);
     outtextxy(x,y,'     The Eagle Talon Inn');
     drawpicturebyline(420,120,'innkeep.ln1');
     settextstyle(sanseri,horizontal,3);
     setcolor(lightblue);
     str(innprice,tempstring);
     outtextxy(1,160,'    "We charge '+ tempstring + ' coins a night."');
     str(player.coins,tempstring);
     settextstyle(default,horizontal,1);
     setcolor(white);
     outtextxy(240,400,('You have ' + tempstring + ' coins'));
     setcolor(lightcyan);
     settextstyle(sanseri,horizontal,3);
     outtextxy(1,420,'             Do you stay the night? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['n','N','y','Y']);
     if (ans in ['n','N']) then
          exit
     else
          with player do
               if (coins<innprice) then
                    begin
                         setcolor(yellow);
                         broke;
                    end
               else
                    begin
                         cleardevice;
                         setcolor(yellow);
                         y:=120;
                         gwriteln(x,y,'                     Zzzzzzzz....');
                         gwriteln(x,y,'');
                         setcolor(cyan);
                         coins:=coins - innprice;
                         gwriteln(x,y,'     You sleep the night and gain a little health.');
                         endurance:=endurance + d(4);
                         if(endurance>endurancemax)then
                              endurance:=endurancemax;
                         charges:=chargemax;
                         if (d(100)<=5) then
                              begin
                                   gwriteln(x,y,'');
                                   gwriteln(x,y,'');
                                   setcolor(blue);
                                   settextstyle(triplex,horizontal,2);
                                   gwrite(x,y,'You find a small note under ');
                                   gwriteln(x,y,'your pillow that says, "the');
                                   gwriteln(x,y,'password is... crystal shard"');
                              end;
                         settextstyle(default,horizontal,2);
                         prompt;
                    end;
end;
{---------------------------------------------------------------------------}
procedure townoptions(var leavetown:boolean);

begin
     setcolor(lightblue);
     settextstyle(default,horizontal,3);
     x:=10;
     y:=100;
     gwriteln(x,y,'      Town Options');
     gwriteln(x,y,'');
     settextstyle(default,horizontal,2);
     gwriteln(x,y,'');
     setcolor(lightcyan);
     gwrite(x,y,'            V');
     setcolor(lightblue);
     gwriteln(x,y,'iew Stats');
     gwriteln(x,y,'');
     setcolor(lightcyan);
     gwrite(x,y,'            U');
     setcolor(lightblue);
     gwriteln(x,y,'se Item');
     gwriteln(x,y,'');
     setcolor(lightcyan);
     gwrite(x,y,'            C');
     setcolor(lightblue);
     gwriteln(x,y,'ast Spell');
     gwriteln(x,y,'');
     setcolor(lightcyan);
     gwrite(x,y,'            L');
     setcolor(lightblue);
     gwriteln(x,y,'eave Town');
     gwriteln(x,y,'');
     setcolor(lightcyan);
     gwrite(x,y,'            S');
     setcolor(lightblue);
     gwriteln(x,y,'ave Game');
     gwriteln(x,y,'');
     setcolor(lightcyan);
     gwrite(x,y,'            Q');
     setcolor(lightblue);
     gwriteln(x,y,'uit Game');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     setcolor(lightcyan);

     gwrite(x,y,'  ** ');
     setcolor(lightblue);
     gwrite(x,y,'any other key--Back to Town');
     setcolor(lightcyan);
     gwriteln(x,y,' **');
     ans:=readarrowkey;
     case ans of
      'v','V':viewstats(player);
      'u','U':useitem(player);
      'c','C':castspell(player,town);
      'l','L':begin
                   leavetown:=true;
                   exit;
              end;
      's','S':savegame(player);
      'q','Q':begin
                   closegraph;
                   halt;
              end;
     end;{case}
end;
{---------------------------------------------------------------------------}
procedure thetown(var player:playerrecord);

var
     leavetown      :    boolean;

begin
     repeat
          cleardevice;
          drawpicturebyline(45,45,'thetown.ln1');
          settextstyle(default,horizontal,1);
          setcolor(white);
          x:=10;
          y:=410;
          gwriteln(x,y,'                        choose a place to visit (1-4)');
          gwriteln(x,y,'');
          gwriteln(x,y,'                          press <SPACE> for options');
          repeat
               ans:=readarrowkey;
          until (ans in ['1'..'4',' ']);
          cleardevice;
          case ans of
               '1':weaponshop(player);
               '2':magicshop(player);
               '3':inn(player);
               '4':pub(player);
          end;{case}
          if (ans=' ') then
               begin
                    leavetown:=false;
                    townoptions(leavetown);
                    if LEAVETOWN then
                         exit;
               end;
     until FALSE;
end;
