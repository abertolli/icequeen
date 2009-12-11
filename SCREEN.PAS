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
               if (numspells>0) then
                    begin
                         x:=midstats('SPELLS');
                         gwriteln(x,y,'SPELLS');
                         for loop:=1 to numspells do
                              begin
                                   x:=midstats(spellstring(spell[loop]));
                                   gwriteln(x,y,spellstring(spell[loop]));
                              end;
                    end
               else
                    begin
                         x:=midstats('No spells');
                         gwriteln(x,y,'No spells');
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
