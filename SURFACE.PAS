{Surface World Functions and Procedures}
{---------------------------------------------------------------------------}
procedure thedragon(var player:playerrecord);

var
     count     :    stage;

begin
     cleardevice;
     setcolor(red);
     settextstyle(triplex,horizontal,3);
     homecursor(x,y);
     if not(dragon in player.stages) then
          begin
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               gwriteln(x,y,'The wind blows quietly, and you get an eerie feeling');
               gwriteln(x,y,'as you enter this place.  When you look up into the');
               gwriteln(x,y,'mountains, you see that you have stumbled upon');
               gwriteln(x,y,'the cave of the great Red Dragon!');
               gwriteln(x,y,'');
               gwriteln(x,y,'It''s not too late to turn back.');
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               setcolor(lightgray);
               gwrite(x,y,'                  Turn back now?  (y/n)');
               repeat
                    ch:=readarrowkey;
               until(ch in ['y','Y','n','N']);
               if (ch in ['y','Y']) then
                    begin
                         gwriteln(x,y,'');
                         gwriteln(x,y,'');
                         gwriteln(x,y,'     You wisely choose to leave.');
                         prompt;
                    end
               else
                    begin
                         gwriteln(x,y,'');
                         gwriteln(x,y,'');
                         gwriteln(x,y,'     You enter the dragon''s lair...');
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
                                   gwriteln(x,y,'');
                                   gwriteln(x,y,'');
                                   gwriteln(x,y,'CONGRATULATIONS!');
                                   gwriteln(x,y,'You have defeated the great Red Dragon.');
                                   gwriteln(x,y,'In the dragon''s horde, you find the Flame Wand.');
                                   gwriteln(x,y,'');
                                   gwriteln(x,y,'');
                                   drawpicturebyline(x,y,'flamewnd.ln1');
                                   if (player.numitems<itemmax) then
                                        begin
                                             player.numitems:=player.numitems + 1;
                                             player.item[player.numitems]:=flamewand;
                                             setcolor(lightblue);
                                             gwriteln(x,y,'     You pick up the Flame Wand as your own.');
                                             prompt;
                                        end
                                   else
                                        begin
                                             setcolor(lightblue);
                                             gwriteln(x,y,'     You are carrying too many items.');
                                             gwriteln(x,y,'     Do you want to drop one? (y/n)');
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
                                                       gwriteln(x,y,'');
                                                       gwriteln(x,y,'     You leave the wand here.');
                                                       prompt;
                                                  end;
                                        end;
                              end;
                    end;
          end
     else
          begin
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               gwriteln(x,y,'');
               gwriteln(x,y,'This was once the dwelling place of the ancient');
               gwriteln(x,y,'Red Dragon.');
               gwriteln(x,y,'');
               gwriteln(x,y,'You see a huge red carcass nearby with flies');
               gwriteln(x,y,'buzzing around it.');
               gwriteln(x,y,'');
               gwriteln(x,y,'There doesn''t seem to be anything of interest here.');
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
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     gwriteln(x,y,'   In the side of the icy rock');
     gwriteln(x,y,'mountains you see something written');
     gwriteln(x,y,'etched in the stone.  It says:');
     settextstyle(triplex,horizontal,6);
     gwriteln(x,y,'');
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
procedure entercastle;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'');
     message(x,y,'  The Ice Castle -- enter? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['Y','y']) then
          dungeon(player,cfg.castlemap,cfg.castlecode,cfg.castlechart,10,7)
     else
          surfacemessage;
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
     gwriteln(x,y,'   Wilderness Options');
     gwriteln(x,y,'');
     settextstyle(default,horizontal,2);
     gwriteln(x,y,'');
     setcolor(lightgreen);
     gwrite(x,y,'            V');
     setcolor(green);
     gwriteln(x,y,'iew Stats');
     gwriteln(x,y,'');
     setcolor(lightgreen);
     gwrite(x,y,'            U');
     setcolor(green);
     gwriteln(x,y,'se Item');
     gwriteln(x,y,'');
     setcolor(lightgreen);
     gwrite(x,y,'            C');
     setcolor(green);
     gwriteln(x,y,'ast Spell');
     gwriteln(x,y,'');
     setcolor(lightgreen);
     gwrite(x,y,'            Q');
     setcolor(green);
     gwriteln(x,y,'uit Game');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     setcolor(lightgreen);
     gwrite(x,y,'  ** ');
     setcolor(green);
     gwrite(x,y,'any other key--Back to Game');
     setcolor(lightgreen);
     gwriteln(x,y,' **');
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
                         8:entercastle; {* castle *}
                    end;
                    if(surfacecode[px,py] in [3..8])then
                         surfacescreen(surfacemap);
               end;
     until FALSE;
end;
