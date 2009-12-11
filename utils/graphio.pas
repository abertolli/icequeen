{
GraphIO Library
Copyright (C) 2001 Angelo Bertolli

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

Angelo Bertolli
<angelo.bertolli@gmail.com>
}

Unit GraphIO;

INTERFACE

uses crt, graph;

{$I global.pas}

var
     device         :    integer;
     mode           :    integer;
     ch             :    char;
     x,y            :    integer;
     loop           :    integer;
     row            :    integer;
     col            :    integer;
     ans            :    char;
     nummonsters    :    integer;
     player         :    playerrecord;
     monster        :    monsterlist;
     cfg            :    configrecord;

function READARROWKEY    :    char;
function exist(dosname:stringtype) : boolean;
function CAPITALIZE(capstring:stringtype):stringtype;
procedure graph_init(var gdriver,gmode:integer;gpath:string);
procedure prompt;
procedure DRAWPICTUREBYLINE(beginx,beginy:integer;dosname:stringtype);
procedure HOMECURSOR(var x,y:integer);
procedure graphwrite(var x,y:integer;s:string);
procedure graphwriteLN(var x,y:integer;s:string);
procedure graphread(var x,y:integer;var s:stringtype);
procedure writefile(beginy:integer;dosname:stringtype);

IMPLEMENTATION

{I/O and other Functions and Procedures}
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
{--------------------------------------------------------------------------}
function exist(dosname:stringtype) : boolean;

{Returns TRUE if the file exists.}

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
{--------------------------------------------------------------------------}
function CAPITALIZE(capstring:stringtype):stringtype;

{CAPITALIZE is returned as capstring in all caps.}

begin
     for loop:=1 to length(capstring) do
          capstring[loop]:=upcase(capstring[loop]);
     capitalize:=capstring;
end;
{--------------------------------------------------------------------------}
procedure graph_init(var gdriver,gmode:integer;gpath:string);

var
     error          :    integer;

begin
     writeln;
     DetectGraph(gdriver,gmode);

     gdriver:=vga;
     gmode:=vgahi;

     initgraph(gdriver,gmode,gpath);
     error:=graphresult;
     if not(error=grOK)then
          begin
               writeln('Graphics initialization error!');
               writeln('Program cannot continue.  Press enter.');
               readln;
               halt(1);
          end;
end;

{Drawing Functions and Procedures}
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
     lineoftext     :    string[100];
     savename       :    stringtype;

begin

     savename:='';
     if not(exist(dosname)) then
          begin
               savename:=dosname;
               dosname:='nophoto.ln1';
          end;
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
     if (savename<>'') then
          begin
               setcolor(lightblue);
               settextstyle(default,horizontal,1);
               outtextxy(beginx+15,beginy+20,savename);
          end;

end;

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
procedure graphwrite(var x,y:integer;s:string);

begin
     outtextxy(x,y,s);
     x:=x + textwidth(s);
end;
{--------------------------------------------------------------------------}
procedure graphwriteln(var x,y:integer;s:string);

begin
     outtextxy(x,y,s);
     y:=y + textheight('M') + 2;
     x:=10;
end;
{--------------------------------------------------------------------------}
procedure graphread(var x,y:integer;var s:stringtype);

var
     lastletter     :    integer;
     theletter      :    char;
     forecolor      :    word;

begin
     forecolor:=getcolor;
     s:='';
     repeat
          ch:=readkey;
          if(ch<>#13)then
               begin
                    if(ch<>#8)then
                         begin
                              s:=s + ch;
                              graphwrite(x,y,ch);
                         end
                    else
                         if(s<>'')then
                              begin
                                   lastletter:=length(s);
                                   theletter:=s[lastletter];
                                   delete(s,lastletter,1);
                                   x:=x - textwidth(theletter);
                                   setcolor(getbkcolor);
                                   graphwrite(x,y,theletter);
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
               graphwriteln(x,y,lineoftext);
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

{===========================================================================}

begin {main}

end.  {main}
