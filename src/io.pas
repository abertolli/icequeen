{
GraphIO Unit
Copyright (C) 1996-2005 Angelo Bertolli

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

Angelo Bertolli <angelo.bertoli@gmail.com>
}

Unit GraphIO;

INTERFACE

uses crt, graph;

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
     graphio_ver    =    '2.2';

procedure graph_init(gd,gm:integer;fontloc:string);
procedure prompt;
procedure DrawPic(beginx,beginy:integer;dosname:string);
procedure HOMECURSOR(var x,y:integer);
procedure graphwrite(var x,y:integer;s:string);
procedure graphwriteln(var x,y:integer;s:string);
procedure graphread(var x,y:integer;var s:string);
procedure writefile(beginy:integer;dosname:string);

IMPLEMENTATION

{$I extras.pas}
{--------------------------------------------------------------------------}
procedure graph_init(gd,gm:integer;fontloc:string);

var
     error          :    integer;

begin
     initgraph(gd,gm,fontloc);
     error:=graphresult;
     if not(error=grOK)then
          begin
               writeln('Graphics initialization error: ',error);
               writeln('Program cannot continue.  Press enter.');
               readln;
{
               halt(1);
}
          end;
end;

{Drawing Functions and Procedures}
{--------------------------------------------------------------------------}
function readjust(c:integer):integer;

begin

   case c of
      lightgray     :readjust:=darkgray;
      darkgray      :readjust:=lightgray;
      blue          :readjust:=red;
      lightblue     :readjust:=lightred;
      cyan          :readjust:=brown;
      lightcyan     :readjust:=yellow;
      brown         :readjust:=cyan;
      yellow        :readjust:=lightcyan;
      red           :readjust:=blue;
      lightred      :readjust:=lightblue;
   else
      readjust:=c;

   end; {case}

end;
{--------------------------------------------------------------------------}
procedure drawbmp16(dosname:string;xpos,ypos:integer);

type
     FileHeader    = record
                        bfType        : word;
                        bfSize        : longint;
                        bfReserved1   : word;
                        bfReserved2   : word;
                        bfOffBits     : longint;
     end;

     InfoHeader = record
                     biSize           : longint;
                     biWidth          : longint;
                     biHeight         : longint;
                     biPlanes         : word;
                     biBitCount       : word;
                     biCompression    : longint;
                     biSizeImage      : longint;
                     biXPelsPerMeter  : longint;
                     biYPelsPerMeter  : longint;
                     biClrUsed        : longint;
                     biClrImportant   : longint;
     end;

     Quad = record
               blue                   : byte;
               green                  : byte;
               red                    : byte;
               Reserved               : byte;
     end;

     BitmapHead = record
                      fh:        FileHeader;
                      ih:        InfoHeader;
                      colors:    array[0..15] of Quad;
     end;

var
     f     :     file of byte;
     info  :     file of BitmapHead;
     data  :     bitmaphead;
     color :     integer;
     b     :     byte;
     x     :     word;
     y     :     word;

begin

     assign(info,dosname);
     reset(info);
     read(info,data);
     close(info);

     assign(f,dosname);
     reset(f);
     seek(f,data.fh.bfoffbits);

     for y:=data.ih.biheight downto 1 do
          for x:=1 to (data.ih.biwidth div 2+3) and not 3  do
               begin
                    read(f,b);
                    color:=b shr 4;
                    putpixel((x*2)+xpos,y+ypos,readjust(color));
                    color:=b and 15;
                    putpixel((x*2)+1+xpos,y+ypos,readjust(color));
               end;

     close(f);

end;
{-------------------------------------------------------------------------}
procedure DrawPic(beginx,beginy:integer;dosname:string);

var
   previouscolor: word;

begin
   if not(exist(dosname)) then
      begin
         previouscolor:=getcolor;
         setcolor(lightblue);
         settextstyle(small,horizontal,4);
         outtextxy(beginx,beginy,dosname);
		 setcolor(previouscolor);
      end
   else
      drawbmp16(dosname,beginx,beginy);
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

{===========================================================================}

begin {main}
     writeln;
     writeln('GraphIO Unit ',graphio_ver);
     writeln('Copyright (C) 2002 - Angelo Bertolli');
     writeln('                     abertoll@hotmail.com');
     writeln('The GraphIO Unit comes with ABSOLUTELY NO WARRANTY');
     writeln('This is free software and you are welcome');
     writeln('to redistribute it under certain conditions.');
     writeln('(See the file named LICENSE.GPL.TXT)');
     writeln;
     writeln('For a pascal compiler, visit http://www.freepascal.org/');
     writeln;
end.  {main}
