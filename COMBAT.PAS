{---------------------------------------------------------------------------}
procedure combatscreen(player:recordtype;nummonsters:integer;
monster:monsterlist);

var
     startpoint       :    integer;
     xpoint           :    integer;

begin
     cleardevice;
     settextstyle(default,horizontal,1);
     if (nummonsters>4) then
          begin
               startpoint:=320 - ((4*140) DIV 2);
               for loop:=1 to 4 do
                    with monster[loop] do
                         begin
                              xpoint:=(loop-1)*140 + startpoint;
                              drawpicturebyline(xpoint,20,picfile);
                              setcolor(lightgray);
                              str(loop,tempstring);
                              tempstring:=tempstring + ') ' + name;
                              xpoint:=(xpoint + 60) - (textwidth(tempstring) DIV 2);
                              outtextxy(xpoint,145,tempstring);
                         end;
               startpoint:=320 - (((nummonsters-4)*140) DIV 2);
               for loop:=5 to nummonsters do
                    with monster[loop] do
                         begin
                              xpoint:=(loop-5)*140 + startpoint;
                              drawpicturebyline(xpoint,160,picfile);
                              setcolor(lightgray);
                              str(loop,tempstring);
                              tempstring:=tempstring + ') ' + name;
                              xpoint:=(xpoint + 60) - (textwidth(tempstring) DIV 2);
                              outtextxy(xpoint,285,tempstring);
                         end;
          end
     else
          begin
               startpoint:=320 - ((nummonsters*140) DIV 2);
               for loop:=1 to nummonsters do
                    with monster[loop] do
                         begin
                              xpoint:=(loop-1)*140 + startpoint;
                              drawpicturebyline(xpoint,20,picfile);
                              setcolor(lightgray);
                              str(loop,tempstring);
                              tempstring:=tempstring + ') ' + name;
                              xpoint:=(xpoint + 60) - (textwidth(tempstring) DIV 2);
                              outtextxy(xpoint,145,tempstring);
                         end;
          end;
     with player do
          drawpicturebyline(250,310,picfile);
end;
{---------------------------------------------------------------------------}
procedure clearleft(var x,y:integer);

begin
     setfillstyle(solidfill,blue);
     bar(20,300,200,440);
     setcolor(lightblue);
     rectangle(19,299,201,441);
     x:=25;
     y:=305;
     setcolor(lightcyan);
end;
{---------------------------------------------------------------------------}
procedure clearright(var x,y:integer);

begin
     setfillstyle(solidfill,blue);
     bar(420,300,620,440);
     setcolor(lightblue);
     rectangle(419,299,621,441);
     x:=425;
     y:=305;
     setcolor(lightcyan);
end;
{---------------------------------------------------------------------------}
function midleft(thestring:stringtype) :    integer;

begin
     midleft:=110 - (textwidth(thestring) DIV 2);
end;
{---------------------------------------------------------------------------}
function midright(thestring:stringtype) :    integer;

begin
     midright:=520 - (textwidth(thestring) DIV 2);
end;
{---------------------------------------------------------------------------}
procedure leftwriteln(var x,y:integer;gstring:stringtype);

begin
     x:=midleft(gstring);
     gwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure leftprompt;

var
     origcolor      :    integer;
     backgroundcolor:    integer;

begin
     settextstyle(default,horizontal,1);
     origcolor:=getcolor;
     backgroundcolor:=getpixel(107,445);
     setcolor(white);
     outtextxy(107,445,'press a key');
     ch:=readarrowkey;
     setcolor(backgroundcolor);
     outtextxy(107,445,'press a key');
     setcolor(origcolor);
end;
{---------------------------------------------------------------------------}
procedure combatstats(player:recordtype);

var
     thestring      :    stringtype;

begin
     clearright(x,y);
     settextstyle(sanseri,horizontal,1);
     with player do
          begin
               tempstring:=name;
               while (textwidth(tempstring)>200) do
                    delete(tempstring,length(tempstring),1);
               outtextxy(midright(tempstring),305,tempstring);
               settextstyle(default,horizontal,1);
               outtextxy(midright('ENDURANCE'),335,'ENDURANCE');
               str(endurance,tempstring);
               thestring:=tempstring;
               str(endurancemax,tempstring);
               thestring:=thestring + '/' + tempstring;
               outtextxy(midright(thestring),345,thestring);
               outtextxy(midright('ATTACK'),360,'ATTACK');
               str(attack,tempstring);
               outtextxy(midright(tempstring),370,tempstring);
               outtextxy(midright('DEFENSE'),385,'DEFENSE');
               str(defense,tempstring);
               outtextxy(midright(tempstring),395,tempstring);
               outtextxy(midright('LUCK'),410,'LUCK');
               str(luck,tempstring);
               outtextxy(midright(tempstring),420,tempstring);
          end;
end;
