{Graphics Writing Functions and Procedures}
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
procedure HOMECURSOR(var x,y:integer);

{Sets x and y to the home position.}

begin
     x:=10;
     y:=10;
end;
{--------------------------------------------------------------------------}
procedure GWRITE(var x,y:integer;gtext:string);

{Similar to write(); but for graphics mode.}

begin
     outtextxy(x,y,(gtext));
     x:=x + textwidth(gtext);
end;
{--------------------------------------------------------------------------}
procedure GWRITELN(var x,y:integer;gtext:string);

{Similar to writeln(); but for graphics mode.}

begin
     outtextxy(x,y,(gtext));
     y:=y + textheight('M') + 2;
     x:=10;
end;
{--------------------------------------------------------------------------}
procedure GREAD(var x,y:integer;var gtext:stringtype);

{Similar to read(); but for graphics mode.}

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
procedure writefile(beginy:integer;dosname:stringtype);

{Puts the contents of a text file to the screen. Use beginy to start it
somewhere other than the very top.}

var
     pasfile        :    text;
     numlines       :    integer;
     lineoftext     :    string[100];

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
