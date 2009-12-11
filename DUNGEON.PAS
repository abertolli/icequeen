{Dungeon/Cave/Castle Engine}
{---------------------------------------------------------------------------}
procedure dungeonoptions;

begin
     cleardevice;
     setcolor(magenta);
     settextstyle(default,horizontal,3);
     x:=10;
     y:=100;
     gwriteln(x,y,'    Dungeon Options');
     gwriteln(x,y,'');
     settextstyle(default,horizontal,2);
     gwriteln(x,y,'');
     setcolor(lightmagenta);
     gwrite(x,y,'            V');
     setcolor(magenta);
     gwriteln(x,y,'iew Stats');
     gwriteln(x,y,'');
     setcolor(lightmagenta);
     gwrite(x,y,'            U');
     setcolor(magenta);
     gwriteln(x,y,'se Item');
     gwriteln(x,y,'');
     setcolor(lightmagenta);
     gwrite(x,y,'            C');
     setcolor(magenta);
     gwriteln(x,y,'ast Spell');
     gwriteln(x,y,'');
     setcolor(lightmagenta);
     gwrite(x,y,'            Q');
     setcolor(magenta);
     gwriteln(x,y,'uit Game');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     gwriteln(x,y,'');
     setcolor(lightmagenta);
     gwrite(x,y,'  ** ');
     setcolor(magenta);
     gwrite(x,y,'any other key--Back to Game');
     setcolor(lightmagenta);
     gwriteln(x,y,' **');
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
               gwriteln(x,y,'You come across a locked door.');
               gwriteln(x,y,'(A)ttack it');
               gwriteln(x,y,'(U)se an item');
               gwriteln(x,y,'(C)ast a spell');
               gwriteln(x,y,'Use a (k)ey');
               gwriteln(x,y,'(L)eave');
               repeat
                    ans:=readarrowkey;
               until (ans in ['a','A','u','U','c','C','k','K','l','L']);
               done:=ans in ['l','L'];
               cleardevice;
               homecursor(x,y);
               case ans of
                 'a','A':begin
                              gwriteln(x,y,'You attack the door, but it doesn''t budge...');
                              prompt;
                         end;
                 'u','U':begin
                              gwriteln(x,y,'Use which item?');
                              with player do
                                   for loop:=1 to numitems do
                                        begin
                                             str(loop,tempstring);
                                             ch:=tempstring[1];
                                             tempstring:='      ';
                                             tempstring:=tempstring + ch + '. ';
                                             tempstring:=tempstring + itemstring(item[loop]);
                                             gwriteln(x,y,tempstring);
                                        end;
                              gwriteln(x,y,'     (N)evermind');
                              repeat
                                   ans:=readarrowkey;
                              until (ans in ['1'..ch,'n','N']);
                              gwriteln(x,y,'');
                              gwrite(x,y,'You point the ');
                              tempstring:=ans;
                              val(tempstring,loop,errcode);
                              tempstring:=itemstring(player.item[loop]);
                              gwrite(x,y,tempstring);
                              gwriteln(x,y,' at the door.');
                              gwriteln(x,y,'It does nothing.');
                              prompt;
                         end;
                 'c','C':if (player.charges>0) then
                           begin
                              gwriteln(x,y,'Cast which spell?');
                              with player do
                                   for loop:=1 to numspells do
                                        begin
                                             str(loop,tempstring);
                                             ch:=tempstring[1];
                                             tempstring:='      ';
                                             tempstring:=tempstring + ch + '. ';
                                             tempstring:=tempstring + spellstring(spell[loop]);
                                             gwriteln(x,y,tempstring);
                                        end;
                              gwriteln(x,y,'     (N)evermind');
                              repeat
                                   ans:=readarrowkey;
                              until (ans in ['1'..ch,'n','N']);
                              tempstring:=ans;
                              val(tempstring,loop,errcode);
                              gwriteln(x,y,'');
                              gwriteln(x,y,'');
                              if not(player.spell[loop] in [obliterate,shatter]) then
                                   begin
                                        gwrite(x,y,'You cast ');
                                        tempstring:=spellstring(player.spell[loop]);
                                        gwriteln(x,y,tempstring);
                                        gwriteln(x,y,'It does nothing useful.');
                                   end
                              else
                                   if (player.spell[loop]=shatter) then
                                        begin
                                             gwriteln(x,y,'You freeze the lock, making it brittle.');
                                             gwriteln(x,y,'');
                                             gwriteln(x,y,'With one swift blow, you break off the lock.');
                                             player.stages:=player.stages + [unlocked];
                                             done:=true;
                                        end
                                   else
                                        begin
                                             gwriteln(x,y,'You obliterate the door.');
                                             player.stages:=player.stages + [unlocked];
                                             done:=true;
                                        end;
                              if not(ans in ['n','N']) then
                                   player.charges:=player.charges-1;
                              prompt;
                           end
                         else
                           begin
                                gwriteln(x,y,'You have not more charges in your ring.');
                                prompt;
                           end;
                 'k','K':if (key in player.stages) then
                              begin
                                   gwriteln(x,y,'The key doesn''t work.');
                                   prompt;
                              end
                         else
                              begin
                                   gwriteln(x,y,'You don''t have any keys.');
                                   prompt;
                              end;
               end;{case}
               cleardevice;
          until (done);
     if not(unlocked in player.stages) then
          begin
               px:=lastx;
               py:=lasty;
               cleardevice;
          end;
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
     cleardevice;
     repeat
          drawmaptile(px,py,dungeonmap);
          if (px>1)and(dungeonmap[px-1,py]<>28) then
               drawmaptile(px-1,py,dungeonmap);
          if (px<20)and(dungeonmap[px+1,py]<>28) then
               drawmaptile(px+1,py,dungeonmap);
          if (py>1)and(dungeonmap[px,py-1]<>28) then
               drawmaptile(px,py-1,dungeonmap);
          if (py<20)and(dungeonmap[px,py+1]<>28) then
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
          repeat
               ans:=readarrowkey;
          until (ans in ['2','4','6','8',' ']);
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
                    cleardevice;
               end;
          if (px<>lastx)or(py<>lasty) then
               begin
                    drawmaptile(lastx,lasty,dungeonmap);
                    case dungeoncode[px,py] of
                         0:if (d(100)<=dungeonchance) then
                                begin
                                     encounter(monsterchart);
                                     cleardevice;
                                end;
                         9:{cave sword};
                        10:{cave shield};
                        11:{cave library};
                        12:cave_key(player);
                        13:{cave staircase};
                        14:cave_locked(player,px,py,lastx,lasty);
                        15:{dungeon stair1};
                        16:{dungeon stair2};
                        17:{dungeon lizard};
                        18:{castle stair1};
                        19:{castle stair2};
                        20:{castle knight};
                        21:{castle barracks};
                        22:{castle courtyard};
                        23:{castle guest};
                        24:{castle banquet};
                        25:{castle master};
                        26:{castle kitchen};
                        27:{castle throne};
                        28:{secret passageway};
                    end;
                    drawmaptile(lastx,lasty,dungeonmap);
                    if (px=exitx)and(py=exity) then
                         begin
                              clearmessage;
                              homemessage(x,y);
                              settextstyle(default,horizontal,2);
                              setcolor(black);
                              message(x,y,'');
                              message(x,y,'              Exit? (y/n)');
                              repeat
                                   ans:=readarrowkey;
                              until (ans in ['y','Y','n','N']);
                              exitdungeon:=ans in ['y','Y'];
                              cleardevice;
                         end;
               end;
     until exitdungeon;
end;
