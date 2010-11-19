{
GraphIO Unit
Copyright (C) 2002,2010 Angelo Bertolli

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

Unit GraphIO;

INTERFACE

uses
	{$ifdef Win32}
	windows, wincrt, graph, dataio;
	{$else}
	crt, graph, dataio;
	{$endif}

const

     {used for graphics text}
     default        =    0;
     triplex        =    1;
     small          =    2;
     sanseri        =    3;
     gothic         =    4;
     horizontal     =    0;
     vertical       =    1;

const
     graphio_ver    =    '2.3';

var
	gd	: integer;
	gm	: integer;

function readarrowkey:char;
procedure DRAWPICTUREBYLINE(beginx,beginy:integer;dosname:string);
procedure prompt;
procedure HOMECURSOR(var x,y:integer);
procedure graphwrite(var x,y:integer;s:string);
procedure graphwriteln(var x,y:integer;s:string);
procedure graphread(var x,y:integer;var s:string);
procedure writefile(beginy:integer;dosname:string);
procedure openscreen;
procedure closescreen;

IMPLEMENTATION

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
{Drawing Functions and Procedures}
{-------------------------------------------------------------------------}
procedure DRAWPICTUREBYLINE(beginx,beginy:integer;dosname:string);

{dosname            =    name of the file, including extention
beginx, beginy      =    the coordinates of where the upper left hand corner
                         of where the picture will be.}

var
     pasfile        :    text;
     row            :    integer;
     col            :    integer;
     color          :    integer;
     length         :    integer;
     lineoftext     :    string;
     savename       :    string;
     ch             :    char;

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
     origcolor      :    word;
     backgroundcolor:    word;
     x              :    word;
     y              :    word;
     ch             :    char;

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
procedure graphread(var x,y:integer;var s:string);

var
     lastletter     :    integer;
     theletter      :    char;
     forecolor      :    word;
     ch             :    char;

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
procedure writefile(beginy:integer;dosname:string);

{Puts the contents of a text file to the screen. Use beginy to start it
somewhere other than the very top.}

var
     pasfile        :    text;
     numlines       :    integer;
     lineoftext     :    string[100];
     x              :    integer;
     y              :    integer;

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
{--------------------------------------------------------------------------}
procedure openscreen;
begin
	{$ifdef FPC}
	gd:=D4bit;
	gm:=m640x480;
	{$else}
	gd:=0;
	gm:=0;
	{$endif}

	{$ifdef Win32}
	ShowWindow(GetActiveWindow,0);
	{$endif}

	initgraph(gd,gm,'fonts');
	if GraphResult<>grok then
	begin
		writeln('Graph error: ',GraphResult);
		writeln('Cannot continue.  Press enter to quit.');
		readln;
		halt(GraphResult);
	end;

end;
{--------------------------------------------------------------------------}
procedure closescreen;
begin
	closegraph;
end;
{===========================================================================}

begin {main}
{
     writeln;
     writeln('GraphIO Unit ',graphio_ver);
     writeln('Copyright (C) 2002,2010 - Angelo Bertolli');
     writeln('This software comes with ABSOLUTELY NO WARRANTY');
     writeln('This is free software and you are welcome');
     writeln('to redistribute it under certain conditions.');
     writeln('(See the file named LICENSE)');
     writeln;
}
end.  {main}
