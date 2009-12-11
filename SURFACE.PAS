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
{---------------------------------------------------------------------------}
procedure surfacescreen;

begin
     screensetup;
     drawmap(surfacemap);
     surfacemessage;
     writestats(player);
end;
{---------------------------------------------------------------------------}
procedure encounter;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'           You encounter');
     message(x,y,'');
     message(x,y,'             MONSTERS!');
     prompt;
     randommonsters(nummonsters,monster);
     combat(player,nummonsters,monster,moneypool);
     surfacescreen;
end;
{---------------------------------------------------------------------------}
procedure thepassword;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'   In the side of the icy rock');
     message(x,y,'mountains you see something writ-');
     message(x,y,'ten, etched in the stone.  It says:');
     message(x,y,'         "CRYSTAL SHARD"');
     prompt;
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
     message(x,y,'   Glantri City -- enter? (y/n)');
     repeat
          ans:=readarrowkey;
     until (ans in ['y','Y','n','N']);
     if (ans in ['Y','y']) then
          begin
               town;
               surfacescreen;
          end
     else
          surfacemessage;
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
     gwrite(x,y,'            S');
     setcolor(green);
     gwriteln(x,y,'pecial Ability');
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
                   calccombat(player);
                   viewstats(player);
              end;
      'u','U':useitem(player);
      's','S':useskill(player,true,false);
      'q','Q':begin
                   closegraph;
                   halt;
              end;
     end;{case}
end;
{---------------------------------------------------------------------------}
procedure surface(surfacecode:matrix);

var
     px             :    integer;
     py             :    integer;
     lastx          :    integer;
     lasty          :    integer;

begin
     surfacescreen;
     px:=10;
     py:=11;
     repeat
          drawplayer(px,py);
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
                    surfacescreen;
               end;
          if (px<>lastx)or(py<>lasty) then
               begin
                    drawmaptile(lastx,lasty,surfacemap);
                    case surfacecode[px,py] of
                         0:if (d(100)<=15) then
                                encounter;
                         2:if (d(100)<=5) then
                                encounter;
                         3:entertown;
                         4:; {* crying lion inn *}
                         5:; {* cave *}
                         6:; {* dragon *}
                         7:thepassword;
                         8:; {* castle *}
                    end;
               end;
     until FALSE;
end;
