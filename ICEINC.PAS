{---------------------------------------------------------------------------}
function skillstring(theskill:integer):stringtype;

begin
     case theskill of
          1:skillstring:='ice storm';
          2:skillstring:='fire blast';
          3:skillstring:='web';
          4:skillstring:='call wild';
          5:skillstring:='heal';
          6:skillstring:='courage';
          7:skillstring:='freeze';
          8:skillstring:='obliterate';
          9:skillstring:='icicle';
         10:skillstring:='power';
         11:skillstring:='shatter';
         12:skillstring:='glacier';
         13:skillstring:='dragon breath';
         14:skillstring:='resist fire';
         15:skillstring:='resist cold';
     end;{case}
end;
{---------------------------------------------------------------------------}
function itemstring(theitem:integer):stringtype;

begin
     case theitem of
          1:itemstring:='sword';
          2:itemstring:='shield';
          3:itemstring:='axe';
          4:itemstring:='blue potion';
          5:itemstring:='red potion';
          6:itemstring:='green potion';
          7:itemstring:='chain mail';
          8:itemstring:='plate mail';
          9:itemstring:='dagger';
         10:itemstring:='club';
         11:itemstring:='staff';
         12:itemstring:='hammer';
         13:itemstring:='magic sword';
         14:itemstring:='magic shield';
         15:itemstring:='flame wand';
     end;{case}
end;
{--------------------------------------------------------------------------}
function READARROWKEY    :    char;

{This function can be used instead of readkey, returning an arrow key value as
its keypad counterpart.}

var
     key            :    char;

begin
     key:=readkey;
     if key=#0 then
          begin
               key:=readkey;
               case key of
                    #72:key:='8';
                    #77:key:='6';
                    #75:key:='4';
                    #80:key:='2';
               end;
          end;
     readarrowkey:=key;
end;
{-------------------------------------------------------------------------}
procedure DRAWPICTUREBYLINE(beginx,beginy:integer;dosname:stringtype);

{dosname            =    name of the file, including extention
beginx, beginy      =    the coordinates of where the upper left hand corner
                         of where the picture will be.}

var
     pasfile        :    text;
     row            :    integer;
     col            :    integer;
     color          :    integer;
     length         :    integer;

begin

     assign(pasfile,dosname);
     reset(pasfile);
     readln(pasfile,lineoftext);
     if(lineoftext='FORMAT=LINE')then
          begin
               row:=beginy;
               col:=beginx;
               while not eof(pasfile) do
                    begin
                         while not eoln(pasfile) do
                              begin
                                   read(pasfile,color);
                                   read(pasfile,ch);
                                   read(pasfile,length);
                                   if not eoln(pasfile) then
                                        read(pasfile,ch);
                                   setcolor(color);
                                   line(col,row,(col+length),row);
                                   col:=col + length;
                              end;
                         readln(pasfile);
                         row:=row + 1;
                         col:=beginx;
                    end;
          end;
     close(pasfile);

end;
{---------------------------------------------------------------------------}
procedure drawitem(xpos,ypos,itemnumber:integer);

var
     filename       :    stringtype;

begin
     case itemnumber of
          1:filename:='sword.pic';
          2:filename:='shield.pic';
          3:filename:='axe.pic';
          4:filename:='potion.pic';
          5:filename:='potion2.pic';
          6:filename:='potion3.pic';
          7:filename:='chain.pic';
          8:filename:='plate.pic';
          9:filename:='dagger.pic';
          10:filename:='club.pic';
          11:filename:='staff.pic';
          12:filename:='hammer.pic';
          13:filename:='magicswd.pic';
          14:filename:='magicshl.pic';
          15:filename:='flamewnd.pic';
     else
          filename:='blank.pic';
     end;{case}
     drawpicturebyline(xpos,ypos,filename);
end;
{--------------------------------------------------------------------------}
procedure prompt;

var
     origcolor      :    integer;
     backgroundcolor:    integer;

begin
     x:=getmaxx - (textwidth('press a key to continue')+5);
     y:=getmaxy - (textheight('M')+5);
     origcolor:=getcolor;
     backgroundcolor:=getpixel(x,y);
     setcolor(white);
     outtextxy(x,y,'press a key to continue');
     ch:=readarrowkey;
     setcolor(backgroundcolor);
     outtextxy(x,y,'press a key to continue');
     setcolor(origcolor);
end;
{--------------------------------------------------------------------------}
function D(dnum:integer):integer; begin d:=random(dnum)+1; end;

{The value of d(dnum) is returned as a random number between 1 and dnum.}
{--------------------------------------------------------------------------}
procedure CAPITALIZE(var capstring:stringtype);

{capstring          =    variable returned in all caps}

begin
     for loop:=1 to length(capstring) do
          capstring[loop]:=upcase(capstring[loop]);
end;
{--------------------------------------------------------------------------}
procedure gfilesloc(var gdriver,gmode:integer;gpath:string);

var
     error          :    integer;

begin
     clrscr;
     repeat
          gdriver:=detect;
          initgraph(gdriver,gmode,gpath);
          error:=graphresult;
          if(error<>grOK)then
               begin
                    writeln('Graphics error:  ',grapherrormsg(error));
                    if(error=grfilenotfound)then
                         begin
                              writeln;
                              writeln('     Cannot find graphics driver.');
                              write('     Please enter directory path for the driver:  ');
                              readln(gpath);
                              writeln;
                         end
                    else
                         halt(1);
               end;
     until(error=grOK);
end;
{--------------------------------------------------------------------------}
procedure HOMECURSOR(var x,y:integer);

begin
     x:=10;
     y:=10;
end;
{--------------------------------------------------------------------------}
procedure GWRITE(var x,y:integer;gtext:string);

begin
     outtextxy(x,y,(gtext));
     x:=x + textwidth(gtext);
end;
{--------------------------------------------------------------------------}
procedure GWRITELN(var x,y:integer;gtext:string);

begin
     outtextxy(x,y,(gtext));
     y:=y + textheight('M') + 2;
     x:=10;
end;
{--------------------------------------------------------------------------}
procedure GREAD(var x,y:integer;var gtext:stringtype);

var
     lastletter     :    integer;
     theletter      :    char;
     forecolor      :    word;

begin
     forecolor:=getcolor;
     gtext:='';
     repeat
          ch:=readkey;
          if(ch<>#13)then
               begin
                    if(ch<>#8)then
                         begin
                              gtext:=gtext + ch;
                              gwrite(x,y,ch);
                         end
                    else
                         if(gtext<>'')then
                              begin
                                   lastletter:=length(gtext);
                                   theletter:=gtext[lastletter];
                                   delete(gtext,lastletter,1);
                                   x:=x - textwidth(theletter);
                                   setcolor(getbkcolor);
                                   gwrite(x,y,theletter);
                                   x:=x - textwidth(theletter);
                                   setcolor(forecolor);
                              end;
               end;
     until(ch=#13);
end;
{--------------------------------------------------------------------------}
procedure titlescreen;

begin
     settextstyle(gothic,horizontal,6);
     setcolor(lightblue);
     outtextxy(145,383,'The Ice Queen');
     setcolor(white);
     outtextxy(142,380,'The Ice Queen');
     settextstyle(default,horizontal,2);
     drawpicturebyline(120,10,'tcastle.pic');
     settextstyle(default,horizontal,1);
     setcolor(lightgray);
     outtextxy(160,375,'demo version, (c) 1996 Angelo Bertolli');
     prompt;
end;
{--------------------------------------------------------------------------}
procedure writefile(beginy:integer;dosname:stringtype);

var
     pasfile        :    text;
     numlines       :    integer;

begin
     x:=10;
     y:=beginy;
     numlines:=(getmaxy+1-y) DIV (textheight('M')+2) - 1;
     assign(pasfile,dosname);
     reset(pasfile);
     while not eof(pasfile) do
          begin
               readln(pasfile,lineoftext);
               gwriteln(x,y,lineoftext);
               numlines:=numlines - 1;
               if(numlines=0)then
                    begin
                         prompt;
                         cleardevice;
                         homecursor(x,y);
                         numlines:=(getmaxy+1-y) DIV (textheight('M')+2) - 1;
                    end;
          end;
     close(pasfile);
end;
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
{---------------------------------------------------------------------------}
function midscreen(thestring:stringtype) :    integer;

begin
     midscreen:=320 - (textwidth(thestring) DIV 2);
end;
{---------------------------------------------------------------------------}
function rightmargin(thestring:stringtype) :    integer;

begin
     rightmargin:=420 - textwidth(thestring);
end;
{--------------------------------------------------------------------------}
procedure midwrite(var x,y:integer;gstring:stringtype);

begin
     x:=midscreen(gstring);
     gwrite(x,y,gstring);
end;
{--------------------------------------------------------------------------}
procedure midwriteln(var x,y:integer;gstring:stringtype);

begin
     x:=midscreen(gstring);
     gwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure died;

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
{---------------------------------------------------------------------------}
procedure printrules(printport:stringtype);

var
     numlines       :    integer;
     pasfile        :    text;
     printer        :    text;

begin
     assign(pasfile,'text002.scr');
     reset(pasfile);
     assign(printer,printport);
     rewrite(printer);
     numlines:=58;
     While NOT EOF(pasfile) DO
          begin
               readln(pasfile,lineoftext);
               writeln(printer,lineoftext);
               numlines:=numlines - 1;
               if (numlines=0) then
                    begin
                         numlines:=58;
                         writeln(printer,#12);
                    end;
          end;
     close(pasfile);
     writeln(printer,#12);
     close(printer);
end;
{---------------------------------------------------------------------------}
procedure introduction;

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(sanseri,horizontal,2);
     setcolor(lightblue);
     writefile(y,'text001.scr');
     prompt;
end;
{---------------------------------------------------------------------------}
procedure rules;

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(sanseri,horizontal,2);
     setcolor(cyan);
     writefile(y,'text002.scr');
     prompt;
     cleardevice;
     setcolor(lightcyan);
     settextstyle(default,horizontal,2);
     outtextxy(1,200,'     Print out these rules?  (Y/N)');
     repeat
          ch:=readarrowkey;
     until(ch in ['y','Y','n','N']);
     if (ch in ['y','Y']) then
          printrules(printport);
end;
{---------------------------------------------------------------------------}
procedure credits;

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(sanseri,horizontal,2);
     setcolor(magenta);
     writefile(y,'text003.scr');
     prompt;
end;
{---------------------------------------------------------------------------}
procedure menuscreen;

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(triplex,horizontal,5);
     setcolor(lightgray);
     gwriteln(x,y,'       Game Options');
     gwriteln(x,y,'');
     settextstyle(default,horizontal,1);
     setcolor(lightmagenta);
     gwriteln(x,y,'                        Press enter for selection');
     settextstyle(default,horizontal,3);
end;
{---------------------------------------------------------------------------}
procedure startgame(var player:recordtype);

begin
     settextstyle(default,horizontal,2);
     repeat
          cleardevice;
          homecursor(x,y);
          setcolor(blue);
          gwriteln(x,y,'         CREATE YOUR CHARACTER');
          gwriteln(x,y,'');
          setcolor(white);
          with player do
               begin
                    gwrite(x,y,'Enter name:  ');
                    gread(x,y,tempstring);
                    name:=tempstring;
                    if (name='') then
                         begin
                              gwrite(x,y,'Landon');
                              name:='Landon';
                         end;
                    gwriteln(x,y,'');
                    gwriteln(x,y,'');
                    gwrite(x,y,'Sex (M/F)  ');
                    repeat
                         sex:=readkey;
                    until (sex in ['m','M','f','F']);
                    outtextxy(x,y,sex);
                    endurancemax:=d(10)+8;
                    combatskill:=d(10)+8;
                    luck:=d(10)+8;
                    gwriteln(x,y,'');
                    gwriteln(x,y,'');
                    str(endurancemax,tempstring);
                    tempstring:='   Endurance:  ' + tempstring;
                    gwriteln(x,y,tempstring);
                    endurance:=endurancemax;
                    str(combatskill,tempstring);
                    tempstring:='Combat Skill:  ' + tempstring;
                    gwriteln(x,y,tempstring);
                    str(luck,tempstring);
                    tempstring:='        Luck:  ' + tempstring;
                    gwriteln(x,y,tempstring);
                    if (sex in ['m','M']) then
                         picfile:='mplayer.pic'
                    else
                         picfile:='fplayer.pic';
                    coins:=(d(6)+12) * 10;
                    numitems:=0;
                    numskills:=0;
               end;
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          gwriteln(x,y,'          Keep this character (Y/N)');
          repeat
               ans:=readkey;
          until(ans in ['y','Y','n','N']);
     until (ans in ['y','Y']);

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
procedure dropitem(var player:recordtype);

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
                    for loop2:=1 to numitems do
                         begin
                              str(loop2,tempstring);
                              tempstring:=tempstring + '. ' + itemstring(item[loop2]);
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
                              for loop2:=tempinteger to numitems do
                                   if (loop2<>numitems) then
                                        item[loop2]:=item[loop2 + 1];
                              numitems:=numitems - 1;
                         end;
               end;
end;
{---------------------------------------------------------------------------}
procedure calccombat(var player:recordtype);

begin
     with player do
          begin
               attack:=0;
               defense:=0;
               tempset:=[];
               for loop2:=1 to numitems do
                    tempset:=tempset + [item[loop2]];
               if (15 in tempset) then
                    attack:=60
               else
                    if (13 in tempset) then
                         attack:=32
                    else
                         if (1 in tempset) then
                              attack:=18
                         else
                              if (3 in tempset) then
                                    attack:=16
                              else
                                   if (12 in tempset) then
                                        attack:=12
                                   else
                                        if (11 in tempset) then
                                             attack:=8
                                        else
                                             if (9 in tempset) then
                                                  attack:=6
                                             else
                                                  if (10 in tempset) then
                                                       attack:=4;
               if (8 in tempset) then
                    defense:=20
               else
                    if (7 in tempset) then
                         defense:=12;
               if (14 in tempset) then
                    defense:=defense + 32
               else
                    if (2 in tempset) then
                         defense:=defense + 8;
               attack:=attack + combatskill;
               defense:=defense + (combatskill DIV 4);
          end;
end;
{---------------------------------------------------------------------------}
procedure viewstats(var player:recordtype);

var
     tempstring2    :    stringtype;

begin
     repeat
          cleardevice;
          calccombat(player);
          with player do
                    begin
                         x:=260;
                         y:=50;
                         drawpicturebyline(x,y,picfile);
                         setcolor(white);
                         settextstyle(sanseri,horizontal,2);
                         y:=150;
                         gwriteln(x,y,'');
                         midwriteln(x,y,name);
                         y:=y + 5;
                         settextstyle(default,horizontal,1);
                         gwriteln(x,y,'');
                         midwrite(x,y,'Endurance: ');
                         str(endurance,tempstring);
                         str(endurancemax,tempstring2);
                         tempstring:=tempstring + '/' + tempstring2;
                         x:=rightmargin(tempstring);
                         gwriteln(x,y,tempstring);
                         midwrite(x,y,'Combat Skill: ');
                         str(combatskill,tempstring);
                         x:=rightmargin(tempstring);
                         gwriteln(x,y,tempstring);
                         midwrite(x,y,'Luck: ');
                         str(luck,tempstring);
                         x:=rightmargin(tempstring);
                         gwriteln(x,y,tempstring);
                         midwrite(x,y,'Gender: ');
                         tempstring:=sex;
                         x:=rightmargin(tempstring);
                         gwriteln(x,y,tempstring);
                         midwrite(x,y,'Attack: ');
                         str(attack,tempstring);
                         x:=rightmargin(tempstring);
                         gwriteln(x,y,tempstring);
                         midwrite(x,y,'Defense: ');
                         str(defense,tempstring);
                         x:=rightmargin(tempstring);
                         gwriteln(x,y,tempstring);
                         midwrite(x,y,'Coins: ');
                         str(coins,tempstring);
                         x:=rightmargin(tempstring);
                         gwriteln(x,y,tempstring);

                         if (numitems>0) then
                              begin
                                   setcolor(lightblue);
                                   midwriteln(x,y,'* * ITEMS * *');
                                   setcolor(white);
                              end;
                         for loop2:=1 to numitems do
                              begin
                                   tempstring:=itemstring(item[loop2]);
                                   midwriteln(x,y,tempstring);
                              end;
                         if (numskills>0) then
                              begin
                                   setcolor(lightblue);
                                   midwriteln(x,y,'* * SKILLS * *');
                                   setcolor(white);
                              end;
                         for loop2:=1 to numskills do
                              begin
                                   tempstring:=skillstring(skill[loop2]);
                                   midwriteln(x,y,tempstring);
                              end;
                    end;
          setcolor(lightgreen);
          settextstyle(triplex,horizontal,3);
          y:=1;
          midwriteln(x,y,'(D)rop or (E)xit');
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
procedure buyequipment(var player:recordtype);

var
     theitem        :    integer;
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
                    outtextxy(120,170,'   20 coins');
                    outtextxy(120,260,'(2) SHIELD');
                    outtextxy(120,270,'   24 coins');
                    outtextxy(120,360,'(3) AXE');
                    outtextxy(120,370,'   18 coins');
                    outtextxy(270,160,'(4) CHAIN MAIL');
                    outtextxy(270,170,'   44 coins');
                    outtextxy(270,260,'(5) PLATE MAIL');
                    outtextxy(270,270,'   56 coins');
                    outtextxy(270,360,'(6) DAGGER');
                    outtextxy(270,370,'   8 coins');
                    outtextxy(420,160,'(7) CLUB');
                    outtextxy(420,170,'   6 coins');
                    outtextxy(420,260,'(8) STAFF');
                    outtextxy(420,270,'   10 coins');
                    outtextxy(420,360,'(9) HAMMER OF WAR');
                    outtextxy(420,370,'   16 coins');
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
                                  theitem:=1;
                                  price:=20;
                             end;
                         '2':begin
                                  theitem:=2;
                                  price:=24;
                             end;
                         '3':begin
                                  theitem:=3;
                                  price:=18;
                             end;
                         '4':begin
                                  theitem:=7;
                                  price:=44;
                             end;
                         '5':begin
                                  theitem:=8;
                                  price:=56;
                             end;
                         '6':begin
                                  theitem:=9;
                                  price:=8;
                             end;
                         '7':begin
                                  theitem:=10;
                                  price:=6;
                             end;
                         '8':begin
                                  theitem:=11;
                                  price:=10;
                             end;
                         '9':begin
                                  theitem:=12;
                                  price:=16;
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
procedure sellequipment(var player:recordtype);

var
     price          :    integer;

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
                    for loop2:=1 to numitems do
                         begin
                              str(loop2,tempstring);
                              tempstring:=tempstring + '. ' + itemstring(item[loop2]);
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
                         1:price:=10;
                         2:price:=12;
                         3:price:=9;
                         4:price:=10;
                         5:price:=20;
                         6:price:=40;
                         7:price:=22;
                         8:price:=28;
                         9:price:=4;
                        10:price:=3;
                        11:price:=5;
                        12:price:=8;
                        13:price:=423;
                        14:price:=436;
                        15:price:=617;
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
                              for loop2:=tempinteger to numitems do
                                   if (loop2<>numitems) then
                                        item[loop2]:=item[loop2 + 1];
                              numitems:=numitems - 1;
                              coins:=coins + price;
                         end;
               end;
end;
{---------------------------------------------------------------------------}
procedure weaponshop(var player:recordtype);

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
          drawitem(150,100,1);
          drawitem(150,200,2);
          drawitem(150,300,3);
          drawitem(300,100,7);
          drawitem(300,200,8);
          drawitem(300,300,9);
          drawitem(450,100,10);
          drawitem(450,200,11);
          drawitem(450,300,12);
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
procedure useitem(var player:recordtype);

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
                    for loop2:=1 to numitems do
                         begin
                              str(loop2,tempstring);
                              tempstring:=tempstring + '. ' + itemstring(item[loop2]);
                              gwriteln(x,y,tempstring);
                         end;
                    gwriteln(x,y,'Use which one?');
                    str(numitems,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    gwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    if not(item[tempinteger] in [4,5,6]) then
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
                                             4:writefile(1,'text004.scr');
                                             5:begin
                                                    writefile(1,'text005.scr');
                                                    endurance:=endurance + d(6)+4;
                                                    if (endurance>endurancemax) then
                                                         endurance:=endurancemax;
                                               end;
                                             6:begin
                                                    writefile(1,'text006.scr');
                                                    endurance:=endurancemax;
                                               end;
                                        end;{case}
                                        for loop2:=tempinteger to numitems do
                                             if (loop2<>numitems) then
                                                  item[loop2]:=item[loop2 + 1];
                                        numitems:=numitems - 1;
                                   end;
                         end;
                    settextstyle(default,horizontal,2);
                    prompt;
               end;
end;
{---------------------------------------------------------------------------}
procedure magicbuyequipment(var player:recordtype);

var
     theitem        :    integer;
     price          :    integer;

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
                    outtextxy(120,160,'(1) BLUE POTION');
                    outtextxy(120,170,'   20 coins');
                    outtextxy(120,260,'(2) RED POTION');
                    outtextxy(120,270,'   40 coins');
                    outtextxy(120,360,'(3) GREEN POTION');
                    outtextxy(120,370,'   80 coins');
                    settextstyle(sanseri,horizontal,2);
                    setcolor(red);
                    x:=10;
                    y:=420;
                    gwrite(x,y,'Which item:  ');
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['1'..'3']);
                    case ans of
                         '1':begin
                                  theitem:=4;
                                  price:=20;
                             end;
                         '2':begin
                                  theitem:=5;
                                  price:=40;
                             end;
                         '3':begin
                                  theitem:=6;
                                  price:=80;
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
procedure learnskill(var player:recordtype);

var
     theskill       :    integer;
     price          :    integer;
     present        :    boolean;

begin
     setcolor(black);
     settextstyle(triplex,horizontal,3);
     outtextxy(10,420,'            (B)uy, (S)ell, (L)earn or (E)xit');
     setcolor(white);
     with player do
          if (numskills=skillmax) then
               begin
                    setcolor(lightgray);
                    outtextxy(10,420,'      Sorry, you can''t learn any more skills.');
                    settextstyle(default,horizontal,2);
                    prompt;
               end
          else
               begin
                    settextstyle(default,horizontal,1);
                    outtextxy(360,240,'(1) CALL WILD');
                    outtextxy(360,250,'   136 coins');
                    outtextxy(360,270,'(2) COURAGE');
                    outtextxy(360,280,'   176 coins');
                    outtextxy(360,300,'(3) ICICLE');
                    outtextxy(360,310,'   300 coins');
                    outtextxy(360,330,'(4) HEAL');
                    outtextxy(360,340,'   432 coins');
                    outtextxy(360,360,'(5) FIRE BLAST');
                    outtextxy(360,370,'   612 coins');
                    settextstyle(sanseri,horizontal,2);
                    setcolor(red);
                    x:=10;
                    y:=420;
                    gwrite(x,y,'Which skill:  ');
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['1'..'5']);
                    case ans of
                         '1':begin
                                  theskill:=4;
                                  price:=136;
                             end;
                         '2':begin
                                  theskill:=6;
                                  price:=176;
                             end;
                         '3':begin
                                  theskill:=9;
                                  price:=300;
                             end;
                         '4':begin
                                  theskill:=5;
                                  price:=432;
                             end;
                         '5':begin
                                  theskill:=2;
                                  price:=612;
                             end;
                    end;{case}
                    gwrite(x,y,skillstring(theskill));
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
                              for loop:=1 to numskills do
                                   if (skill[loop]=theskill) then
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
                                        numskills:=numskills + 1;
                                        skill[numskills]:=theskill;
                                        coins:=coins - price;
                                   end;
                         end;
               end;
end;
{----------------------------------------------------------------------------}
procedure magicshop(var player:recordtype);

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
          drawpicturebyline(20,280,'wizard.pic');
          drawitem(150,100,4);
          drawitem(150,200,5);
          drawitem(150,300,6);
          drawpicturebyline(320,100,'skilbook.pic');
          repeat
               ans:=readarrowkey;
          until (ans in ['e','E','b','B','s','S','l','L']);
          case ans of
               'e','E':exit;
               'b','B':magicbuyequipment(player);
               's','S':sellequipment(player);
               'l','L':learnskill(player);
          end;
     until FALSE;
end;
{---------------------------------------------------------------------------}
procedure useskill(var player:recordtype;wild,dungeon:boolean);

begin
     cleardevice;
     homecursor(x,y);
     settextstyle(sanseri,horizontal,3);
     with player do
          if (numskills=0) then
               begin
                    cleardevice;
                    settextstyle(sanseri,horizontal,5);
                    outtextxy(150,150,'You have no skills');
                    settextstyle(default,horizontal,2);
                    prompt;
               end;
     with player do
          if (numskills>0) then
               begin
                    setcolor(lightblue);
                    gwriteln(x,y,'   SKILLS');
                    setcolor(white);
                    for loop2:=1 to numskills do
                         begin
                              str(loop2,tempstring);
                              tempstring:=tempstring + '. ' + skillstring(skill[loop2]);
                              gwriteln(x,y,tempstring);
                         end;
                    gwriteln(x,y,'Use which one?');
                    str(numskills,tempstring);
                    repeat
                         ans:=readarrowkey;
                    until (ans in ['1'..tempstring[1]]);
                    gwriteln(x,y,'');
                    val(ans,tempinteger,tempcode);
                    tempstring:=skillstring(skill[tempinteger]);
                    gwrite(x,y,'Use ');
                    gwrite(x,y,tempstring);
                    gwriteln(x,y,'? (y/n)');
                    repeat
                         ans:=readarrowkey;
                    until(ans in ['y','Y','n','N']);
                    if (ans in ['y','Y']) then
                         begin
                              setcolor(green);
                              cleardevice;
                              settextstyle(sanseri,horizontal,2);
                              case skill[tempinteger] of
                                   1,2,3,6,7,9,12:begin
                                                       settextstyle(sanseri,horizontal,4);
                                                       outtextxy(120,180,'That''s a battle-time spell');
                                                       settextstyle(default,horizontal,2);
                                                  end;
                                   4:if wild then
                                          writefile(1,'text024.scr')
                                     else
                                          if dungeon then
                                               writefile(1,'text025.scr')
                                          else
                                               writefile(1,'text007.scr');
                                   5:begin
                                          writefile(1,'text008.scr');
                                          endurance:=endurance + d(6);
                                          if (endurance>endurancemax) then
                                               endurance:=endurancemax;
                                     end;
                                   8:writefile(1,'text026.scr');
                                  10:case d(8) of
                                          1:begin
                                                 writefile(1,'text009.scr');
                                                 endurance:=endurance + d(2);
                                                 if (endurance>endurancemax) then
                                                      endurance:=endurancemax;
                                            end;
                                          2:begin
                                                 writefile(1,'text010.scr');
                                                 endurance:=endurance - d(2);
                                                 if (endurance<=0) then
                                                      died;
                                            end;
                                          3:if wild then
                                                 writefile(1,'text023.scr')
                                            else
                                                 writefile(1,'text011.scr');
                                          4:writefile(1,'text012.scr');
                                          5,6,7,8:writefile(1,'text013.scr');
                                     end;{case}
                                  11:writefile(1,'text014.scr');
                              end;{case}
                         end;
                    prompt;
               end;

end;
{---------------------------------------------------------------------------}
procedure clearpub;

begin
     setfillstyle(solidfill,black);
     bar(1,120,640,480);
end;
{---------------------------------------------------------------------------}
procedure buydrink(var coins:integer);

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
     if (coins<2) then
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
               coins:=coins - 2;
               settextstyle(default,horizontal,2);
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure skulldice(var player:recordtype);

var
     blackdice      :    integer;
     whitedice      :    integer;
     skulldice      :    integer;
     thepicture     :    stringtype;
     present        :    boolean;

begin
     outtextxy(1,180,'  It will cost 5 coins to play a game of Skull Dice');
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
          if (coins<5) then
               begin
                    setcolor(lightred);
                    broke;
               end
          else
               begin
                    coins:=coins - 5;
                    blackdice:=0;
                    whitedice:=0;
                    skulldice:=0;
                    for loop:=1 to 4 do
                         begin
                              case d(6) of
                                   1:begin
                                          blackdice:=blackdice + 1;
                                          thepicture:='blackdie.pic';
                                     end;
                                   2,3:begin
                                            whitedice:=whitedice + 1;
                                            thepicture:='whitedie.pic';
                                       end;
                                   4,5,6:begin
                                              skulldice:=skulldice + 1;
                                              thepicture:='skulldie.pic';
                                         end;
                              end;{case}
                              drawpicturebyline(loop*115,240,thepicture);
                         end;
                    x:=10;
                    y:=300;
                    setcolor(yellow);
                    if (skulldice=4) then
                         begin
                              gwriteln(x,y,'"Ha, ha!  You lose!  And now the game begins,"  with');
                              gwriteln(x,y,'that Ronald pulls out his french fry wand.  You quickly');
                              gwriteln(x,y,'dodge his attacks.  Then, Ronald just obliterates you.');
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
                                        if (numskills=skillmax) then
                                             gwriteln(x,y,'       Too bad you can''t learn anymore skills.')
                                        else
                                             begin
                                                  present:=false;
                                                  for loop:=1 to numskills do
                                                       if (skill[loop]=8) then
                                                            present:=true;
                                                  if (present) then
                                                       gwriteln(x,y,'    But you already know how to obliterate things.')
                                                  else
                                                       begin
                                                            numskills:=numskills + 1;
                                                            skill[numskills]:=8;
                                                       end;
                                             end;
                                   end
                              else
                                   if (whitedice=4) then
                                        begin
                                             gwriteln(x,y,'"You are the proud winner of a fine green potion."');
                                             if (numitems=itemmax) then
                                                  gwriteln(x,y,'You must decline since you cannot carry anymore.')
                                             else
                                                  begin
                                                       numitems:=numitems + 1;
                                                       item[numitems]:=6;
                                                  end;
                                        end
                                   else
                                        if (blackdice=3) then
                                             begin
                                                  gwriteln(x,y,'"Great!  Here''s a red potion with your name on it."');
                                                  if (numitems=itemmax) then
                                                       gwriteln(x,y,'You must decline since you cannot carry anymore.')
                                                  else
                                                       begin
                                                            numitems:=numitems + 1;
                                                            item[numitems]:=5;
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
                                                                 item[numitems]:=4;
                                                            end;
                                                  end
                                             else
                                                  gwriteln(x,y,'                "Sorry, no prize."');
                    settextstyle(default,horizontal,2);
                    prompt;
               end;
end;
{---------------------------------------------------------------------------}
procedure tip(var coins:integer);

begin
     if (coins<1) then
          begin
               setcolor(lightred);
               broke;
          end
     else
          begin
               coins:=coins - 1;
               outtextxy(1,140,'You toss Ronald a coin and he tells you:  ');
               case d(8) of
                    1:writefile(240,'text015.scr');
                    2:writefile(240,'text016.scr');
                    3:writefile(240,'text017.scr');
                    4:writefile(240,'text018.scr');
                    5:writefile(240,'text019.scr');
                    6:writefile(240,'text020.scr');
                    7:writefile(240,'text021.scr');
                    8:writefile(240,'text022.scr');
               end;
               settextstyle(default,horizontal,2);
               prompt;
          end;
end;
{---------------------------------------------------------------------------}
procedure pub(var player:recordtype);

var
     password    :    stringtype;

begin
     cleardevice;
     drawpicturebyline(2,1,'pub.pic');
     drawpicturebyline(40,160,'dwarf.pic');
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
     capitalize(password);
     setcolor(magenta);
     if not(password='CRYSTAL SHARD') then
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
                    drawpicturebyline(240,140,'ronald.pic');
                    homecursor(x,y);
                    settextstyle(sanseri,horizontal,3);
                    setcolor(lightmagenta);
                    outtextxy(1,280,'      "So, what''ll it be," asks Ronald McDonald');
                    settextstyle(triplex,horizontal,3);
                    setcolor(lightmagenta);
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
procedure inn(var player:recordtype);

begin
     cleardevice;
     settextstyle(gothic,horizontal,5);
     homecursor(x,y);
     setcolor(darkgray);
     outtextxy(x+1,y+1,'     The Eagle Talon Inn');
     setcolor(cyan);
     outtextxy(x,y,'     The Eagle Talon Inn');
     drawpicturebyline(420,120,'innkeep.pic');
     settextstyle(sanseri,horizontal,3);
     setcolor(lightblue);
     outtextxy(1,160,'    "We charge 5 coins a night."');
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
               if (coins<5) then
                    begin
                         setcolor(yellow);
                         broke;
                    end
               else
                    begin
                         y:=320;
                         setcolor(cyan);
                         coins:=coins - 5;
                         gwriteln(x,y,' You sleep the night and your endurance is restored.');
                         endurance:=endurancemax;
                         settextstyle(default,horizontal,2);
                         prompt;
                    end;
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
          1:filename:='town.pic';
          2:filename:='cave.pic';
          3:filename:='grass.pic';
          4:filename:='hill.pic';
          5:filename:='mountain.pic';
          6:filename:='road.pic';
          7:filename:='swamp.pic';
          8:filename:='desert.pic';
          9:filename:='whitemt.pic';
          10:filename:='castle.pic';
          11:filename:='snow.pic';
          12:filename:='inn.pic';
          13:filename:='dgt.pic';
          14:filename:='dww.pic';
          15:filename:='dnw.pic';
          16:filename:='dew.pic';
          17:filename:='dsw.pic';
          18:filename:='dnwc.pic';
          19:filename:='dnsw.pic';
          20:filename:='dsec.pic';
          21:filename:='dnec.pic';
          22:filename:='dswc.pic';
          23:filename:='deww.pic';
          24:filename:='dna.pic';
          25:filename:='dea.pic';
          26:filename:='dwa.pic';
          27:filename:='dsa.pic';
     else
          filename:='blank.pic';
     end;
     drawpicturebyline(xpix,ypix,filename);
end;
{---------------------------------------------------------------------------}
procedure drawmap(themap:matrix);

begin
     for row:=1 to rowmax do
          for col:=1 to colmax do
               drawmaptile(col,row,themap);
end;
{---------------------------------------------------------------------------}
procedure drawplayer(xpos,ypos:integer);

var
     xpix           :    integer;
     ypix           :    integer;

begin
     xpix:=41;
     ypix:=41;
     xpix:=xpix + ((xpos - 1) * 20);
     ypix:=ypix + ((ypos - 1) * 20);
     drawpicturebyline(xpix,ypix,'chartile.pic');
end;
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
procedure writestats(player:recordtype);

var
     thestring        :    stringtype;

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
                         gwriteln(x,y,'ITEMS');
                         for loop:=1 to numitems do
                              begin
                                   x:=midstats(itemstring(item[loop]));
                                   gwriteln(x,y,itemstring(item[loop]));
                              end;
                    end
               else
                    begin
                         x:=midstats('No Items');
                         gwriteln(x,y,'No Items');
                    end;
               gwriteln(x,y,'');
               if (numskills>0) then
                    begin
                         x:=midstats('SKILLS');
                         gwriteln(x,y,'SKILLS');
                         for loop:=1 to numskills do
                              begin
                                   x:=midstats(skillstring(skill[loop]));
                                   gwriteln(x,y,skillstring(skill[loop]));
                              end;
                    end
               else
                    begin
                         x:=midstats('No Skills');
                         gwriteln(x,y,'No Skills');
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

begin
     x:=45;
     if (y>440) or (y<365) then
          homemessage(x,y);
     outtextxy(x,y,(gtext));
     y:=y + textheight('M') + 2;
end;
{--------------------------------------------------------------------------}
procedure messagefile(dosname:stringtype);

{Each line can be 34 characters long (default font, size 2)}

var
     pasfile        :    text;
     numlines       :    integer;

begin
     y:=365;
     numlines:=78 DIV (textheight('M')+2);
     assign(pasfile,dosname);
     reset(pasfile);
     while not eof(pasfile) do
          begin
               readln(pasfile,lineoftext);
               x:=45;
               gwriteln(x,y,lineoftext);
               numlines:=numlines - 1;
               if(numlines=0)then
                    begin
                         prompt;
                         clearmessage;
                         y:=365;
                         numlines:=78 DIV (textheight('M')+2);
                    end;
          end;
     close(pasfile);
end;
{---------------------------------------------------------------------------}
procedure monsterfile(dosname2:stringtype;var themonster:recordtype);

var
     pasfile2       :    text;
     random         :    boolean;
     rollnum        :    integer;
     dienum         :    integer;
     bonus          :    integer;
     aloop          :    integer;

begin
     assign(pasfile2,dosname2);
     reset(pasfile2);
     readln(pasfile2,lineoftext);
     random:=(lineoftext='RANDOM');
     with themonster do
          begin
               numitems:=0;
               sex:=' ';
               combatskill:=0;
               readln(pasfile2,name);
               readln(pasfile2,picfile);
               if random then
                    begin
                         endurancemax:=0;
                         read(pasfile2,rollnum);
                         read(pasfile2,ch);
                         read(pasfile2,dienum);
                         read(pasfile2,ch);
                         readln(pasfile2,bonus);
                         for aloop:=1 to rollnum do
                              endurancemax:=endurancemax + d(dienum);
                         endurancemax:=endurancemax + bonus;
                    end
               else
                    readln(pasfile2,endurancemax);
               endurance:=endurancemax;
               if random then
                    begin
                         attack:=0;
                         read(pasfile2,rollnum);
                         read(pasfile2,ch);
                         read(pasfile2,dienum);
                         read(pasfile2,ch);
                         readln(pasfile2,bonus);
                         for aloop:=1 to rollnum do
                              attack:=attack + d(dienum);
                         attack:=attack + bonus;
                    end
               else
                    readln(pasfile2,attack);
               if random then
                    begin
                         defense:=0;
                         read(pasfile2,rollnum);
                         read(pasfile2,ch);
                         read(pasfile2,dienum);
                         read(pasfile2,ch);
                         readln(pasfile2,bonus);
                         for aloop:=1 to rollnum do
                              defense:=defense + d(dienum);
                         defense:=defense + bonus;
                    end
               else
                    readln(pasfile2,defense);
               if random then
                    begin
                         luck:=0;
                         read(pasfile2,rollnum);
                         read(pasfile2,ch);
                         read(pasfile2,dienum);
                         read(pasfile2,ch);
                         readln(pasfile2,bonus);
                         for aloop:=1 to rollnum do
                              luck:=luck + d(dienum);
                         luck:=luck + bonus;
                    end
               else
                    readln(pasfile2,luck);
               if random then
                    begin
                         coins:=0;
                         read(pasfile2,rollnum);
                         read(pasfile2,ch);
                         read(pasfile2,dienum);
                         read(pasfile2,ch);
                         readln(pasfile2,bonus);
                         for aloop:=1 to rollnum do
                              coins:=coins + d(dienum);
                         coins:=coins + bonus;
                    end
               else
                    readln(pasfile2,coins);

               readln(pasfile2,numskills);
               for aloop:=1 to numskills do
                    readln(pasfile2,skill[aloop]);
          end;
     close(pasfile2);
end;
{---------------------------------------------------------------------------}
procedure getmonsters(dosname:stringtype;var nummonsters:integer;
var monster:monsterlist);

var
     pasfile        :    text;
     thefile        :    stringtype;

begin
     assign(pasfile,dosname);
     reset(pasfile);
     readln(pasfile,nummonsters);
     for loop:=1 to nummonsters do
          begin
               readln(pasfile,thefile);
               monsterfile(thefile,monster[loop]);
          end;
     close(pasfile);
end;
{---------------------------------------------------------------------------}
procedure randommonsters(var nummonsters:integer;var monster:monsterlist);

var
     thefile        :    stringtype;
     category       :    integer;
     theroll        :    integer;

begin
     nummonsters:=d(4);
     if (d(100)<=25) then
          nummonsters:=nummonsters + d(4);
     theroll:=d(36);
     case theroll of
           1..3:thefile:='wolf.dat';
           4..5:thefile:='ant.dat';
           6..8:thefile:='rat.dat';
          9..11:thefile:='bat.dat';
         12..13:thefile:='baboon.dat';
             14:thefile:='slime.dat';
             15:thefile:='ooze.dat';
         16..17:thefile:='bugbear.dat';
         18..20:thefile:='kobold.dat';
         21..22:thefile:='orc.dat';
             23:thefile:='troll.dat';
         24..25:thefile:='goblin.dat';
         26..27:thefile:='ogre.dat';
         28..29:thefile:='werewolf.dat';
             30:thefile:='gargoyle.dat';
         31..32:thefile:='ghoul.dat';
             33:thefile:='shadow.dat';
         34..36:thefile:='skeleton.dat';
     end;{case}
     case theroll of
           1..13:category:=1;
          14..15:category:=2;
          16..27:category:=3;
          28..29:category:=4;
              30:category:=5;
          31..36:category:=6;
     end;{case}
     if (nummonsters<=4) then
          for loop:=1 to nummonsters do
               monsterfile(thefile,monster[loop])
     else
          begin
               for loop:=1 to 4 do
                    monsterfile(thefile,monster[loop]);
               case category of
                    1:case d(5) of
                           1:thefile:='wolf.dat';
                           2:thefile:='ant.dat';
                           3:thefile:='rat.dat';
                           4:thefile:='bat.dat';
                           5:thefile:='baboon.dat';
                      end;{case}
                    2:case d(2) of
                           1:thefile:='slime.dat';
                           2:thefile:='ooze.dat';
                      end;{case}
                    3:case d(6) of
                           1:thefile:='bugbear.dat';
                           2:thefile:='kobold.dat';
                           3:thefile:='orc.dat';
                           4:thefile:='troll.dat';
                           5:thefile:='goblin.dat';
                           6:thefile:='ogre.dat';
                      end;{case}
                    4:thefile:='werewolf.dat';
                    5:thefile:='gargoyle.dat';
                    6:case d(3) of
                           1:thefile:='ghoul.dat';
                           2:thefile:='shadow.dat';
                           3:thefile:='skeleton.dat';
                      end;{case}
               end;{case}
               for loop:=5 to nummonsters do
                    monsterfile(thefile,monster[loop]);
          end;
end;
{---------------------------------------------------------------------------}
procedure savegame(stages:intset;player:recordtype);

var
     dosname        :    stringtype;
     pasfile        :    text;
     astage         :    integer;
     goahead        :    boolean;

begin
     goahead:=false;
     cleardevice;
     homecursor(x,y);
     setcolor(lightgray);
     settextstyle(sanseri,horizontal,4);
     gwrite(x,y,'Enter Save File Name: ');
     setcolor(lightblue);
     gread(x,y,dosname);
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     setcolor(lightgray);
     if exist(dosname) then
          begin
               midwriteln(x,y,'File exists.');
               midwriteln(x,y,'Overwrite? (y/n)');
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
               writeln(pasfile,'COTW SAVEGAME');
               for astage:=0 to 99 do
                    if (astage in stages) then
                         begin
                              write(pasfile,' ');
                              write(pasfile,astage);
                         end;
               writeln(pasfile);
               with player do
                    begin
                         writeln(pasfile,name);
                         writeln(pasfile,picfile);
                         writeln(pasfile,endurance);
                         writeln(pasfile,endurancemax);
                         writeln(pasfile,combatskill);
                         writeln(pasfile,sex);
                         writeln(pasfile,luck);
                         writeln(pasfile,coins);
                         writeln(pasfile,numitems);
                         for loop:=1 to numitems do
                              writeln(pasfile,item[loop]);
                         writeln(pasfile,numskills);
                         for loop:=1 to numskills do
                              writeln(pasfile,skill[loop]);
                    end;
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               midwriteln(x,y,'Saved.');
               settextstyle(default,horizontal,2);
               prompt;
               close(pasfile);
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
     gwrite(x,y,'            S');
     setcolor(lightblue);
     gwriteln(x,y,'pecial Ability');
     gwriteln(x,y,'');
     setcolor(lightcyan);
     gwrite(x,y,'            L');
     setcolor(lightblue);
     gwriteln(x,y,'eave Town');
     gwriteln(x,y,'');
     gwrite(x,y,'            Save ');
     setcolor(lightcyan);
     gwrite(x,y,'G');
     setcolor(lightblue);
     gwriteln(x,y,'ame');
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
      's','S':useskill(player,false,false);
      'l','L':begin
                   leavetown:=true;
                   exit;
              end;
      'g','G':savegame(stages,player);
      'q','Q':begin
                   closegraph;
                   halt;
              end;
     end;{case}
end;
{---------------------------------------------------------------------------}
procedure town;

var
     leavetown      :    boolean;

begin
     repeat
          cleardevice;
          drawpicturebyline(45,45,'thetown.pic');
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
{---------------------------------------------------------------------------}
procedure loadgame(var stages:intset;var player:recordtype);

var
     dosname        :    stringtype;
     done           :    boolean;
     pasfile        :    text;
     astage         :    integer;

begin
     done:=false;
     repeat
          cleardevice;
          homecursor(x,y);
          setcolor(lightgray);
          settextstyle(sanseri,horizontal,4);
          gwrite(x,y,'Enter File Name: ');
          setcolor(lightblue);
          gread(x,y,dosname);
          settextstyle(sanseri,horizontal,5);
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          setcolor(lightgray);
          if exist(dosname) then
               begin
                    midwriteln(x,y,'Loading...');
                    assign(pasfile,dosname);
                    reset(pasfile);
                    readln(pasfile,lineoftext);
                    if not(lineoftext='COTW SAVEGAME') then
                         begin
                              gwriteln(x,y,'');
                              gwriteln(x,y,'Hey, this isn''t a saved game!');
                              settextstyle(default,horizontal,2);
                              prompt;
                         end
                    else
                         begin
                              while not eoln(pasfile) do
                                   begin
                                        read(pasfile,ch);
                                        read(pasfile,astage);
                                        stages:=stages + [astage];
                                   end;
                              readln(pasfile);
                              with player do
                                   begin
                                        readln(pasfile,name);
                                        readln(pasfile,picfile);
                                        readln(pasfile,endurance);
                                        readln(pasfile,endurancemax);
                                        readln(pasfile,combatskill);
                                        readln(pasfile,sex);
                                        readln(pasfile,luck);
                                        readln(pasfile,coins);
                                        readln(pasfile,numitems);
                                        for loop:=1 to numitems do
                                             readln(pasfile,item[loop]);
                                        readln(pasfile,numskills);
                                        for loop:=1 to numskills do
                                             readln(pasfile,skill[loop]);
                                   end;
                              done:=true;
                         end;
                    close(pasfile);
               end
          else
               begin
                    setcolor(red);
                    gwriteln(x,y,'  Sorry, file does not exist.');
                    settextstyle(sanseri,horizontal,3);
                    setcolor(lightgray);
                    x:=10;
                    y:=300;
                    gwriteln(x,y,'                 (L)oad or (S)tart');
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
