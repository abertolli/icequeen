{Player dies.}
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
