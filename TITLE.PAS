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
     outtextxy(185,375,version + ' (c) 1995-2000 Angelo Bertolli');
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
     gwriteln(x,y,'       The Ice Queen');
     gwriteln(x,y,'');
     settextstyle(default,horizontal,1);
     setcolor(lightmagenta);
     gwriteln(x,y,'                                Welcome');
     gwriteln(x,y,'                       Please make your selection.');
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
                    gwriteln(x,y,'');
                    gwriteln(x,y,'');
                    str(endurancemax,tempstring);
                    if(endurancemax>=10)then
                         tempstring:='  ' + tempstring
                    else
                         tempstring:='   ' + tempstring;
                    tempstring:='   Endurance:' + tempstring;
                    gwriteln(x,y,tempstring);
                    endurance:=endurancemax;
                    gwriteln(x,y,'');
                    str(strength,tempstring);
                    if(strength>=10)then
                         tempstring:='  ' + tempstring
                    else
                         tempstring:='   ' + tempstring;
                    tempstring:='    Strength:' + tempstring;
                    gwriteln(x,y,tempstring);
                    str(dexterity,tempstring);
                    if(dexterity>=10)then
                         tempstring:='  ' + tempstring
                    else
                         tempstring:='   ' + tempstring;
                    tempstring:='   Dexterity:' + tempstring;
                    gwriteln(x,y,tempstring);
                    gwriteln(x,y,'');
                    str(coins,tempstring);
                    tempstring:='       Coins: ' + tempstring;
                    gwriteln(x,y,tempstring);
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
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          gwriteln(x,y,'          Keep this character (Y/N)');
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
          gwriteln(x,y,'[default: '+cfg.savegame+']');
          gwriteln(x,y,'');
          settextstyle(sanseri,horizontal,4);
          gwrite(x,y,'Enter File Name: ');
          setcolor(lightblue);
          gread(x,y,dosname);
          if (dosname='') then
               dosname:=cfg.savegame;
          settextstyle(sanseri,horizontal,5);
          gwriteln(x,y,'');
          gwriteln(x,y,'');
          setcolor(lightgray);
          if exist(dosname) then
               begin
                    gwriteln(x,y,'Loading...');
                    assign(pasfile,dosname);
                    reset(pasfile);
                    read(pasfile,player);
                    close(pasfile);
                    done:=true;
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
