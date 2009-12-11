{
Ice Queen version 2.1 - Main program
Copyright (C) 2001 Angelo Bertolli

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

Angelo Bertolli
angelo.bertolli@gmail.com

}

program IceQueen;

uses crt, graph, graphio;

const
     version        =    'v2.1';

{--------------------------------------------------------------------------}
function D(dnum:integer):integer; begin d:=random(dnum)+1; end;

{The value of d(dnum) is returned as a random number between 1 and dnum.}

{--------------------------------------------------------------------------}
function DROLL(diceroll:dicerecord):integer;

{Returns the value of dice rolled based on dicerecord format (#d#+#).}

var
     sum  :    integer;
     loop :    integer;

begin
     sum:=0;
     for loop:=1 to diceroll.rollnum do
          sum:=sum + (d(diceroll.dicetype));
     sum:=sum + diceroll.bonus;
     if (sum<0) then
          sum:=0;
     droll:=sum;
end;
{---------------------------------------------------------------------------}
procedure drawmaptile(xpos,ypos:integer;themap:matrix);

var
     xpix           :    integer;
     ypix           :    integer;
     tilenum        :    integer;
     filename       :    stringtype;

begin
     xpix:=41;
     ypix:=41;
     xpix:=xpix + ((xpos - 1) * 20);         {tile size = 20}
     ypix:=ypix + ((ypos - 1) * 20);
     tilenum:=themap[xpos,ypos];
     case tilenum of
          1:filename:='town.ln1';
          2:filename:='cave.ln1';
          3:filename:='grass.ln1';
          4:filename:='hill.ln1';
          5:filename:='mountain.ln1';
          6:filename:='road.ln1';
          7:filename:='swamp.ln1';
          8:filename:='desert.ln1';
          9:filename:='whitemt.ln1';
          10:filename:='castle.ln1';
          11:filename:='snow.ln1';
          12:filename:='inn.ln1';
          13:filename:='ground.ln1';
          14:filename:='dgt.ln1';
          15:filename:='dww.ln1';
          16:filename:='dnw.ln1';
          17:filename:='dew.ln1';
          18:filename:='dsw.ln1';
          19:filename:='dnwc.ln1';
          20:filename:='dnsw.ln1';
          21:filename:='dsec.ln1';
          22:filename:='dnec.ln1';
          23:filename:='dswc.ln1';
          24:filename:='deww.ln1';
          25:filename:='dna.ln1';
          26:filename:='dea.ln1';
          27:filename:='dwa.ln1';
          28:filename:='dsa.ln1';
          29:filename:='blank.ln1';
     else
          filename:='blank.ln1';
     end;
     drawpicturebyline(xpix,ypix,filename);
end;
{---------------------------------------------------------------------------}
procedure drawitem(xpos,ypos:integer;theitem:item);

var
     filename       :    stringtype;

begin
     case theitem of
           sword:filename:='sword.ln1';
          shield:filename:='shield.ln1';
             axe:filename:='axe.ln1';
      bluepotion:filename:='potion1.ln1';
       redpotion:filename:='potion2.ln1';
     greenpotion:filename:='potion3.ln1';
       chainmail:filename:='chain.ln1';
       platemail:filename:='plate.ln1';
          dagger:filename:='dagger.ln1';
            club:filename:='club.ln1';
           staff:filename:='staff.ln1';
          hammer:filename:='hammer.ln1';
      magicsword:filename:='magicswd.ln1';
     magicshield:filename:='magicshl.ln1';
       flamewand:filename:='flamewnd.ln1';
     else
          filename:='blank.ln1';
     end;{case}
     drawpicturebyline(xpos,ypos,filename);
end;

{Title and Main Menu Functions and Procedures}
{--------------------------------------------------------------------------}
procedure titlescreen;

{Ice Queen title screen}

begin
     settextstyle(gothic,horizontal,6);
     setcolor(blue);
     outtextxy(143,383,'The Ice Queen');
     setcolor(white);
     outtextxy(140,380,'The Ice Queen');
     settextstyle(default,horizontal,2);
     drawpicturebyline(120,10,'tcastle.ln1');
     settextstyle(default,horizontal,1);
     setcolor(lightgray);
     prompt;
end;
{---------------------------------------------------------------------------}
procedure introduction;

{Write the introduction to the screen.}

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(sanseri,horizontal,2);
     setcolor(lightblue);
     writefile(y,'001.txt');
     prompt;
end;
{---------------------------------------------------------------------------}
procedure credits;

{Write the credits to the screen.}

begin
     cleardevice;
     settextstyle(sanseri,horizontal,2);
     drawpicturebyline(80,60,'credits.ln1');
     setcolor(white);
     prompt;
{
     cleardevice;
     setcolor(white);
     homecursor(x,y);
     writefile(y,'003.txt');
     prompt;
}
end;
{---------------------------------------------------------------------------}
procedure menuscreen;

{Header for the main menu.}

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(triplex,horizontal,5);
     setcolor(lightgray);
     graphwriteln(x,y,'       The Ice Queen');
     graphwriteln(x,y,'');
     settextstyle(default,horizontal,1);
     setcolor(lightmagenta);
     graphwriteln(x,y,'                                Welcome');
     graphwriteln(x,y,'                       Please make your selection.');
     settextstyle(default,horizontal,3);
     drawpicturebyline(60,225,cfg.leftpic);
     drawpicturebyline(460,240,cfg.rightpic);

end;
{---------------------------------------------------------------------------}
procedure startgame(var player:playerrecord);

{Starts you off by creating a character.}

var
     tempstring     :    stringtype;

begin
     settextstyle(default,horizontal,2);
     repeat
          cleardevice;
          homecursor(x,y);
          setcolor(blue);
          graphwriteln(x,y,'         CREATE YOUR CHARACTER');
          graphwriteln(x,y,'');
          setcolor(white);
          with player do
               begin
                    graphwrite(x,y,'Enter name:  ');

                    graphread(x,y,tempstring);
                    name:=tempstring;
                    if (name='') then
                         begin
                              graphwrite(x,y,'Landon');
                              name:='Landon';
                         end;
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'');
                    graphwrite(x,y,'Sex (M/F)  ');
                    repeat
                         sex:=readarrowkey;
                    until (sex in ['m','M','f','F']);
                    outtextxy(x,y,sex);
                    if (sex in ['m','M']) then
                         drawpicturebyline(x+200,y,'mplayer.ln1')
                    else
                         drawpicturebyline(x+200,y,'fplayer.ln1');
                    setcolor(white);
                    level:=1;
                    experience:=0;
                    endurancemax:=8;
                    strength:=d(6)+d(6)+d(6);
                    dexterity:=d(6)+d(6)+d(6);
                    coins:=(d(6)+d(6)+d(6)) * 10;
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'');
                    str(endurancemax,tempstring);
                    if(endurancemax>=10)then
                         tempstring:='  ' + tempstring
                    else
                         tempstring:='   ' + tempstring;
                    tempstring:='   Endurance:' + tempstring;
                    graphwriteln(x,y,tempstring);
                    endurance:=endurancemax;
                    graphwriteln(x,y,'');
                    str(strength,tempstring);
                    if(strength>=10)then
                         tempstring:='  ' + tempstring
                    else
                         tempstring:='   ' + tempstring;
                    tempstring:='    Strength:' + tempstring;
                    graphwriteln(x,y,tempstring);
                    str(dexterity,tempstring);
                    if(dexterity>=10)then
                         tempstring:='  ' + tempstring
                    else
                         tempstring:='   ' + tempstring;
                    tempstring:='   Dexterity:' + tempstring;
                    graphwriteln(x,y,tempstring);
                    graphwriteln(x,y,'');
                    str(coins,tempstring);
                    tempstring:='       Coins: ' + tempstring;
                    graphwriteln(x,y,tempstring);
                    if (sex in ['m','M']) then
                         picfile:='mplayer.ln1'
                    else
                         picfile:='fplayer.ln1';
                    numitems:=0;
                    numspells:=0;
                    stages:=[];
                    charges:=0;
                    chargemax:=0;
               end;
          graphwriteln(x,y,'');
          graphwriteln(x,y,'');
          graphwriteln(x,y,'');
          graphwriteln(x,y,'          Keep this character (Y/N)');
          repeat
               ans:=readarrowkey;
          until(ans in ['y','Y','n','N']);
     until (ans in ['y','Y']);

end;
{---------------------------------------------------------------------------}
procedure loadgame(var player:playerrecord);

var
     dosname        :    stringtype;
     done           :    boolean;
     pasfile        :    file of playerrecord;

begin
     done:=false;
     repeat
          cleardevice;
          homecursor(x,y);
          setcolor(lightgray);
          settextstyle(sanseri,horizontal,3);
          graphwriteln(x,y,'[default: '+cfg.savegame+']');
          graphwriteln(x,y,'');
          settextstyle(sanseri,horizontal,4);
          graphwrite(x,y,'Enter File Name: ');
          setcolor(lightblue);
          graphread(x,y,dosname);
          if (dosname='') then
               dosname:=cfg.savegame;
          settextstyle(sanseri,horizontal,5);
          graphwriteln(x,y,'');
          graphwriteln(x,y,'');
          setcolor(lightgray);
          if exist(dosname) then
               begin
                    graphwriteln(x,y,'Loading...');
                    assign(pasfile,dosname);
                    reset(pasfile);
                    read(pasfile,player);
                    close(pasfile);
                    done:=true;
               end
          else
               begin
                    setcolor(red);
                    graphwriteln(x,y,'  Sorry, file does not exist.');
                    settextstyle(sanseri,horizontal,3);
                    setcolor(lightgray);
                    x:=10;
                    y:=300;
                    graphwriteln(x,y,'                 (L)oad or (S)tart');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['l','L','s','S']);
                    if (ans in ['s','S']) then
                         begin
                              startgame(player);
                              done:=true;
                         end;
               end;
     until done;
end;
{---------------------------------------------------------------------------}
procedure mainmenu;

begin
     repeat
          menuscreen;
          ans:='C';
          repeat
               settextstyle(small,horizontal,10);
               setcolor(lightblue);
               outtextxy(160,150,'Introduction');
               outtextxy(220,200,'Credits');
               outtextxy(240,250,'Start');
               outtextxy(250,300,'Load');
               outtextxy(250,350,'Quit');
               setcolor(white);
               case ans of
                    'I':outtextxy(160,150,'Introduction');
                    'C':outtextxy(220,200,'Credits');
                    'S':outtextxy(240,250,'Start');
                    'L':outtextxy(250,300,'Load');
                    'Q':outtextxy(250,350,'Quit');
               end;
               ch:=readarrowkey;
               case ch of
                    '8':case ans of
                             'I':ans:='Q';
                             'C':ans:='I';
                             'S':ans:='C';
                             'L':ans:='S';
                             'Q':ans:='L';
                        end;
                    '2':case ans of
                             'I':ans:='C';
                             'C':ans:='S';
                             'S':ans:='L';
                             'L':ans:='Q';
                             'Q':ans:='I';
                        end;
               end;
               if (ch=#13) and (ans in ['I','C']) then
                    begin
                         case ans of
                              'I':introduction;
                              'C':credits;
                         end;
                         menuscreen;
                    end;
               if (ch in ['i','I','C','c'])then
                    begin
                         case ch of
                              'I','i':introduction;
                              'C','c':credits;
                         end;
                         menuscreen;
                    end;
          until ((ch=#13) and (ans in ['S','L','Q'])) or
                (ch in ['s','S','l','L','q','Q']);
          if (ch in ['s','S','l','L','q','Q']) then
               ans:=ch;
          case ans of
               'S','s':begin
                            startgame(player);
                            exit;
                       end;
               'L','l':begin
                            loadgame(player);
                            exit;
                       end;
               'Q','q':begin
                        closegraph;
                        halt;
                   end;
          end;
     until FALSE;
end;

{Functions that return the names of items and spells given the enum type.}
{---------------------------------------------------------------------------}
function itemstring(theitem:item):stringtype;

begin
     case theitem of
          sword          :itemstring:='sword';
          shield         :itemstring:='shield';
          axe            :itemstring:='axe';
          bluepotion     :itemstring:='blue potion';
          redpotion      :itemstring:='red potion';
          greenpotion    :itemstring:='green potion';
          chainmail      :itemstring:='chain mail';
          platemail      :itemstring:='plate mail';
          dagger         :itemstring:='dagger';
          club           :itemstring:='club';
          staff          :itemstring:='staff';
          hammer         :itemstring:='hammer';
          magicsword     :itemstring:='magic sword';
          magicshield    :itemstring:='magic shield';
          flamewand      :itemstring:='flame wand';
     end;{case}
end;
{---------------------------------------------------------------------------}
function spellstring(thespell:spell):stringtype;

begin
     case thespell of
          icestorm       :spellstring:='ice storm';
          fireblast      :spellstring:='fire blast';
          web            :spellstring:='web';
          callwild       :spellstring:='call wild';
          heal           :spellstring:='heal';
          courage        :spellstring:='courage';
          freeze         :spellstring:='freeze';
          obliterate     :spellstring:='obliterate';
          icicle         :spellstring:='icicle';
          power          :spellstring:='power';
          shatter        :spellstring:='shatter';
          glacier        :spellstring:='glacier';
          dragonbreath   :spellstring:='dragon breath';
          resistfire     :spellstring:='resist fire';
          resistcold     :spellstring:='resist cold';
     end;{case}
end;

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
                    graphwriteln(x,y,'   ITEMS');
                    setcolor(white);
                    for count:=1 to numitems do
                         begin
                              str(count,tempstring);
                              tempstring:=tempstring + '. ' + itemstring(item[count]);
                              graphwriteln(x,y,tempstring);
                         end;
                    graphwriteln(x,y,'Drop which one?');
                    str(numitems,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    graphwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    tempstring:=itemstring(item[tempinteger]);
                    graphwrite(x,y,tempstring);
                    graphwriteln(x,y,' will be gone forever.  Drop? (y/n)');
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
procedure graphwritelncol1(var x,y:integer;gstring:stringtype);

begin
     x:=col1;
     graphwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure graphwritelncol2(var x,y:integer;gstring:stringtype);

begin
     x:=col2;
     graphwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure graphwritelncol3(var x,y:integer;gstring:stringtype);

begin
     x:=col3;
     graphwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure viewstats(var player:playerrecord);

var
     tempstring     :    stringtype;
     count          :    integer;
     score          :    integer;
     totalscore     :    integer;
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
                    graphwriteln(x,y,name);
                    graphwriteln(x,y,'');
                    settextstyle(sanseri,horizontal,2);
                    x:=200;
                    str(level,tempstring);
                    tempstring:='level: ' + tempstring;
                    graphwrite(x,y,tempstring);
                    graphwrite(x,y,'     ');
                    if (sex in ['m','M']) then
                         graphwriteln(x,y,'male')
                    else
                         graphwriteln(x,y,'female');
                    y:=140;
                    graphwriteln(x,y,'');
                    setcolor(lightred);
                    str(endurance,tempstring);
                    tempstring:='Endurance: ' + tempstring;
                    graphwrite(x,y,tempstring);
                    str(endurancemax,tempstring);
                    tempstring:='/' + tempstring;
                    graphwriteln(x,y,tempstring);
                    graphwriteln(x,y,'');
                    setcolor(lightgray);
                    str(armorclass,tempstring);
                    tempstring:='Armor Class: ' + tempstring;
                    graphwritelncol1(x,y,tempstring);
                    str(thac0,tempstring);
                    tempstring:='To Hit Roll: ' + tempstring;
                    graphwritelncol1(x,y,tempstring);
                    str(strength,tempstring);
                    tempstring:='Strength: ' + tempstring;
                    graphwritelncol1(x,y,tempstring);
                    str(dexterity,tempstring);
                    tempstring:='Dexterity: ' + tempstring;
                    graphwritelncol1(x,y,tempstring);
                    str(savingthrow,tempstring);
                    tempstring:='Saving Throw: ' + tempstring;
                    graphwritelncol1(x,y,tempstring);
                    x:=col1;
                    graphwrite(x,y,'Damage: ');
                    str(damage.rollnum,tempstring);
                    tempstring:=tempstring + 'd';
                    graphwrite(x,y,tempstring);
                    str(damage.dicetype,tempstring);
                    graphwrite(x,y,tempstring);
                    str(damage.bonus,tempstring);
                    if (damage.bonus>0) then
                         begin
                              tempstring:='+' + tempstring;
                              graphwrite(x,y,tempstring);
                         end;
                    if (damage.bonus<0) then
                         graphwrite(x,y,tempstring);
                    str(experience,tempstring);
                    graphwriteln(x,y,'');
                    tempstring:='Experience: ' + tempstring;
                    graphwritelncol1(x,y,tempstring);

                    score:=0;
                    totalscore:=0;
                    for stageloop:=ring to endgame do
                         begin
                              totalscore:=totalscore+1;
                              if (stageloop in stages) then
                                   score:=score+1;
                         end;
                    score:=(score DIV totalscore)*100;
                    str(score,tempstring);
                    tempstring:='Score: ' + tempstring + '%';
                    graphwritelncol1(x,y,tempstring);

                    graphwriteln(x,y,'');
                    setcolor(yellow);
                    str(coins,tempstring);
                    tempstring:='Coins: ' + tempstring;
                    graphwritelncol1(x,y,tempstring);
                    y:=140;
                    graphwriteln(x,y,'');
                    setcolor(lightblue);
                    for count:=1 to numitems do
                         begin
                              tempstring:=itemstring(item[count]);
                              graphwritelncol2(x,y,tempstring);
                         end;
                    y:=140;
                    graphwriteln(x,y,'');
                    setcolor(lightmagenta);
                    for count:=1 to numspells do
                         begin
                              tempstring:=spellstring(spell[count]);
                              graphwritelncol3(x,y,tempstring);
                         end;
                    if (ring in stages) then
                         begin
                              settextstyle(sanseri,horizontal,1);
                              graphwritelncol3(x,y,'');
                              str(charges,tempstring);
                              tempstring:='Ring Charges: ' + tempstring;
                              str(chargemax,s2);
                              tempstring:=tempstring + '/' + s2;
                              graphwritelncol3(x,y,tempstring);
                         end;
               end;
          setcolor(lightgreen);
          settextstyle(triplex,horizontal,3);
          y:=420;
          x:=320 - (textwidth('(D)rop or (E)xit') DIV 2);
          graphwriteln(x,y,'(D)rop or (E)xit');
          repeat
               ans:=readarrowkey;
          until (ans in ['d','D','e','E']);
          case ans of
               'd','D':dropitem(player);
               'e','E':exit;
          end;{case}
     until FALSE
end;

{---------------------------------------------------------------------------}
procedure died;

{The player dies.  Halts the game.}

begin
     cleardevice;
     setcolor(darkgray);
     settextstyle(gothic,horizontal,6);
     outtextxy(1,80,'      You have died...');
     settextstyle(sanseri,horizontal,8);
     repeat
          setcolor(d(15));
          outtextxy(1,240,'   GAME OVER');
     until keypressed;
     ch:=readarrowkey;
     closegraph;
     halt;
end;

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
     graphwriteln(x,y,'       <press space>');
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
     graphwriteln(x,y,'');
     x:=440;
     str(player.level,tempstring);
     tempstring:='Level: ' + tempstring;
     graphwriteln(x,y,tempstring);
     x:=440;
     str(player.endurance,tempstring);
     tempstring:='HP: ' + tempstring + '/';
     graphwrite(x,y,tempstring);
     str(player.endurancemax,tempstring);
     graphwriteln(x,y,tempstring);
     setcolor(lightgray);
     line(438,366,541,366);
     line(438,366,438,371);
     setcolor(black);
     line(439,367,541,367);
     line(439,370,541,370);
     line(439,367,439,370);
     line(541,367,541,370);
     hitbar:=(player.endurance DIV player.endurancemax)*100;
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
     y:=y+15;
     str(player.armorclass,tempstring);
     tempstring:='AC: ' + tempstring;
     graphwriteln(x,y,tempstring);
     x:=440;
     str(player.thac0,tempstring);
     tempstring:='THAC0: ' + tempstring;
     graphwriteln(x,y,tempstring);
     x:=440;
     graphwrite(x,y,'Dmg: ');
     str(player.damage.rollnum,tempstring);
     tempstring:=tempstring + 'd';
     graphwrite(x,y,tempstring);
     str(player.damage.dicetype,tempstring);
     graphwrite(x,y,tempstring);
     if (player.damage.bonus<>0) then
          begin
               str(player.damage.bonus,tempstring);
               if (player.damage.bonus>0) then
                    tempstring:='+' + tempstring;
               graphwrite(x,y,tempstring);
          end;
     graphwriteln(x,y,'');
     x:=440;
     str(player.savingthrow,tempstring);
     tempstring:='Save: ' + tempstring;
     graphwriteln(x,y,tempstring);

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
                        themonstereffect:effectrecord);

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
     graphwriteln(x,y,'');
     ac:=themonster.armorclass;
     if (themonstereffect.glacier) and (ac>4) then
          ac:=4;
     hitroll:=d(20);
     if ((hitroll>=(player.thac0-ac))and(hitroll>1))or(hitroll=20) then
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'        You hit!');
               graphwriteln(x,y,'');
               dmg:=droll(player.damage);
               if (dmg<1) then
                    dmg:=1;
               flame:=false;
               for loop:=1 to player.numitems do
                    if (player.item[loop]=flamewand) then
                         flame:=true;
               if (flame) and (themonstereffect.resistfire) then
                    dmg:=(dmg DIV 2)+1;
               str(dmg,s);
               s:='('+s+')';
               x:=120-(textwidth(s) DIV 2);
               graphwriteln(x,y,s);
               if (dmg>themonster.endurance) then
                    themonster.endurance:=0
               else
                    themonster.endurance:=themonster.endurance-dmg;
               if (themonster.endurance=0) then
                    begin
                         x:=120-(textwidth('KILLED') DIV 2);
                         graphwriteln(x,y,'KILLED');
                    end;
          end
     else
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'       You missed');
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
                    var playereffect:effectrecord);

begin
     y:=360;
     case player.item[itemnum] of
              sword..axe:begin
                              graphwriteln(x,y,'        Not usable.');
                         end;
    chainmail..flamewand:begin
                              graphwriteln(x,y,'        Not usable.');
                         end;
              bluepotion:begin
                              if not(playereffect.blue) then
                                   begin
                                        graphwriteln(x,y,'     You become faster');
                                        graphwriteln(x,y,'       and stronger.');
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
                                        graphwriteln(x,y,'     It has no effect.');
                                   end;
                         end;
               redpotion:begin
                              graphwriteln(x,y,'    Healing soothes you.');
                              player.endurance:=player.endurance+d(6)+1;
                              if (player.endurance>player.endurancemax) then
                                   player.endurance:=player.endurancemax;
                              remove(player.numitems,player.item,itemnum);
                         end;
             greenpotion:begin
                              graphwriteln(x,y,'      You feel POWER');
                              graphwriteln(x,y,'          surging');
                              graphwriteln(x,y,'     through your body!');
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
                         graphwriteln(x,y,'     You make your foes');
                         graphwriteln(x,y,'       easier to hit.');
                         for loop:=1 to nummonsters do
                              begin
                                   monster[loop].armorclass:=monster[loop].armorclass+2;
                                   if (monster[loop].armorclass>9) then
                                        monster[loop].armorclass:=9;
                              end;
                    end;
   callwild,shatter:begin
                         graphwriteln(x,y,'     Not a battle spell');
                    end;
               heal:begin
                         graphwriteln(x,y,'    Healing soothes you.');
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
                                   graphwriteln(x,y,'     You become braver.');
                                   player.strength:=player.strength+d(4)+1;
                                   if (player.strength>20) then
                                        player.strength:=20;
                                   player.dexterity:=player.dexterity+d(4)+1;
                                   if (player.dexterity>20) then
                                        player.dexterity:=20;
                              end
                         else
                                   graphwriteln(x,y,'     It has no effect.');
                         playereffect.courage:=true;
                    end;
         obliterate:begin
                         y:=320;
                         graphwriteln(x,y,'      Select a target:');
                         graphwriteln(x,y,'');
                         for count:=1 to nummonsters do
                              begin
                                   str(count,tempstring);
                                   ch:=tempstring[1];
                                   tempstring:='     ';
                                   tempstring:=tempstring + ch + ') ';
                                   tempstring:=tempstring + monster[count].name;
                                   graphwriteln(x,y,tempstring);
                              end;
                         repeat
                              ans:=readarrowkey;
                         until (ans in ['1'..ch]);
                         val(ans,tempint,errcode);
                         clearcombatmenu;
                         y:=360;
                         graphwrite(x,y,'     You ');
                         setcolor(magenta);
                         graphwrite(x,y,'OBLITERATE');
                         setcolor(lightcyan);
                         graphwriteln(x,y,' the');
                         x:=120-(textwidth(monster[tempint].name) DIV 2);
                         graphwriteln(x,y,monster[tempint].name);
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
                                        graphwriteln(x,y,'      You don''t think');
                                        graphwriteln(x,y,'     anything happened.');
                                   end;
                                 5:begin
                                        graphwriteln(x,y,'       Roland appears');
                                        graphwriteln(x,y,'      and punches you!');
                                        dmg:=d(4);
                                        if (player.endurance<dmg) then
                                             player.endurance:=0
                                        else
                                             player.endurance:=player.endurance-dmg;
                                   end;
                              6..7:begin
                                        graphwriteln(x,y,'      You levitate for');
                                        graphwriteln(x,y,'          a moment.');
                                   end;
                              8..9:begin
                                        graphwriteln(x,y,'      You hear jesters');
                                        graphwriteln(x,y,'      laughing at you.');
                                   end;
                            10..11:begin
                                        graphwriteln(x,y,'       Thousands of');
                                        graphwriteln(x,y,'     butterflies appear');
                                        graphwriteln(x,y,'      out of thin air.');
                                   end;
                            12..14:begin
                                        graphwriteln(x,y,'    You are kissed by a');
                                        graphwriteln(x,y,'          faerie.');
                                        player.endurance:=player.endurance+d(2);
                                        if (player.endurance>player.endurancemax) then
                                             player.endurance:=player.endurancemax;
                                   end;
                            15..16:begin
                                        graphwriteln(x,y,'    Your left hand turns');
                                        graphwriteln(x,y,'         into a claw.');
                                        player.strength:=player.strength+1;
                                        if (player.strength>20) then
                                             player.strength:=20;
                                   end;
                            17..18:begin
                                        graphwriteln(x,y,'       A voice says,');
                                        graphwriteln(x,y,'     "watch yourself"');
                                        player.dexterity:=player.dexterity+1;
                                        if (player.dexterity>20) then
                                             player.dexterity:=20;
                                   end;
                                19:begin
                                        if (nummonsters=8) then
                                             begin
                                                  graphwriteln(x,y,'        You hear a');
                                                  graphwriteln(x,y,'      rumbling noise');
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
                                                  x:=120-(textwidth(tempstring) DIV 2);
                                                  graphwriteln(x,y,tempstring);
                                                  graphwriteln(x,y,'');
                                                  tempstring:='appears';
                                                  x:=120-(textwidth(tempstring) DIV 2);
                                                  graphwriteln(x,y,tempstring);
                                             end;
                                   end;
                                20:begin
                                        y:=310;
                                        graphwriteln(x,y,'      WHOA! MEGADAMAGE!');
                                        graphwriteln(x,y,'');
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
                                        graphwriteln(x,y,'      You don''t think');
                                        graphwriteln(x,y,'     anything happened.');
                                   end;
                         end;
                     end;
            glacier:begin
                         if not(playereffect.glacier) then
                              begin
                                   graphwriteln(x,y,'     You''re skin takes');
                                   graphwriteln(x,y,'       on a blue hue.');
                                   graphwriteln(x,y,'');
                                   graphwriteln(x,y,'       You feel cold.');
                              end
                         else
                              graphwriteln(x,y,'     It has no effect.');
                         playereffect.glacier:=true;
                    end;
       dragonbreath:begin
                         damagetype:='fire';
                         dmg:=player.endurance;
                    end;
         resistfire:begin
                         if not(playereffect.resistfire) then
                              begin
                                   graphwriteln(x,y,'    You become resistant');
                                   graphwriteln(x,y,'          to fire.');
                              end
                         else
                              graphwriteln(x,y,'     It has no effect.');
                         playereffect.resistfire:=true;
                    end;
         resistcold:begin
                         if not(playereffect.resistcold) then
                              begin
                                   graphwriteln(x,y,'    You become resistant');
                                   graphwriteln(x,y,'          to cold.');
                              end
                         else
                              graphwriteln(x,y,'     It has no effect.');
                         playereffect.resistcold:=true;
                    end;
     end;
     if (dmg<1) then
          dmg:=1;
     if (thespell in [fireblast,icicle]) then
          begin
               y:=320;
               graphwriteln(x,y,'      Select a target:');
               graphwriteln(x,y,'');
               for count:=1 to nummonsters do
                    begin
                         str(count,tempstring);
                         ch:=tempstring[1];
                         tempstring:='     ';
                         tempstring:=tempstring + ch + ') ';
                         tempstring:=tempstring + monster[count].name;
                         graphwriteln(x,y,tempstring);
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
               x:=120-(textwidth(monster[tempint].name) DIV 2);
               graphwriteln(x,y,monster[tempint].name);
               str(dmg,tempstring);
               tempstring:='takes (' + tempstring + ')';
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
               tempstring:=damagetype + ' damage';
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
               if (monster[tempint].endurance<=dmg) then
                    monster[tempint].endurance:=0
               else
                    monster[tempint].endurance:=monster[tempint].endurance-dmg;
               graphwriteln(x,y,'');
               if (monster[tempint].endurance=0) then
                    graphwriteln(x,y,'           KILLED');
          end;
     if (thespell in [dragonbreath,icestorm]) then
          begin
               y:=360;
               graphwriteln(x,y,'     All monsters take');
               graphwriteln(x,y,'          damage...');
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
                              dmg:=dmg DIV 2;
                         if (dmg<1) then
                              dmg:=1;
                         if (nummonsters>1) then
                              begin
                                   str(count,tempstring);
                                   tempstring:=monster[count].name + ' ' + tempstring;
                              end
                         else
                              tempstring:=monster[count].name;
                         x:=120-(textwidth(tempstring) DIV 2);
                         graphwriteln(x,y,tempstring);
                         str(dmg,tempstring);
                         tempstring:='takes (' + tempstring + ')';
                         x:=120-(textwidth(tempstring) DIV 2);
                         graphwriteln(x,y,tempstring);
                         tempstring:=damagetype + ' damage';
                         x:=120-(textwidth(tempstring) DIV 2);
                         graphwriteln(x,y,tempstring);
                         if (monster[count].endurance<=dmg) then
                              monster[count].endurance:=0
                         else
                              monster[count].endurance:=monster[count].endurance-dmg;
                         graphwriteln(x,y,'');
                         if (monster[count].endurance=0) then
                              graphwriteln(x,y,'           KILLED');
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
          graphwriteln(x,y,'');
          graphwriteln(x,y,'     (A)ttack');
          graphwriteln(x,y,'');
          graphwriteln(x,y,'     (U)se an item');
          if (ring in player.stages) then
               begin
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'     (C)ast a spell');
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
          graphwriteln(x,y,'');
          graphwriteln(x,y,'');
          if (action=attack) then
               begin
                    graphwriteln(x,y,'           ATTACK');
                    graphwriteln(x,y,'');
                    for count:=1 to nummonsters do
                         begin
                              str(count,tempstring);
                              ch:=tempstring[1];
                              tempstring:='     ';
                              tempstring:=tempstring + ch + ') ';
                              tempstring:=tempstring + monster[count].name;
                              graphwriteln(x,y,tempstring);
                         end;
                    graphwriteln(x,y,'     N)one');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..ch,'n','N']);
                    done:=not(ans in ['n','N']);
                    val(ans,tempint,errcode);
                    if done then
                         attackmonster(player,monster[tempint],monstereffect[tempint]);
               end;
          if (action=use) then
               begin
                    graphwriteln(x,y,'          USE ITEM');
                    graphwriteln(x,y,'');
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
                              graphwriteln(x,y,tempstring);
                         end;
                    setcolor(lightcyan);
                    graphwriteln(x,y,'      N)one');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..ch,'n','N']);
                    done:=not(ans in ['n','N']);
                    if done then
                         begin
                              clearcombatmenu;
                              y:=300;
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'');
                              val(ans,tempint,errcode);
                              if (player.item[tempint] in
                                  [sword..axe,chainmail..flamewand]) then
                                   done:=false;
                              combatuse(player,tempint,playereffect);
                         end;
               end;
          if (action=cast) then
               begin
                    graphwriteln(x,y,'         CAST SPELL');
                    graphwriteln(x,y,'');
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
                         graphwriteln(x,y,tempstring);
                    end;
                    setcolor(lightcyan);
                    graphwriteln(x,y,'      N)one');
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..ch,'n','N']);
                    done:=not(ans in ['n','N']);
                    if done and (player.charges=0) then
                         begin
                              clearcombatmenu;
                              y:=340;
                              graphwriteln(x,y,'       You''re out of');
                              graphwriteln(x,y,'           magic.');
                              done:=false;
                         end;
                    if done then
                         begin
                              clearcombatmenu;
                              y:=300;
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'');
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
                        var playereffect:effectrecord);

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
     x:=120-(textwidth(tempstring) DIV 2);
     graphwriteln(x,y,tempstring);
     hitroll:=d(20);
     if ((d(20)>=(themonster.thac0-ac))and(hitroll>1))or(hitroll=20) then
          begin
               tempstring:=themonster.attacktype + ' YOU!';
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
               dmg:=droll(themonster.damage);
               if (dmg<1) then
                    dmg:=1;
               str(dmg,tempstring);
               tempstring:='('+tempstring+')';
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
               if (dmg>player.endurance) then
                    player.endurance:=0
               else
                    player.endurance:=player.endurance-dmg;
               if (player.endurance=0) then
                    begin
                         graphwriteln(x,y,'');
                         x:=120-(textwidth('KILLED') DIV 2);
                         graphwriteln(x,y,'KILLED');
                    end;
          end
     else
          begin
               graphwriteln(x,y,'');
               tempstring:='misses';
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
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
     monsterchart   :    chartrecord;
     pasfile        :    file of chartrecord;
     theroll        :    integer;
     val1           :    integer;
     val2           :    integer;
     newmonster     :    monsterlist;
     monsterfile    :    stringtype;
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
     x:=120-(textwidth(tempstring) DIV 2);
     graphwriteln(x,y,tempstring);
     thespell:=themonster.spell[spellnum];
     damagetype:='';
     case thespell of
           icestorm:begin
                         graphwriteln(x,y,'       casts a spell');
                         damagetype:='cold';
                         dmgroll.rollnum:=themonster.hitdice;
                         if (dmgroll.rollnum>20) then
                              dmgroll.rollnum:=20;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=0;
                         dmg:=droll(dmgroll);
                    end;
          fireblast:begin
                         graphwriteln(x,y,'       casts a spell');
                         damagetype:='fire';
                         dmgroll.rollnum:=(((themonster.hitdice-1) DIV 5)*2)+1;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=dmgroll.rollnum;
                         dmg:=droll(dmgroll);
                    end;
             freeze:begin
                         graphwriteln(x,y,'    freezes you, slowing');
                         graphwriteln(x,y,'         you down...');
                         player.dexterity:=player.dexterity-2;
                         if (player.dexterity<1) then
                              player.dexterity:=1;
                    end;
                web:begin
                         graphwriteln(x,y,'      ties you up with');
                         graphwriteln(x,y,'         sticky web');
                         player.dexterity:=player.dexterity-2;
                         if (player.dexterity<1) then
                              player.dexterity:=1;
                    end;
   callwild,shatter:begin
                         graphwriteln(x,y,'       tries to cast');
                         graphwriteln(x,y,'      a spell but fails');
                    end;
               heal:begin
                         graphwriteln(x,y,'          is healed');
                         themonster.endurance:=themonster.endurance+d(6)+1;
                         if (themonster.endurance>themonster.endurancemax) then
                              themonster.endurance:=themonster.endurancemax;
                    end;
            courage:begin
                         if not(themonstereffect.courage) then
                              begin
                                   graphwriteln(x,y,'     becomes faster and');
                                   graphwriteln(x,y,'           stronger');
                                   themonster.armorclass:=themonster.armorclass-1;
                                   themonster.thac0:=themonster.thac0-1;
                                   themonster.damage.bonus:=themonster.damage.bonus+1;
                              end
                         else
                              begin
                                   graphwriteln(x,y,'       tries to cast');
                                   graphwriteln(x,y,'      a spell but fails');
                              end;
                         themonstereffect.courage:=true;
                    end;
         obliterate:begin
                         y:=360;
                         textcolor(magenta);
                         graphwrite(x,y,'      OBLITERATES');
                         textcolor(lightcyan);
                         graphwriteln(x,y,' you');
                         player.endurance:=0;
                     end;
             icicle:begin
                         graphwriteln(x,y,'       casts a spell');
                         damagetype:='cold';
                         dmgroll.rollnum:=(((themonster.hitdice-1) DIV 5)*2)+1;
                         dmgroll.dicetype:=6;
                         dmgroll.bonus:=dmgroll.rollnum;
                         dmg:=droll(dmgroll);
                    end;
              power:begin
                         case d(8) of
                              1..6:begin
                                        graphwriteln(x,y,'       tries to cast');
                                        graphwriteln(x,y,'      a spell but fails');
                                   end;
                                 7:begin
                                        graphwriteln(x,y,'       casts a spell');
                                        if (nummonsters=8) then
                                             begin
                                                  graphwriteln(x,y,'        You hear a');
                                                  graphwriteln(x,y,'      rumbling noise');
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
                                                  x:=120-(textwidth(tempstring) DIV 2);
                                                  graphwriteln(x,y,tempstring);
                                                  graphwriteln(x,y,'');
                                                  tempstring:='appears';
                                                  x:=120-(textwidth(tempstring) DIV 2);
                                                  graphwriteln(x,y,tempstring);
                                             end;
                                   end;
                                 8:begin
                                        graphwriteln(x,y,'       casts a spell');
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
                                   graphwriteln(x,y,'         skin takes');
                                   graphwriteln(x,y,'       on a blue hue.');
                              end
                         else
                              begin
                                   graphwriteln(x,y,'       tries to cast');
                                   graphwriteln(x,y,'      a spell but fails');
                              end;
                         themonstereffect.glacier:=true;
                    end;
       dragonbreath:begin
                         graphwriteln(x,y,'          breathes');
                         damagetype:='fire';
                         dmg:=themonster.endurance;
                    end;
         resistfire:begin
                         if not(themonstereffect.resistfire) then
                              begin
                                   graphwriteln(x,y,'      becomes resistant');
                                   graphwriteln(x,y,'          to fire.');
                              end
                         else
                              begin
                                   graphwriteln(x,y,'       tries to cast');
                                   graphwriteln(x,y,'      a spell but fails');
                              end;
                         themonstereffect.resistfire:=true;
                    end;
         resistcold:begin
                         if not(themonstereffect.resistcold) then
                              begin
                                   graphwriteln(x,y,'       becomes resistant');
                                   graphwriteln(x,y,'          to cold.');
                              end
                         else
                              begin
                                   graphwriteln(x,y,'       tries to cast');
                                   graphwriteln(x,y,'      a spell but fails');
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
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
               tempstring:=damagetype + ' damage';
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
               if (player.endurance<=dmg) then
                    player.endurance:=0
               else
                    player.endurance:=player.endurance-dmg;
               graphwriteln(x,y,'');
               if (player.endurance=0) then
                    graphwriteln(x,y,'           KILLED');
          end;
     if (thespell in [dragonbreath,icestorm]) then
          begin
               if (playereffect.resistfire) and (damagetype='fire') then
                    dmg:=dmg-themonster.hitdice;
               if (playereffect.resistcold) and (damagetype='cold') then
                    dmg:=dmg-themonster.hitdice;
               saveroll:=d(20);
               if ((saveroll>=player.savingthrow)and(saveroll>1))or(saveroll=20) then
                    dmg:=dmg DIV 2;
               if (dmg<1) then
                    dmg:=1;
               str(dmg,tempstring);
               tempstring:='you take (' + tempstring + ')';
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
               tempstring:=damagetype + ' damage';
               x:=120-(textwidth(tempstring) DIV 2);
               graphwriteln(x,y,tempstring);
               if (player.endurance<=dmg) then
                    player.endurance:=0
               else
                    player.endurance:=player.endurance-dmg;
               graphwriteln(x,y,'');
               if (player.endurance=0) then
                    graphwriteln(x,y,'           KILLED');
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
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'          The');
     graphwriteln(x,y,'        Monsters');
     graphwriteln(x,y,'         Attack');
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
                              tempint:=(endurance DIV endurancemax) * 100;
                              if (tempint<=fleehp)and((d(6)+d(6)>morale)) then
                                   action:=flee;
                              with damage do
                                   avgdmg:=((rollnum+bonus)+(rollnum*dicetype+bonus)) DIV 2;
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
                                  x:=120-(textwidth(tempstring) DIV 2);
                                  graphwriteln(x,y,tempstring);
                                  graphwriteln(x,y,'');
                                  tempstring:='runs away';
                                  x:=120-(textwidth(tempstring) DIV 2);
                                  graphwriteln(x,y,tempstring);
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
                                       playereffect);
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
          graphwriteln(x,y,'');
          graphwriteln(x,y,'      (F)ight');
          y:=y+10;
          graphwriteln(x,y,'        or');
          x:=x+5;
          y:=y+10;
          graphwriteln(x,y,'      (R)un');
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
               graphwriteln(x,y,'');
               graphwrite(x,y,'You gain:');
               str(xppool,tempstring);
               tempstring:='  ' + tempstring + ' exp, ';
               graphwrite(x,y,tempstring);
               str(coinpool,tempstring);
               tempstring:=tempstring + ' coin(s)';
               graphwrite(x,y,tempstring);
               prompt;
          end;
     calcstats(player);

end;

{Screen Setup}
{--------------------------------------------------------------------------}
procedure clearmap;

begin
     setfillstyle(solidfill,blue);
     bar(41,41,440,320);
end;
{--------------------------------------------------------------------------}
procedure clearmessage;

begin
     setfillstyle(solidfill,darkgray);
     bar(41,361,600,440);
end;
{--------------------------------------------------------------------------}
procedure clearstats;

begin
     setfillstyle(solidfill,red);
     bar(481,41,600,320);
end;
{--------------------------------------------------------------------------}
procedure screensetup;

begin
     setfillstyle(solidfill,lightgray);
     bar(0,0,640,480);
     setfillstyle(solidfill,black);
     bar(38,38,443,323);
     bar(38,358,603,443);
     bar(478,38,603,323);
     clearmap;
     clearmessage;
     clearstats;
end;
{---------------------------------------------------------------------------}
function midstats(thestring:stringtype) :    integer;

begin
     midstats:=541 - (textwidth(thestring) DIV 2);
end;
{---------------------------------------------------------------------------}
procedure writestats(player:playerrecord);

var
     thestring      :    stringtype;
     tempstring     :    stringtype;

begin
     clearstats;
     setcolor(lightred);
     with player do
          begin
               settextstyle(sanseri,horizontal,2);
               tempstring:=name;
               while (textwidth(tempstring)>120) do
                    delete(tempstring,length(tempstring),1);
               outtextxy(midstats(tempstring),50,tempstring);
               settextstyle(default,horizontal,1);
               outtextxy(midstats('ENDURANCE'),80,'ENDURANCE');
               str(endurance,tempstring);
               thestring:=tempstring;
               str(endurancemax,tempstring);
               thestring:=thestring + '/' + tempstring;
               outtextxy(midstats(thestring),90,thestring);
               y:=110;
               if (numitems>0) then
                    begin
                         x:=midstats('ITEMS');
                         graphwriteln(x,y,'ITEMS');
                         for loop:=1 to numitems do
                              begin
                                   x:=midstats(itemstring(item[loop]));
                                   graphwriteln(x,y,itemstring(item[loop]));
                              end;
                    end
               else
                    begin
                         x:=midstats('No Items');
                         graphwriteln(x,y,'No Items');
                    end;
               graphwriteln(x,y,'');
               if (numspells>0) then
                    begin
                         x:=midstats('SPELLS');
                         graphwriteln(x,y,'SPELLS');
                         for loop:=1 to numspells do
                              begin
                                   x:=midstats(spellstring(spell[loop]));
                                   graphwriteln(x,y,spellstring(spell[loop]));
                              end;
                    end
               else
                    begin
                         x:=midstats('No spells');
                         graphwriteln(x,y,'No spells');
                    end;
          end;

end;
{--------------------------------------------------------------------------}
procedure homemessage(var x,y:integer);

begin
     x:=45;
     y:=365;
end;
{--------------------------------------------------------------------------}
procedure message(var x,y:integer;gtext:string);

{Each line can be 34 characters long (default font, size 2)}

begin
     x:=45;
     if (y>440) or (y<365) then
          homemessage(x,y);
     outtextxy(x,y,(gtext));
     y:=y + textheight('M') + 2;
end;
{---------------------------------------------------------------------------}
procedure surfacemessage;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,' Use arrow keys or keypad to move');
     message(x,y,'');
     message(x,y,'    Press <SPACE> for options');
end;

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
     graphwriteln(x,y,'[default: '+cfg.savegame+']');
     graphwriteln(x,y,'');
     settextstyle(sanseri,horizontal,4);
     graphwrite(x,y,'Enter Save File Name: ');
     setcolor(lightblue);
     graphread(x,y,dosname);
     if (dosname='') then
          dosname:=cfg.savegame;
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     setcolor(lightgray);
     if exist(dosname) then
          begin
               graphwriteln(x,y,'File exists.');
               graphwriteln(x,y,'Overwrite? (y/n)');
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
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'Saved.');
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
                    graphwrite(x,y,'Which item:  ');
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
                    graphwrite(x,y,itemstring(theitem));
                    graphwrite(x,y,' -- ARE YOU SURE (y/n)');
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
                    graphwriteln(x,y,'   ITEMS');
                    setcolor(white);
                    for count:=1 to numitems do
                         begin
                              str(count,tempstring);
                              tempstring:=tempstring + '. ' + itemstring(item[count]);
                              graphwriteln(x,y,tempstring);
                         end;
                    graphwriteln(x,y,'Sell which one?');
                    str(numitems,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    graphwriteln(x,y,'');
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
                    graphwrite(x,y,'Sell '+ tempstring);
                    str(price,tempstring);
                    graphwriteln(x,y,' for ' + tempstring + ' coins? (y/n)');
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
          graphwriteln(x,y,'');
          settextstyle(triplex,horizontal,3);
          y:=420;
          graphwriteln(x,y,'               (B)uy, (S)ell, or (E)xit');
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
                    graphwriteln(x,y,'   ITEMS');
                    setcolor(white);
                    for count:=1 to numitems do
                         begin
                              str(count,tempstring);
                              tempstring:=tempstring + '. ' + itemstring(item[count]);
                              graphwriteln(x,y,tempstring);
                         end;
                    graphwriteln(x,y,'Use which one?');
                    str(numitems,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    graphwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    if not(item[tempinteger] in [bluepotion,redpotion,greenpotion]) then
                         begin
                              graphwriteln(x,y,'Cannot be used here!');
                         end
                    else
                         begin
                              tempstring:=itemstring(item[tempinteger]);
                              graphwrite(x,y,tempstring);
                              graphwriteln(x,y,' will be used up.  Use? (y/n)');
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
                    graphwrite(x,y,'Which item:  ');
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
                         graphwrite(x,y,'Ring of Power')
                    else
                         graphwrite(x,y,itemstring(theitem));
                    graphwrite(x,y,' -- ARE YOU SURE (y/n)');
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
                    graphwrite(x,y,'Which spell:  ');
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
                    graphwrite(x,y,spellstring(thespell));
                    graphwrite(x,y,' -- ARE YOU SURE (y/n)');
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
          graphwriteln(x,y,'');
          settextstyle(triplex,horizontal,3);
          y:=420;
          graphwriteln(x,y,'            (B)uy, (S)ell, (L)earn or (E)xit');
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
                    graphwriteln(x,y,'   SPELLS');
                    setcolor(white);
                    for count:=1 to numspells do
                         begin
                              str(count,tempstring);
                              tempstring:=tempstring + '. ' + spellstring(spell[count]);
                              graphwriteln(x,y,tempstring);
                         end;
                    graphwriteln(x,y,'Use which one?');
                    str(numspells,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    graphwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    tempstring:=spellstring(spell[tempinteger]);
                    graphwrite(x,y,'Use ');
                    graphwrite(x,y,tempstring);
                    graphwriteln(x,y,'? (y/n)');
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['y','Y','n','N']);
                    if(charges<1)then
                         begin
                              setcolor(lightblue);
                              settextstyle(sanseri,horizontal,3);
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'  Your ring is out of power for today.');
                              graphwriteln(x,y,'  Sleep and try again tomorrow.');
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
     graphwriteln(x,y,'               All Drinks -- 2 coins');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'                     (1) ale');
     graphwriteln(x,y,'                     (2) beer');
     graphwriteln(x,y,'                     (3) wine');
     graphwriteln(x,y,'                     (4) whiskey');
     graphwriteln(x,y,'                     (5) special');
     graphwriteln(x,y,'                     (N) none');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'      "Our special drink is the Beholder''s Spit."');
     str(coins,tempstring);
     settextstyle(default,horizontal,1);
     setcolor(white);
     outtextxy(240,400,('You have ' + tempstring + ' coins'));
     setcolor(lightmagenta);
     settextstyle(sanseri,horizontal,3);
     graphwriteln(x,y,'');
     graphwriteln(x,y,'                 What do you take?');
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
                              graphwriteln(x,y,'"Ha, ha!  You lose!  And now the game begins,"  with');
                              graphwriteln(x,y,'that Roland pulls out his french fry wand.  You quickly');
                              graphwriteln(x,y,'dodge his attacks.  Then, Roland just obliterates you.');
                              settextstyle(default,horizontal,2);
                              prompt;
                              died;
                         end
                    else
                         if (skulldice=3) then
                              graphwriteln(x,y,'     "Watch out!  Almost had to kill ya there."')
                         else
                              if (blackdice=4) then
                                   begin
                                        graphwriteln(x,y,'   "YOU WIN THE GRAND PRIZE!  I will teach you the');
                                        graphwriteln(x,y,'   obliterate spell."');
                                        if (numspells=spellmax) then
                                             graphwriteln(x,y,'       Too bad you can''t learn anymore spells.')
                                        else
                                             begin
                                                  present:=false;
                                                  for loop:=1 to numspells do
                                                       if (spell[loop]=obliterate) then
                                                            present:=true;
                                                  if (present) then
                                                       graphwriteln(x,y,'    But you already know how to obliterate things.')
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
                                                            graphwriteln(x,y,'        Too bad you don''t have a ring, huh?');
                                             end;
                                   end
                              else
                                   if (whitedice=4) then
                                        begin
                                             graphwriteln(x,y,'"You are the proud owner of a Ring of Power."');
                                             if (ring in stages) then
                                                  begin
                                                       graphwriteln(x,y,'You already have one...');
                                                       graphwriteln(x,y,'Roland enchants your ring with an extra charge.');
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
                                                  graphwriteln(x,y,'"Great!  Here''s a green potion with your name on it."');
                                                  if (numitems=itemmax) then
                                                       graphwriteln(x,y,'You must decline since you cannot carry anymore.')
                                                  else
                                                       begin
                                                            numitems:=numitems + 1;
                                                            item[numitems]:=greenpotion;
                                                       end;
                                             end
                                        else
                                             if (whitedice=3) then
                                                  begin
                                                       graphwriteln(x,y,'       "You win.  Your prize is a blue potion."');
                                                       if (numitems=itemmax) then
                                                            graphwriteln(x,y,'You must decline since you cannot carry anymore.')
                                                       else
                                                            begin
                                                                 numitems:=numitems + 1;
                                                                 item[numitems]:=bluepotion;
                                                            end;
                                                  end
                                             else
                                                  graphwriteln(x,y,'                "Sorry, no prize."');
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
procedure attack_roland(var player:playerrecord);

begin
     nummonsters:=1;
     rollmonsters(monster,nummonsters,'roland.dat');
     monster[1].endurance:=200;
     monster[1].endurancemax:=200;
     combat(player,nummonsters,monster);
     if (nummonsters=0) then
          begin
               cleardevice;
               setcolor(red);
               settextstyle(triplex,horizontal,3);
               homecursor(x,y);
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'You have defeated Roland McDoland!');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'However, all the people rush to his aid, and');
               graphwriteln(x,y,'he is taken to be healed...');
               prompt;
               cleardevice;
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
     graphwriteln(x,y,'Bobo the Dwarf is the bouncer here.');
     x:=210;
     graphwriteln(x,y,'   "What''s the password?"');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     setcolor(lightmagenta);
     graphwrite(x,y,'You respond:  ');
     graphread(x,y,password);
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     setcolor(magenta);
     if not(capitalize(password)='CRYSTAL SHARD') then
          begin
               graphwriteln(x,y,'"Sorry, no password, no entrance,"  Bobo shoves');
               graphwriteln(x,y,'you off.');
               settextstyle(default,horizontal,2);
               prompt;
          end
     else
          begin
               graphwriteln(x,y,'"Great!  Come on in!"  You enter the Metallic Beholder');
               graphwriteln(x,y,'Pub.');
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
                    graphwriteln(x,y,'            (B)uy, (P)lay, (T)ip or (E)xit');
                    str(player.coins,tempstring);
                    settextstyle(default,horizontal,1);
                    setcolor(white);
                    outtextxy(240,400,('You have ' + tempstring + ' coins'));
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['e','E','b','B','p','P','t','T','*']);
                    clearpub;
                    settextstyle(sanseri,horizontal,3);
                    setcolor(magenta);
                    homecursor(x,y);
                    case ans of
                         'e','E':exit;
                         'b','B':buydrink(player.coins);
                         'p','P':skulldice(player);
                         't','T':tip(player.coins);
                             '*':attack_roland(player);
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
                         graphwriteln(x,y,'                     Zzzzzzzz....');
                         graphwriteln(x,y,'');
                         setcolor(cyan);
                         coins:=coins - innprice;
                         graphwriteln(x,y,'     You sleep the night and gain a little health.');
                         endurance:=endurance + d(4);
                         if(endurance>endurancemax)then
                              endurance:=endurancemax;
                         charges:=chargemax;
                         if (d(100)<=5) then
                              begin
                                   graphwriteln(x,y,'');
                                   graphwriteln(x,y,'');
                                   setcolor(blue);
                                   settextstyle(triplex,horizontal,2);
                                   graphwrite(x,y,'You find a small note under ');
                                   graphwriteln(x,y,'your pillow that says, "the');
                                   graphwriteln(x,y,'password is... crystal shard"');
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
     graphwriteln(x,y,'      Town Options');
     graphwriteln(x,y,'');
     settextstyle(default,horizontal,2);
     graphwriteln(x,y,'');
     setcolor(lightcyan);
     graphwrite(x,y,'            V');
     setcolor(lightblue);
     graphwriteln(x,y,'iew Stats');
     graphwriteln(x,y,'');
     setcolor(lightcyan);
     graphwrite(x,y,'            U');
     setcolor(lightblue);
     graphwriteln(x,y,'se Item');
     graphwriteln(x,y,'');
     setcolor(lightcyan);
     graphwrite(x,y,'            C');
     setcolor(lightblue);
     graphwriteln(x,y,'ast Spell');
     graphwriteln(x,y,'');
     setcolor(lightcyan);
     graphwrite(x,y,'            L');
     setcolor(lightblue);
     graphwriteln(x,y,'eave Town');
     graphwriteln(x,y,'');
     setcolor(lightcyan);
     graphwrite(x,y,'            S');
     setcolor(lightblue);
     graphwriteln(x,y,'ave Game');
     graphwriteln(x,y,'');
     setcolor(lightcyan);
     graphwrite(x,y,'            Q');
     setcolor(lightblue);
     graphwriteln(x,y,'uit Game');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     setcolor(lightcyan);

     graphwrite(x,y,'  ** ');
     setcolor(lightblue);
     graphwrite(x,y,'any other key--Back to Town');
     setcolor(lightcyan);
     graphwriteln(x,y,' **');
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
     if (not(endgame in player.stages))and(iceq in player.stages) then
          begin
               cleardevice;
               settextstyle(triplex,horizontal,3);
               setcolor(red);
               writefile(1,'081.txt');
               prompt;
               player.coins:=player.coins+reward;
               player.stages:=player.stages + [endgame];
          end;
     repeat
          cleardevice;
          drawpicturebyline(45,45,'thetown.ln1');
          settextstyle(default,horizontal,1);
          setcolor(white);
          x:=10;
          y:=410;
          graphwriteln(x,y,'                        choose a place to visit (1-4)');
          graphwriteln(x,y,'');
          graphwriteln(x,y,'                          press <SPACE> for options');
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
{---------------------------------------------------------------------------}
procedure initgame(var configuration:configrecord);

var
     pasfile        :    file of configrecord;

begin
     randomize;
     if exist('config.dat') then
          begin
               assign(pasfile,configfile);
               reset(pasfile);
               read(pasfile,configuration);
               close(pasfile);
               writeln('Config file loaded.');
          end
     else
          begin
               writeln('Config file not found.');
               writeln('Please restore the original game.');
               writeln('angelo.bertolli@gmail.com');
               ch:=readarrowkey;
          end;
end;

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
     graphwriteln(x,y,'You overhear some gossip...');
     graphwriteln(x,y,'');
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
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'');
                         if (nummonsters=0) then
                              begin
                                   graphwriteln(x,y,'You killed the elf and his companions.');
                              end
                         else
                              graphwriteln(x,y,'You escape and climb back up through the trap door.');
                         graphwriteln(x,y,'You quickly go back to the bar.');
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
                                        graphwriteln(x,y,'You learn SHATTER.');
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
                                   graphwriteln(x,y,'Sorry, you can''t learn any more spells.')
                              else
                                   if not(ring in player.stages) then
                                        graphwriteln(x,y,'You need a ring to store your spells.')
                                   else
                                             graphwriteln(x,y,'You humbly decline his offer.');
                         graphwriteln(x,y,'Dilvish and his companions bid you farewell.');
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
                                             graphwriteln(x,y,'');
                                             graphwriteln(x,y,'');
                                             if (nummonsters=0) then
                                                  begin
                                                       player.stages:=player.stages+[baltar];
                                                       graphwriteln(x,y,'The crowd goes wild as you defeat Baltar!');
                                                  end
                                             else
                                                  graphwriteln(x,y,'You are able to unlock the cage and escape.');
                                             graphwriteln(x,y,'You go back to the bar.');
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
     graphwriteln(x,y,'''''What''ll ya have?'''' asks Ahab the one-eyed bartender.');
     graphwriteln(x,y,'He points to a sign over the bar...');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'     (1) beer           (1 coins)');
     graphwriteln(x,y,'     (2) ale            (1 coins)');
     graphwriteln(x,y,'     (3) mead           (2 coins)');
     graphwriteln(x,y,'     (4) wine           (2 coins)');
     graphwriteln(x,y,'     (5) rum            (3 coins)');
     graphwriteln(x,y,'     (6) whiskey        (3 coins)');
     graphwriteln(x,y,'     (7) gin            (3 coins)');
     graphwriteln(x,y,'     (8) vodka          (3 coins)');
     graphwriteln(x,y,'     (9) Gorgon''s Milk   (5 coins)');
     graphwriteln(x,y,'     (N) No thanks');
     str(player.coins,tempstring);
     settextstyle(default,horizontal,1);
     setcolor(white);
     outtextxy(250,460,('You have ' + tempstring + ' coins'));
     setcolor(yellow);
     settextstyle(small,horizontal,6);
     graphwriteln(x,y,'');
     graphwriteln(x,y,'What do you take?');
     repeat
          ans:=readarrowkey;
     until (ans in ['1'..'9','n','N']);
     if (ans in ['n','N']) then
          begin
               setcolor(lightblue);
               graphwriteln(x,y,'                         Ahab grumbles');
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
               graphwriteln(x,y,'You sit down and have you''re drink.');
               player.coins:=player.coins - drinkprice;
               graphwriteln(x,y,'');
               case d(100) of
                   1..20:begin
                              writefile(200,'061.txt');
                         end;
                  21..80:begin
                              esi_gossip;
                         end;
                  81..90:begin
                              graphwriteln(x,y,'Ahab leans over to tell you a secret.');
                              graphwriteln(x,y,'     ''''Should ye wish to stay the night, I could send a little');
                              graphwriteln(x,y,'     company up to yer room, if ya know what I mean.''''');
                              graphwriteln(x,y,'Ahab lifts the patch over his eye to give you a wink.');
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
     graphwriteln(x,y,'''''Rooms are 5 coins per night,'''' says Ahab.');
     roomprice:=5;
     graphwriteln(x,y,'');
     graphwrite(x,y,'Do you want a room?  (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['y','Y']) then
          begin
               graphwriteln(x,y,'  y');
               graphwriteln(x,y,'''How about a little company tonight?  Only 20 coins.''');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'You respond?  (y/n)');
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
               graphwriteln(x,y,'You stay the night at the Elf Skull Inn.');
               graphwriteln(x,y,'');
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
                                   graphwriteln(x,y,'Maybe you should enjoy your room alone from now on...');
                              end
                         else
                              begin
                                   x:=10;
                                   graphwriteln(x,y,'You enjoy yourselves, but don''t get much rest.');
                                   player.endurance:=player.endurance + d(2);
                                   if (player.endurance>player.endurancemax) then
                                        player.endurance:=player.endurancemax;
                              end;
                    end
               else
                    begin
                         graphwriteln(x,y,'Loud parties and bouts of laughter keep you up half the night,');
                         graphwriteln(x,y,'but eventually you get to sleep.');
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
     graphwriteln(x,y,'You walk over to the craps table.');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'Do you play?  (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['y','Y']) then
          begin
               graphwriteln(x,y,'');
               graphwrite(x,y,'You bet (up to 1000 coins): ');
               graphread(x,y,tempstring);
               val(tempstring,bet,errcode);
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               if (bet<1) then
                    begin
                         graphwriteln(x,y,'What''s the point of playing for nothing?');
                         prompt;
                         exit;
                    end;
               if (bet>1000) then
                    begin
                         graphwriteln(x,y,'Sorry, they don''t accept such high bets.');
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
               graphwriteln(x,y,'You have placed your bet, now press space to roll the dice.');
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
                         graphwriteln(x,y,'Sorry, you lose.');
                         player.coins:=player.coins - bet;
                         prompt;
                         exit;
                    end;
               if (total=7) then
                    begin
                         graphwriteln(x,y,'Excellent!  You win!');
                         player.coins:=player.coins + bet;
                         prompt;
                         exit;
                    end;
               graphwriteln(x,y,'Roll again... (press space)');
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
                         graphwriteln(x,y,'Very unfortunate, you lose.');
                         player.coins:=player.coins - bet;
                    end
               else
                    begin
                         graphwriteln(x,y,'Congratulations.  You win!');
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
     graphwriteln(x,y,'The Magic Merchant welcomes you warmly to examine his wares.');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'     1) Red Potion    ONLY 100 coins!');
     graphwriteln(x,y,'     2) Blue Potion   ONLY 120 coins!');
     graphwriteln(x,y,'     3) Green Potion  ONLY 300 coins!');
     graphwriteln(x,y,'     4) Ring Charge   ONLY 400 coins!');
     graphwriteln(x,y,'     N)one');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'''''What do you like?'''' grins the Magic Merchant.');
     graphwriteln(x,y,'');
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
                        graphwriteln(x,y,'But you don''t have a ring!')
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
                                       graphwriteln(x,y,'Your ring cannot contain more charges.');
                                       prompt;
                                       exit;
                                  end;
                             player.charges:=player.charges+1;
                             player.chargemax:=player.chargemax+1;
                             player.coins:=player.coins-price;
                             graphwriteln(x,y,'''''Pleasure doing business with you!''''');
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
               graphwriteln(x,y,'');
               graphwriteln(x,y,'Sold!');
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
               graphwrite(x,y,'Place your wager (up to 100 coins): ');
               graphread(x,y,tempstring);
               val(tempstring,bet,errcode);
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               if (bet<1) then
                    begin
                         graphwriteln(x,y,'What''s the point of playing for nothing?');
                         prompt;
                         exit;
                    end;
               if (bet>100) then
                    begin
                         graphwriteln(x,y,'''''Too high for my taste.''''');
                         prompt;
                         exit;
                    end;
               if (player.coins<bet) then
                    begin
                         graphwriteln(x,y,'You secretly bet money you don''t have.');
                         prompt;
                    end;
               clearesi;
               x:=10;
               y:=175;
               setcolor(lightgreen);
               graphwriteln(x,y,'Ready.  Set.  Go!  (press space)');
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
                                graphwriteln(x,y,'You have lost!');
                                done:=true;
                                win:=false;
                           end;
                        -1:begin
                                graphwriteln(x,y,'You are losing...  (press space)');
                           end;
                         0:begin
                                graphwriteln(x,y,'You both continue to struggle.  (press space)');
                           end;
                         1:begin
                                graphwriteln(x,y,'You are winning...  (press space)');
                           end;
                         2:begin
                                graphwriteln(x,y,'You defeat the wimp.');
                                done:=true;
                                win:=true;
                           end;
                    end;{case}
               until (done);
               graphwriteln(x,y,'');
               if (win) then
                    begin
                         graphwriteln(x,y,'The wimp hands you your money.');
                         player.coins:=player.coins+bet;
                    end
               else
                    begin
                         graphwriteln(x,y,'It''s time for you to pay up.');
                         graphwriteln(x,y,'');
                         if (bet>player.coins) then
                              begin
                                   graphwriteln(x,y,'''''We don''t like people who bet with no money!''''');
                                   graphwriteln(x,y,'They attack.');
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
                                   graphwriteln(x,y,'After the fight you go back to the bar.');
                              end
                         else
                              begin
                                   graphwriteln(x,y,'''''Thanks,'''' he laughs.  ''''Come back any time.''''');
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
               graphwrite(x,y,'Place your wager (up to 100 coins): ');
               graphread(x,y,tempstring);
               val(tempstring,bet,errcode);
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               if (bet<1) then
                    begin
                         graphwriteln(x,y,'What''s the point of playing for nothing?');
                         prompt;
                         exit;
                    end;
               if (bet>100) then
                    begin
                         graphwriteln(x,y,'''''Ahem.  I don''t carry that much money.''''');
                         prompt;
                         exit;
                    end;
               if (player.coins<bet) then
                    begin
                         graphwriteln(x,y,'You secretly bet money you don''t have.');
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
                              1:graphwriteln(x,y,'First throw.');
                              2:graphwriteln(x,y,'Second throw.');
                              3:graphwriteln(x,y,'Third throw.');
                         end;
                         graphwriteln(x,y,'');
                         graphwrite(x,y,'He throws...  ');
                         setcolor(lightred);
                         case (d(20)+opponent) of
                            38..40:begin
                                        graphwriteln(x,y,'BULLSEYE! (20 pts)');
                                        score[1]:=score[1] + 20;
                                   end;
                            30..37:begin
                                        graphwriteln(x,y,'good shot. (10 pts)');
                                        score[1]:=score[1] + 10;
                                   end;
                            20..29:begin
                                        graphwriteln(x,y,'decent shot. (5 pts)');
                                        score[1]:=score[1] + 5;
                                   end;
                            10..19:begin
                                        graphwriteln(x,y,'barely hit the board. (3 pts)');
                                        score[1]:=score[1] + 3;
                                   end;
                            else
                                   begin
                                        graphwriteln(x,y,'missed the board completely. (0 pts)');
                                        score[1]:=score[1] + 0;
                                   end;
                         end;{case}
                         setcolor(lightgray);
                         graphwriteln(x,y,'');
                         graphwrite(x,y,'You throw... (press space)  ');
                         repeat
                              ch:=readarrowkey;
                         until (ch=' ');
                         setcolor(lightred);
                         case (d(20)+player.dexterity) of
                            38..40:begin
                                        graphwriteln(x,y,'BULLSEYE! (20 pts)');
                                        score[2]:=score[2] + 20;
                                   end;
                            30..37:begin
                                        graphwriteln(x,y,'they are impressed. (10 pts)');
                                        score[2]:=score[2] + 10;
                                   end;
                            20..29:begin
                                        graphwriteln(x,y,'you''re not too quick... (5 pts)');
                                        score[2]:=score[2] + 5;
                                   end;
                            10..19:begin
                                        graphwriteln(x,y,'barely hit the board. (3 pts)');
                                        score[2]:=score[2] + 3;
                                   end;
                            else
                                   begin
                                        graphwriteln(x,y,'they all laugh at you. (0 pts)');
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
               graphwriteln(x,y,'');
               if (win) then
                    begin
                         graphwriteln(x,y,'He shamefully hands you the money.');
                         player.coins:=player.coins+bet;
                    end
               else
                    begin
                         graphwriteln(x,y,'The winner looks at you expectantly.');
                         graphwriteln(x,y,'');
                         if (bet>player.coins) then
                              begin
                                   graphwriteln(x,y,'''''Don''t have the money?!''''');
                                   graphwriteln(x,y,'They attack.');
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
                                   graphwriteln(x,y,'After the fight you go back to the bar.');
                              end
                         else
                              begin
                                   graphwriteln(x,y,'''''Pleasure doing business with you.''''');
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
     graphwriteln(x,y,'You walk over to one of Roland''s Roving Jesters who is clad in');
     graphwriteln(x,y,'red and yellow.  He guardes a barred door.');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'''''What do you want?'''' he asks.');
     graphwriteln(x,y,'');
     graphwrite(x,y,'You say:  ');
     graphread(x,y,password);
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     if not(capitalize(password)='CRYSTAL SHARD') then
          begin
               setcolor(yellow);
               graphwriteln(x,y,'''''Bobo warned me about you.  I can''t let you in.''''');
               prompt;
          end
     else
          begin
               setcolor(yellow);
               graphwriteln(x,y,'He opens the door for you...');
               prompt;
               done:=false;
               repeat
                    clearesi;
                    x:=10;
                    y:=175;
                    setcolor(red);
                    settextstyle(small,horizontal,6);
                    graphwriteln(x,y,'Welcome to Roland McDoland''s');
                    graphwriteln(x,y,'    Wheel of Fortune!');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'For ONLY 500 coins you can spin');
                    graphwriteln(x,y,'the wheel of fortune!');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'Do you want to spin?  (y/n)');
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
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'You spin the wheel...');
                              prompt;
                              clearesi;
                              x:=15;
                              y:=300;
                              setcolor(red);
                              graphwriteln(x,y,'                 press space to stop the wheel');
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
          graphwriteln(x,y,'     1) Look around');
          graphwriteln(x,y,'     2) Order a drink');
          graphwriteln(x,y,'     3) Rent a room');
          graphwriteln(x,y,'     4) Try your luck at dice');
          y:=240;
          x:=320;
          graphwriteln(x,y,'     5) Visit the Magic Merchant');
          x:=320;
          graphwriteln(x,y,'     6) Arm wrestling table');
          x:=320;
          graphwriteln(x,y,'     7) Knife throwing board');
          x:=320;
          graphwriteln(x,y,'     8) Go over to the jester');
          graphwriteln(x,y,'');
          graphwriteln(x,y,'                       (V)iew your stats');
          graphwriteln(x,y,'                    (E)xit the Elf Skull Inn');
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


{---------------------------------------------------------------------------}
procedure encounter(chartfile:stringtype);

var
     monsterchart   :    chartrecord;
     pasfile        :    file of chartrecord;
     theroll        :    integer;
     count          :    integer;
     val1           :    integer;
     val2           :    integer;
     monsterfile    :    stringtype;
     monmax         :    integer;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'           You encounter');
     message(x,y,'');
     message(x,y,'             MONSTERS!');
     prompt;
     if not(exist(chartfile)) then
          exit;
     assign(pasfile,chartfile);
     reset(pasfile);
     read(pasfile,monsterchart);
     close(pasfile);

     with monsterchart do
          begin
               theroll:=droll(diceroll);
               monmax:=diceroll.rollnum*diceroll.dicetype+diceroll.bonus;
               for count:=1 to monmax do
                    begin
                         val1:=value[count,1];
                         val2:=value[count,2];
                         if (theroll in [val1..val2]) then
                              begin
                                   monsterfile:=filename[count];
                                   nummonsters:=droll(number[count]);
                                   if (nummonsters>monstermax) then
                                        nummonsters:=monstermax;
                                   if (nummonsters<1) then
                                        nummonsters:=1;
                              end;
                    end;
          end;

     rollmonsters(monster,nummonsters,monsterfile);
     combat(player,nummonsters,monster);

end;

{Dungeon/Cave/Castle Engine}
{---------------------------------------------------------------------------}
procedure dungeonoptions;

begin
     cleardevice;
     setcolor(magenta);
     settextstyle(default,horizontal,3);
     x:=10;
     y:=100;
     graphwriteln(x,y,'    Dungeon Options');
     graphwriteln(x,y,'');
     settextstyle(default,horizontal,2);
     graphwriteln(x,y,'');
     setcolor(lightmagenta);
     graphwrite(x,y,'            V');
     setcolor(magenta);
     graphwriteln(x,y,'iew Stats');
     graphwriteln(x,y,'');
     setcolor(lightmagenta);
     graphwrite(x,y,'            U');
     setcolor(magenta);
     graphwriteln(x,y,'se Item');
     graphwriteln(x,y,'');
     setcolor(lightmagenta);
     graphwrite(x,y,'            C');
     setcolor(magenta);
     graphwriteln(x,y,'ast Spell');
     graphwriteln(x,y,'');
     setcolor(lightmagenta);
     graphwrite(x,y,'            Q');
     setcolor(magenta);
     graphwriteln(x,y,'uit Game');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     setcolor(lightmagenta);
     graphwrite(x,y,'  ** ');
     setcolor(magenta);
     graphwrite(x,y,'any other key--Back to Game');
     setcolor(lightmagenta);
     graphwriteln(x,y,' **');
     ans:=readarrowkey;
     case ans of
      'v','V':begin
                   calcstats(player);
                   viewstats(player);
              end;
      'u','U':useitem(player);
      'c','C':castspell(player,dungeon);
      'q','Q':begin
                   closegraph;
                   halt;
              end;
     end;{case}
end;
{---------------------------------------------------------------------------}
procedure cave_locked(var player:playerrecord;var px,py:integer;lastx,lasty:integer);

var
     ans  :    char;
     done :    boolean;
     loop :    integer;
     ch   :    char;
     errcode:  integer;
     tempstring:string;

begin
     done:=false;
     if not(unlocked in player.stages) then
          repeat
               cleardevice;
               drawpicturebyline(10,10,'ldoor.ln1');
               setcolor(lightmagenta);
               x:=10;
               y:=300;
               settextstyle(sanseri,horizontal,2);
               graphwriteln(x,y,'You come across a locked door.');
               graphwriteln(x,y,'(A)ttack it');
               graphwriteln(x,y,'(U)se an item');
               graphwriteln(x,y,'(C)ast a spell');
               graphwriteln(x,y,'Use a (k)ey');
               graphwriteln(x,y,'(L)eave');
               repeat
                    ans:=readarrowkey;
               until (ans in ['a','A','u','U','c','C','k','K','l','L']);
               done:=ans in ['l','L'];
               cleardevice;
               homecursor(x,y);
               case ans of
                 'a','A':begin
                              graphwriteln(x,y,'You attack the door, but it doesn''t budge...');
                              prompt;
                         end;
                 'u','U':begin
                              graphwriteln(x,y,'Use which item?');
                              with player do
                                   for loop:=1 to numitems do
                                        begin
                                             str(loop,tempstring);
                                             ch:=tempstring[1];
                                             tempstring:='      ';
                                             tempstring:=tempstring + ch + '. ';
                                             tempstring:=tempstring + itemstring(item[loop]);
                                             graphwriteln(x,y,tempstring);
                                        end;
                              graphwriteln(x,y,'     (N)evermind');
                              repeat
                                   ans:=readarrowkey;
                              until (ans in ['1'..ch,'n','N']);
                              graphwriteln(x,y,'');
                              graphwrite(x,y,'You point the ');
                              tempstring:=ans;
                              val(tempstring,loop,errcode);
                              tempstring:=itemstring(player.item[loop]);
                              graphwrite(x,y,tempstring);
                              graphwriteln(x,y,' at the door.');
                              graphwriteln(x,y,'It does nothing.');
                              prompt;
                         end;
                 'c','C':if (player.charges>0) then
                           begin
                              graphwriteln(x,y,'Cast which spell?');
                              with player do
                                   for loop:=1 to numspells do
                                        begin
                                             str(loop,tempstring);
                                             ch:=tempstring[1];
                                             tempstring:='      ';
                                             tempstring:=tempstring + ch + '. ';
                                             tempstring:=tempstring + spellstring(spell[loop]);
                                             graphwriteln(x,y,tempstring);
                                        end;
                              graphwriteln(x,y,'     (N)evermind');
                              repeat
                                   ans:=readarrowkey;
                              until (ans in ['1'..ch,'n','N']);
                              tempstring:=ans;
                              val(tempstring,loop,errcode);
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'');
                              if not(player.spell[loop] in [obliterate,shatter]) then
                                   begin
                                        graphwrite(x,y,'You cast ');
                                        tempstring:=spellstring(player.spell[loop]);
                                        graphwriteln(x,y,tempstring);
                                        graphwriteln(x,y,'It does nothing useful.');
                                   end
                              else
                                   if (player.spell[loop]=shatter) then
                                        begin
                                             graphwriteln(x,y,'You freeze the lock, making it brittle.');
                                             graphwriteln(x,y,'');
                                             graphwriteln(x,y,'With one swift blow, you break off the lock.');
                                             player.stages:=player.stages + [unlocked];
                                             done:=true;
                                        end
                                   else
                                        begin
                                             graphwriteln(x,y,'You obliterate the door.');
                                             player.stages:=player.stages + [unlocked];
                                             done:=true;
                                        end;
                              if not(ans in ['n','N']) then
                                   player.charges:=player.charges-1;
                              prompt;
                           end
                         else
                           begin
                                graphwriteln(x,y,'You have not more charges in your ring.');
                                prompt;
                           end;
                 'k','K':if (key in player.stages) then
                              begin
                                   graphwriteln(x,y,'The key doesn''t work.');
                                   prompt;
                              end
                         else
                              begin
                                   graphwriteln(x,y,'You don''t have any keys.');
                                   prompt;
                              end;
               end;{case}
               cleardevice;
          until (done);
     if not(unlocked in player.stages) then
          begin
               px:=lastx;
               py:=lasty;
          end;
     screensetup;
end;
{---------------------------------------------------------------------------}
procedure cave_staircase;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'    You are on a staircase that');
     message(x,y,'      descends to the north.');
end;
{---------------------------------------------------------------------------}
procedure secret_passage;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'   You are in a secret passage.');
end;
{---------------------------------------------------------------------------}
procedure castle_courtyard;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,' You are in the castle courtyard.');
end;
{---------------------------------------------------------------------------}
procedure castle_guest;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,' This appears to be a guest room.');
end;
{---------------------------------------------------------------------------}
procedure castle_banquet;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'   This is a vast banquet hall.');
end;
{---------------------------------------------------------------------------}
procedure castle_master;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'       The Queen''s bedroom.');
end;
{---------------------------------------------------------------------------}
procedure castle_kitchen;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'        An empty kitchen.');
end;
{---------------------------------------------------------------------------}
procedure cave_key(var player:playerrecord);

begin
     if not(key in player.stages) then
          begin
               clearmessage;
               homemessage(x,y);
               settextstyle(default,horizontal,2);
               setcolor(black);
               message(x,y,'          You find a key.');
               message(x,y,'');
               message(x,y,'          Take it? (y/n)');
               repeat
                    ans:=readarrowkey;
               until (ans in ['y','Y','n','N']);
               if (ans in ['Y','y']) then
                    player.stages:=player.stages + [key];
               clearmessage;
          end;
end;
{---------------------------------------------------------------------------}
procedure dungeon_treasure(var player:playerrecord);

begin
     if not(treasure in player.stages) then
          begin
               clearmessage;
               homemessage(x,y);
               settextstyle(default,horizontal,2);
               setcolor(black);
               message(x,y,'     You find some treasure.');
               message(x,y,'');
               message(x,y,'          Take it? (y/n)');
               repeat
                    ans:=readarrowkey;
               until (ans in ['y','Y','n','N']);
               if (ans in ['Y','y']) then
                    begin
                         player.stages:=player.stages + [treasure];
                         player.coins:=player.coins+1000+d(1000);
                    end;
               clearmessage;
          end;
end;
{---------------------------------------------------------------------------}
procedure dungeon_trap(var player:playerrecord);

var
     tempstring     :    string;
     dmg            :    byte;

begin
     tempstring:='';
     case d(6) of
        1:tempstring:='an explosion trap.';
        2:tempstring:='a falling block trap.';
        3:tempstring:='a gas trap.';
        4:tempstring:='an arrow trap.';
        5:tempstring:='an axe trap.';
        6:tempstring:='a pit trap.';
     end;
     dmg:=d(6)+d(6);
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     if (d(20)>player.savingthrow) then
          begin
               message(x,y,'');
               message(x,y,'You are able to avoid');
               message(x,y,tempstring);
          end
     else
          begin
               message(x,y,'');
               message(x,y,'You take damage from');
               message(x,y,tempstring);
               if (dmg>=player.endurance) then
                    begin
                         prompt;
                         message(x,y,'You die...');
                         died;
                    end
               else
                    player.endurance:=player.endurance-dmg;
          end;
     prompt;
     screensetup;
end;
{---------------------------------------------------------------------------}
procedure cave_library;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'You find a massive book on a podium.');
     message(x,y,'');
     message(x,y,' Do you want to look at it? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['Y','y']) then
          begin
               cleardevice;
               setcolor(magenta);
               settextstyle(sanseri,horizontal,2);
               writefile(1,'076.txt');
               prompt;
               died;
          end;
     clearmessage;
end;
{---------------------------------------------------------------------------}
procedure cave_sword(var player:playerrecord);

begin
     cleardevice;
     setcolor(brown);
     settextstyle(triplex,horizontal,3);
     homecursor(x,y);
     if not(msword in player.stages) then
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'A large bat-winged creature with the body of a lion');
               graphwriteln(x,y,'and the head of a man guards a sword here.  It sees');
               graphwriteln(x,y,'you and attacks!');
               drawpicturebyline(200,200,'manticor.ln1');
               prompt;
               nummonsters:=1;
               rollmonsters(monster,nummonsters,'manticor.dat');
               combat(player,nummonsters,monster);
               if (nummonsters=0) then
                    begin
                         player.stages:=player.stages + [msword];
                         cleardevice;
                         setcolor(lightblue);
                         settextstyle(triplex,horizontal,3);
                         homecursor(x,y);
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'CONGRATULATIONS!');
                         graphwriteln(x,y,'You find a magic sword.');
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'');
                         drawpicturebyline(x,y,'magicswd.ln1');
                         if (player.numitems<itemmax) then
                               begin
                                    player.numitems:=player.numitems + 1;
                                    player.item[player.numitems]:=magicsword;
                                    setcolor(lightblue);
                                    graphwriteln(x,y,'     You pick up the magic sword.');
                                    prompt;
                               end
                         else
                               begin
                                    setcolor(lightblue);
                                    graphwriteln(x,y,'     You are carrying too many items.');
                                    graphwriteln(x,y,'     Do you want to drop one? (y/n)');
                                    repeat
                                         ch:=readarrowkey;
                                    until(ch in ['n','N','y','Y']);
                                    if (ch in ['y','Y']) then
                                         begin
                                              dropitem(player);
                                              player.numitems:=player.numitems+1;
                                              player.item[player.numitems]:=magicsword;
                                         end
                                    else
                                         begin
                                              graphwriteln(x,y,'');
                                              graphwriteln(x,y,'     You leave the sword here.');
                                              prompt;
                                         end;
                                end;
                         end
               end
          else
               begin
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'There is a manticore carcass here, being eaten by');
                    graphwriteln(x,y,'ants.');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'There doesn''t seem to be anything of interest here.');
                    prompt;
               end;
     screensetup;
end;
{---------------------------------------------------------------------------}
procedure cave_shield(var player:playerrecord);

begin
     cleardevice;
     setcolor(darkgray);

     settextstyle(triplex,horizontal,3);
     homecursor(x,y);
     if not(mshield in player.stages) then
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'A dark, panther-like creature with tentacles looks');
               graphwriteln(x,y,'at you.  It seems to fade in and out of existence.');
               graphwriteln(x,y,'It decides it''s hungry and attacks!');
               drawpicturebyline(200,200,'displace.ln1');
               prompt;
               nummonsters:=1;
               rollmonsters(monster,nummonsters,'displace.dat');
               combat(player,nummonsters,monster);
               if (nummonsters=0) then
                    begin
                         player.stages:=player.stages + [mshield];
                         cleardevice;
                         setcolor(lightblue);
                         settextstyle(triplex,horizontal,3);
                         homecursor(x,y);
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'CONGRATULATIONS!');
                         graphwriteln(x,y,'You find a magic shield.');
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'');
                         drawpicturebyline(x,y,'magicshl.ln1');
                         if (player.numitems<itemmax) then
                               begin
                                    player.numitems:=player.numitems + 1;
                                    player.item[player.numitems]:=magicshield;
                                    setcolor(lightblue);
                                    graphwriteln(x,y,'     You pick up the magic shield.');
                                    prompt;
                               end
                         else
                               begin
                                    setcolor(lightblue);
                                    graphwriteln(x,y,'     You are carrying too many items.');
                                    graphwriteln(x,y,'     Do you want to drop one? (y/n)');
                                    repeat
                                         ch:=readarrowkey;
                                    until(ch in ['n','N','y','Y']);
                                    if (ch in ['y','Y']) then
                                         begin
                                              dropitem(player);
                                              player.numitems:=player.numitems+1;
                                              player.item[player.numitems]:=magicshield;
                                         end
                                    else
                                         begin
                                              graphwriteln(x,y,'');
                                              graphwriteln(x,y,'     You leave the shield here.');
                                              prompt;
                                         end;
                                end;
                         end
               end
          else
               begin
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'There is a bad smell...');
                    graphwriteln(x,y,'');
                    graphwriteln(x,y,'There doesn''t seem to be anything of interest here.');
                    prompt;
               end;
     screensetup;
end;
{---------------------------------------------------------------------------}
procedure dungeon_lizard(var player:playerrecord;var px,py:integer;lastx,lasty:integer);

begin
     cleardevice;
     setcolor(lightblue);
     settextstyle(triplex,horizontal,3);
     homecursor(x,y);
     if not(lizard in player.stages) then
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'This is the home of a large lizard with six legs.');
               graphwriteln(x,y,'It rears up to atack you!');
               drawpicturebyline(200,200,'salamand.ln1');
               prompt;
               nummonsters:=1;
               rollmonsters(monster,nummonsters,'salamand.dat');
               combat(player,nummonsters,monster);
               if (nummonsters=0) then
                    player.stages:=player.stages + [lizard]
               else
                    begin
                         px:=lastx;
                         py:=lasty;
                    end;
          end;
     screensetup;
end;
{---------------------------------------------------------------------------}
procedure castle_barracks;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'You find yourself in the barracks.');
     message(x,y,'    The soldiers here attack!');
     prompt;
     encounter(cfg.castlechart);
     screensetup;
end;
{---------------------------------------------------------------------------}
procedure castle_knight(var player:playerrecord;var px,py:integer;lastx,lasty:integer);

begin
     cleardevice;
     setcolor(cyan);
     settextstyle(triplex,horizontal,3);
     homecursor(x,y);
     if not(knight in player.stages) then
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'Lorn Paradox, the Ice Queen''s knight lives here,');
               graphwriteln(x,y,'and he just happens to be at home.  He attacks!');
               drawpicturebyline(200,200,'knight.ln1');
               prompt;
               nummonsters:=1;
               rollmonsters(monster,nummonsters,'knight.dat');
               combat(player,nummonsters,monster);
               if (nummonsters=0) then
                    player.stages:=player.stages + [knight]
               else
                    begin
                         px:=lastx;
                         py:=lasty;
                    end;
          end;
     screensetup;
end;
{---------------------------------------------------------------------------}
procedure castle_throne(var player:playerrecord;var px,py:integer;lastx,lasty:integer);

begin
     cleardevice;
     setcolor(blue);
     settextstyle(triplex,horizontal,3);
     homecursor(x,y);
     if not(iceq in player.stages) then
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'You have entered the throne room of the Ice Queen');
               graphwriteln(x,y,'herself!  And here she is.');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'She eyes you suspiciously, "I knew you''d get here');
               graphwriteln(x,y,'eventually.  You have forced me to kill you..."');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'She begins conjuring strong magic and attacks!');
               drawpicturebyline(210,300,'icequeen.ln1');
               prompt;
               nummonsters:=1;
               rollmonsters(monster,nummonsters,'icequeen.dat');
               monster[1].endurance:=40;
               combat(player,nummonsters,monster);
               if (nummonsters=0) then
                    begin
                         player.stages:=player.stages + [iceq];
                         cleardevice;
                         setcolor(yellow);
                         settextstyle(triplex,horizontal,3);
                         writefile(1,'080.txt');
                         prompt;
                    end
               else
                    begin
                         px:=lastx;
                         py:=lasty;
                    end;
          end
     else
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'There is a headless Ice Queen in the throne room.');
               prompt;
          end;
     screensetup;
end;
{---------------------------------------------------------------------------}
procedure stair_up;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'  There are stairs going up here.');
     prompt;
end;
{---------------------------------------------------------------------------}
procedure dungeon(var player:playerrecord;themap:stringtype;thecode:stringtype;
                  monsterchart:stringtype;px,py:integer);

var
     dungeonmap     :    matrix;
     dungeoncode    :    matrix;
     lastx          :    integer;
     lasty          :    integer;
     pasfile        :    file of matrix;
     exitx          :    integer;
     exity          :    integer;
     exitdungeon    :    boolean;

begin
     exitx:=px;
     exity:=py;
     assign(pasfile,themap);
     reset(pasfile);
     read(pasfile,dungeonmap);
     close(pasfile);
     assign(pasfile,thecode);
     reset(pasfile);
     read(pasfile,dungeoncode);
     close(pasfile);
     exitdungeon:=false;
     screensetup;
     writestats(player);
     repeat
          drawmaptile(px,py,dungeonmap);
          if (px>1)and(dungeonmap[px-1,py]<>28) then
               drawmaptile(px-1,py,dungeonmap);
          if (px<20)and(dungeonmap[px+1,py]<>28) then
               drawmaptile(px+1,py,dungeonmap);
          if (py>1)and(dungeonmap[px,py-1]<>28) then
               drawmaptile(px,py-1,dungeonmap);
          if (py<14)and(dungeonmap[px,py+1]<>28) then
               drawmaptile(px,py+1,dungeonmap);
          if (px>1)and(py>1)and(dungeonmap[px-1,py-1]<>28) then
               drawmaptile(px-1,py-1,dungeonmap);
          if (px<20)and(py<14)and(dungeonmap[px+1,py+1]<>28) then
               drawmaptile(px+1,py+1,dungeonmap);
          if (px>1)and(py<14)and(dungeonmap[px-1,py+1]<>28) then
               drawmaptile(px-1,py+1,dungeonmap);
          if (px<20)and(py>1)and(dungeonmap[px+1,py-1]<>28) then
               drawmaptile(px+1,py-1,dungeonmap);
          setcolor(red);
          setfillstyle(solidfill,red);
          fillellipse((px*20)+31,(py*20)+31,3,3);
          lastx:=px;
          lasty:=py;
          writestats(player);
          repeat
               ans:=readarrowkey;

          until (ans in ['2','4','6','8',' ']);
          clearmessage;
          if (dungeoncode[px,py]=28) then
               begin
                    setcolor(blue);
                    setfillstyle(solidfill,blue);
                    fillellipse((px*20)+31,(py*20)+31,3,3);
               end;
          if (ans='2')and(py<14)and(dungeoncode[px,py+1]<>1) then
               py:=py + 1;
          if (ans='8')and(py>1)and(dungeoncode[px,py-1]<>1) then
               py:=py - 1;
          if (ans='6')and(px<20)and(dungeoncode[px+1,py]<>1) then
               px:=px + 1;
          if (ans='4')and(px>1)and(dungeoncode[px-1,py]<>1) then
               px:=px - 1;
          if (ans=' ') then
               begin
                    dungeonoptions;
                    screensetup;
                    writestats(player);
               end;
          if (px<>lastx)or(py<>lasty) then
               begin
                    drawmaptile(lastx,lasty,dungeonmap);
                    case dungeoncode[px,py] of
                         0:if (d(100)<=dungeonchance) then
                                begin
                                     encounter(monsterchart);
                                     screensetup;
                                end;
                         9:cave_sword(player);
                        10:cave_shield(player);
                        11:cave_library;
                        12:cave_key(player);
                        13:cave_staircase;
                        14:cave_locked(player,px,py,lastx,lasty);
                        15:dungeon_treasure(player);
                        16:dungeon_trap(player);
                        17:dungeon_lizard(player,px,py,lastx,lasty);
                        18:
{stair down}
begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,' There are stairs going down here.');
     message(x,y,'');
     message(x,y,'     Do you take them? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['y','Y']) then
          dungeon(player,cfg.dungeonmap,cfg.dungeoncode,cfg.dungeonchart,px,py);
     screensetup;
end;

                        19:stair_up;
                        20:castle_knight(player,px,py,lastx,lasty);
                        21:castle_barracks;
                        22:castle_courtyard;
                        23:castle_guest;
                        24:castle_banquet;
                        25:castle_master;
                        26:castle_kitchen;
                        27:castle_throne(player,px,py,lastx,lasty);
                        28:secret_passage;
                    end;
                    drawmaptile(lastx,lasty,dungeonmap);
                    if (px=exitx)and(py=exity) then
                         begin
                              clearmessage;
                              homemessage(x,y);
                              settextstyle(default,horizontal,2);
                              setcolor(black);
                              message(x,y,'');
                              message(x,y,'            Exit? (y/n)');
                              repeat
                                   ans:=readarrowkey;
                              until (ans in ['y','Y','n','N']);
                              exitdungeon:=ans in ['y','Y'];
                              screensetup;
                         end;
               end;
     until exitdungeon;
end;

{Surface World Functions and Procedures}
{---------------------------------------------------------------------------}
procedure thedragon(var player:playerrecord);

begin
     cleardevice;
     setcolor(red);
     settextstyle(triplex,horizontal,3);
     homecursor(x,y);
     if not(dragon in player.stages) then
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'The wind blows quietly, and you get an eerie feeling');
               graphwriteln(x,y,'as you enter this place.  When you look up into the');
               graphwriteln(x,y,'mountains, you see that you have stumbled upon');
               graphwriteln(x,y,'the cave of the great Red Dragon!');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'It''s not too late to turn back.');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               setcolor(lightgray);
               graphwrite(x,y,'                  Turn back now?  (y/n)');
               repeat
                    ch:=readarrowkey;
               until(ch in ['y','Y','n','N']);
               if (ch in ['y','Y']) then
                    begin
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'     You wisely choose to leave.');
                         prompt;
                    end
               else
                    begin
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'');
                         graphwriteln(x,y,'     You enter the dragon''s lair...');
                         prompt;
                         nummonsters:=1;
                         rollmonsters(monster,nummonsters,'dragon.dat');
                         monster[1].endurance:=80;
                         monster[1].endurancemax:=80;
                         combat(player,nummonsters,monster);
                         if (nummonsters=0) then
                              begin
                                   player.stages:=player.stages + [dragon];
                                   cleardevice;

                                   setcolor(lightblue);
                                   settextstyle(triplex,horizontal,3);
                                   homecursor(x,y);
                                   graphwriteln(x,y,'');
                                   graphwriteln(x,y,'');
                                   graphwriteln(x,y,'CONGRATULATIONS!');
                                   graphwriteln(x,y,'You have defeated the great Red Dragon.');
                                   graphwriteln(x,y,'In the dragon''s horde, you find the Flame Wand.');
                                   graphwriteln(x,y,'');
                                   graphwriteln(x,y,'');
                                   drawpicturebyline(x,y,'flamewnd.ln1');
                                   if (player.numitems<itemmax) then
                                        begin
                                             player.numitems:=player.numitems + 1;
                                             player.item[player.numitems]:=flamewand;
                                             setcolor(lightblue);
                                             graphwriteln(x,y,'     You pick up the Flame Wand as your own.');
                                             prompt;
                                        end
                                   else
                                        begin
                                             setcolor(lightblue);
                                             graphwriteln(x,y,'     You are carrying too many items.');
                                             graphwriteln(x,y,'     Do you want to drop one? (y/n)');
                                             repeat
                                                  ch:=readarrowkey;
                                             until(ch in ['n','N','y','Y']);
                                             if (ch in ['y','Y']) then
                                                  begin
                                                       dropitem(player);
                                                       player.numitems:=player.numitems+1;
                                                       player.item[player.numitems]:=flamewand;
                                                  end
                                             else
                                                  begin
                                                       graphwriteln(x,y,'');
                                                       graphwriteln(x,y,'     You leave the wand here.');
                                                       prompt;
                                                  end;
                                        end;
                              end;
                    end;
          end
     else
          begin
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'This was once the dwelling place of the ancient');
               graphwriteln(x,y,'Red Dragon.');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'You see a huge red carcass nearby with flies');
               graphwriteln(x,y,'buzzing around it.');
               graphwriteln(x,y,'');
               graphwriteln(x,y,'There doesn''t seem to be anything of interest here.');
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure thepassword;

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(sanseri,horizontal,4);
     setcolor(lightblue);
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'   In the side of the icy rock');
     graphwriteln(x,y,'mountains you see something written');
     graphwriteln(x,y,'etched in the stone.  It says:');
     settextstyle(triplex,horizontal,6);
     graphwriteln(x,y,'');
     repeat
         setcolor(d(15));
         outtextxy(x,y,'     crystal shard');
     until Keypressed;
     prompt;
end;
{---------------------------------------------------------------------------}
procedure enterinn;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,' The Elf Skull Inn -- enter? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['Y','y']) then
          elfskullinn(player)
     else
          surfacemessage;
end;
{---------------------------------------------------------------------------}
procedure entertown;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'   Gilantry City -- enter? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['Y','y']) then
          thetown(player)
     else
          surfacemessage;
end;
{---------------------------------------------------------------------------}
procedure entercave;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'       A Cave -- enter? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['Y','y']) then
          dungeon(player,cfg.cavemap,cfg.cavecode,cfg.cavechart,20,8)
     else
          surfacemessage;
end;
{---------------------------------------------------------------------------}
procedure entercastle(var player:playerrecord);

var
     enter:    boolean;
     done :    boolean;
     tempstring:stringtype;
     errcode:integer;

begin
     enter:=false;
     cleardevice;
     drawpicturebyline(120,1,'tcastle.ln1');
     setcolor(white);
     message(x,y,'');
     settextstyle(sanseri,horizontal,2);
     graphwriteln(x,y,'You approach the ice castle.  A cold wind blows.');
     if (endgame in player.stages) then
          begin
               graphwriteln(x,y,'It has been sealed by the Wizards of Gilantry.');
               prompt;
               exit;
          end;
     prompt;
     done:=false;
     repeat
          cleardevice;
          setcolor(white);
          writefile(1,'077.txt');
          repeat
               ans:=readarrowkey;
          until (ans in ['b','B','o','O','c','C','l','L']);
          cleardevice;
          homecursor(x,y);
          case ans of
             'b','B':begin
                          writefile(1,'078.txt');
                          prompt;
                     end;
             'o','O':begin
                          writefile(1,'079.txt');
                          prompt;
                     end;
             'c','C':if (player.charges>0) then
                           begin
                              graphwriteln(x,y,'Cast which spell?');
                              with player do
                                   for loop:=1 to numspells do
                                        begin
                                             str(loop,tempstring);
                                             ch:=tempstring[1];
                                             tempstring:='      ';
                                             tempstring:=tempstring + ch + '. ';
                                             tempstring:=tempstring + spellstring(spell[loop]);
                                             graphwriteln(x,y,tempstring);
                                        end;
                              graphwriteln(x,y,'     (N)evermind');
                              repeat
                                   ans:=readarrowkey;
                              until (ans in ['1'..ch,'n','N']);
                              tempstring:=ans;
                              val(tempstring,loop,errcode);
                              graphwriteln(x,y,'');
                              graphwriteln(x,y,'');
                              if not(player.spell[loop] in [obliterate,callwild]) then
                                   begin
                                        graphwrite(x,y,'You cast ');
                                        tempstring:=spellstring(player.spell[loop]);
                                        graphwriteln(x,y,tempstring);
                                        graphwriteln(x,y,'It does nothing useful.');
                                        prompt;
                                   end
                              else
                                   if (player.spell[loop]=callwild) then
                                        begin
                                             graphwriteln(x,y,'An giant bird known as a roc comes to your');
                                             graphwriteln(x,y,'aid...');
                                             graphwriteln(x,y,'It cries as it circles and the guards upon');
                                             graphwriteln(x,y,'the castle duck down to hide.  The roc lands');
                                             graphwriteln(x,y,'and you hoist yourself upon it.  It flies you');
                                             graphwriteln(x,y,'over the wall.  The roc leaves and the guards attack.');
                                             prompt;
                                             encounter(cfg.castlechart);
                                             done:=true;
                                             enter:=true;
                                        end
                                   else
                                        begin
                                             graphwriteln(x,y,'You obliterate the gate.');
                                             graphwriteln(x,y,'Upon seeing this some of the guards make a run');
                                             graphwriteln(x,y,'for it.  The others attack...');
                                             prompt;
                                             encounter(cfg.castlechart);
                                             done:=true;
                                             enter:=true;
                                        end;
                              if not(ans in ['n','N']) then
                                   player.charges:=player.charges-1;
                           end
                     else
                           begin
                                graphwriteln(x,y,'You have not more charges in your ring.');
                                prompt;
                           end;
             'l','L':done:=true;
          end;{case}
     until done;
     if (enter) then
          dungeon(player,cfg.castlemap,cfg.castlecode,cfg.castlechart,10,13);

end;
{---------------------------------------------------------------------------}
procedure drawmap(themap:matrix);

begin
     for row:=1 to rowmax do
          for col:=1 to colmax do
               drawmaptile(col,row,themap);
end;
{---------------------------------------------------------------------------}
procedure drawplayer(xpos,ypos:integer;chartile:stringtype);

var
     xpix           :    integer;
     ypix           :    integer;

begin
     xpix:=41;
     ypix:=41;
     xpix:=xpix + ((xpos - 1) * 20);
     ypix:=ypix + ((ypos - 1) * 20);
     drawpicturebyline(xpix,ypix,chartile);
end;
{---------------------------------------------------------------------------}
procedure surfacescreen(surfacemap:matrix);

begin
     screensetup;
     drawmap(surfacemap);
     surfacemessage;
     writestats(player);
end;
{---------------------------------------------------------------------------}
procedure surfaceoptions;

begin
     cleardevice;
     setcolor(green);
     settextstyle(default,horizontal,3);
     x:=10;
     y:=100;
     graphwriteln(x,y,'   Wilderness Options');
     graphwriteln(x,y,'');
     settextstyle(default,horizontal,2);
     graphwriteln(x,y,'');
     setcolor(lightgreen);
     graphwrite(x,y,'            V');
     setcolor(green);
     graphwriteln(x,y,'iew Stats');
     graphwriteln(x,y,'');
     setcolor(lightgreen);
     graphwrite(x,y,'            U');
     setcolor(green);
     graphwriteln(x,y,'se Item');
     graphwriteln(x,y,'');
     setcolor(lightgreen);
     graphwrite(x,y,'            C');
     setcolor(green);
     graphwriteln(x,y,'ast Spell');
     graphwriteln(x,y,'');
     setcolor(lightgreen);
     graphwrite(x,y,'            Q');
     setcolor(green);
     graphwriteln(x,y,'uit Game');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     graphwriteln(x,y,'');
     setcolor(lightgreen);
     graphwrite(x,y,'  ** ');
     setcolor(green);
     graphwrite(x,y,'any other key--Back to Game');
     setcolor(lightgreen);
     graphwriteln(x,y,' **');
     ans:=readarrowkey;
     case ans of
      'v','V':begin
                   calcstats(player);
                   viewstats(player);
              end;
      'u','U':useitem(player);
      'c','C':castspell(player,wilderness);
      'q','Q':begin
                   closegraph;
                   halt;
              end;
     end;{case}
end;
{---------------------------------------------------------------------------}
procedure surface(var player:playerrecord);

var
     px             :    integer;
     py             :    integer;
     lastx          :    integer;
     lasty          :    integer;
     surfacecode    :    matrix;
     surfacemap     :    matrix;
     pasfile        :    file of matrix;

begin
     assign(pasfile,cfg.surfacemap);
     reset(pasfile);
     read(pasfile,surfacemap);
     close(pasfile);
     assign(pasfile,cfg.surfacecode);
     reset(pasfile);
     read(pasfile,surfacecode);
     close(pasfile);
     surfacescreen(surfacemap);
     px:=10;
     py:=11;
     repeat
          drawplayer(px,py,cfg.chartile);
          lastx:=px;
          lasty:=py;
          repeat
               ans:=readarrowkey;
          until (ans in ['2','4','6','8',' ']);
          if (ans='2')and(py<14)and(surfacecode[px,py+1]<>1) then
               py:=py + 1;
          if (ans='8')and(py>1)and(surfacecode[px,py-1]<>1) then
               py:=py - 1;
          if (ans='6')and(px<20)and(surfacecode[px+1,py]<>1) then
               px:=px + 1;
          if (ans='4')and(px>1)and(surfacecode[px-1,py]<>1) then
               px:=px - 1;
          if (ans=' ') then
               begin
                    surfaceoptions;
                    surfacescreen(surfacemap);
               end;
          if (px<>lastx)or(py<>lasty) then
               begin
                    drawmaptile(lastx,lasty,surfacemap);
                    case surfacecode[px,py] of
                         0:if (d(100)<=wildchance) then
                                begin
                                     encounter(cfg.wildchart);
                                     surfacescreen(surfacemap);
                                end;
                         2:if (d(100)<=roadchance) then
                                begin
                                     encounter(cfg.wildchart);
                                     surfacescreen(surfacemap);
                                end;
                         3:entertown;
                         4:enterinn;
                         5:entercave; {* cave *}
                         6:thedragon(player);
                         7:thepassword;
                         8:entercastle(player); {* castle *}
                    end;
                    if(surfacecode[px,py] in [3..8])then
                         surfacescreen(surfacemap);
               end;
     until FALSE;
end;


{===========================================================================}

begin {main}

     writeln('The Icequeen ',version);
     writeln('Copyright (C) 2001 - Angelo Bertolli');
     writeln('                     angelo.bertolli@gmail.com');
     writeln('Ice Queen comes with ABSOLUTELY NO WARRANTY');
     writeln('This is free software and you are welcome');
     writeln('to redistribute it under certain conditions.');
     writeln('(See the file named LICENSE.GPL)');
     writeln;
     writeln('For a pascal compiler, visit http://www.freepascal.org/');
     initgame(cfg);
     graph_init(device,mode,'');

     titlescreen;
     mainmenu;
     thetown(player);
     surface(player);

     closegraph;

end.  {main}
