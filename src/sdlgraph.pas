{
SDLGraph Unit
Copyright (C) 2010 Angelo Bertolli

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

Unit SDLGraph;

INTERFACE

uses sdl, sdl_ttf;

const
	{unit version}
	version		= '0.1';

	{default mode}
	screenw		= 640;
	screenh		= 480;
	colordepth	= 32;

	{16 color definitions}
	black		= 0;
	blue		= 1;
	green		= 2;
	cyan		= 3;
	red		= 4;
	magenta		= 5;
	brown		= 6;
	lightgray	= 7;
	darkgray	= 8;
	lightblue	= 9;
	lightgreen	= 10;
	lightcyan	= 11;
	lightred	= 12;
	lightmagenta	= 13;
	yellow		= 14;
	white		= 15;

	{used for graphics text}
	default		= 0;
	triplex		= 1;
	small		= 2;
	sanseri		= 3;
	gothic		= 4;
	horizontal	= 0;
	vertical	= 1;

type
	pixel		= word;
	TpixelBuf	= array[0..screenh-1,0..screenw-1] of pixel;

var
	screen		: PSDL_Surface;
	sdlio_env	: record
		color		: word;
		bkcolor		: word;
		fontface	: byte;
		fontdirection	: byte;
		fontsize	: byte;
	end;

procedure prompt;
procedure DrawPic(beginx,beginy:integer;dosname:string);
procedure HOMECURSOR(var x,y:integer);
procedure graphwrite(var x,y:integer;s:string);
procedure graphwriteln(var x,y:integer;s:string);
procedure graphread(var x,y:integer;var s:string);
procedure writefile(beginy:integer;dosname:string);
procedure openscreen;
procedure closescreen;

IMPLEMENTATION

{$I extras.pas}
{--------------------------------------------------------------------------}
procedure cleardevice();
{Returns the current native pascal color}
begin closescreen; openscreen; end;
{--------------------------------------------------------------------------}
function getcolor():byte;
{Returns the current native pascal color}
begin getcolor:=sdlio_env.color; end;
{--------------------------------------------------------------------------}
procedure setcolor(c:byte);
{Sets the current native pascal color}
begin sdlio_env.color:=c; end;
{--------------------------------------------------------------------------}
function getbkcolor():byte;
{Returns the current native pascal color}
begin getbkcolor:=sdlio_env.bkcolor; end;
{--------------------------------------------------------------------------}
procedure setbkcolor(c:byte);
{Sets the current native pascal color}
begin sdlio_env.bkcolor:=c; end;
{--------------------------------------------------------------------------}
function getmaxy():smallint;
{Sets the current native pascal color}
begin getmaxy:=screenh; end;
{--------------------------------------------------------------------------}
procedure settextstyle(face,direction,size:byte);

begin

with sdlio_env do
begin
	fontface:=face;
	fontdirection:=direction;
	fontsize:=size;
end;

end;
{--------------------------------------------------------------------------}
function getfontface():PChar;
{Translates current pascal font to a path to a ttf font}

begin
	getfontface:='fonts/arial.ttf';
end;
{--------------------------------------------------------------------------}
function getfontsize():byte;
{Translate current pascal font to a point size}

begin
	getfontsize:=sdlio_env.fontsize*2;
end;
{--------------------------------------------------------------------------}
function sdlcolor(c:word):TSDL_Color;
{Takes a color name/id and returns an RGB SDL color}

var
	color:TSDL_Color;
begin

with color do
begin
	case c of
	lightgray	:begin r:=190;	g:=190;	b:=190;	end;
	darkgray	:begin r:=90;	g:=90;	b:=90;	end;
	blue		:begin r:=0;	g:=0;	b:=200;	end;
	lightblue	:begin r:=90;	g:=90;	b:=255;	end;
	cyan		:begin r:=0;	g:=190;	b:=190;	end;
	lightcyan	:begin r:=0;	g:=255;	b:=255;	end;
	brown		:begin r:=190;	g:=80;	b:=64;	end;
	yellow		:begin r:=255;	g:=255;	b:=0;	end;
	red		:begin r:=200;	g:=0;	b:=0;	end;
	lightred	:begin r:=255;	g:=90;	b:=90;	end;
	white		:begin r:=255;	g:=255;	b:=255;	end;
	black		:begin r:=0;	g:=0;	b:=0;	end;
	magenta		:begin r:=150;	g:=0;	b:=150;	end;
	lightmagenta	:begin r:=255;	g:=0;	b:=255;	end;
	green		:begin r:=0;	g:=190;	b:=0;	end;
	lightgreen	:begin r:=0;	g:=255;	b:=0;	end;
	end; {case}
end;

sdlcolor:=color;

end;
{--------------------------------------------------------------------------}
function palette16(c:Pixel):Pixel;
{Returns the color for the classic GRAPH unit palette based on color name.}

var
r         :     byte;
g         :     byte;
b         :     byte;

begin

r:=128;
g:=128;
b:=128;
case c of
	lightgray	:begin r:=190;	g:=190;	b:=190;	end;
	darkgray	:begin r:=90;	g:=90;	b:=90;	end;
	blue		:begin r:=0;	g:=0;	b:=200;	end;
	lightblue	:begin r:=90;	g:=90;	b:=255;	end;
	cyan		:begin r:=0;	g:=190;	b:=190;	end;
	lightcyan	:begin r:=0;	g:=255;	b:=255;	end;
	brown		:begin r:=190;	g:=80;	b:=64;	end;
	yellow		:begin r:=255;	g:=255;	b:=0;	end;
	red		:begin r:=200;	g:=0;	b:=0;	end;
	lightred	:begin r:=255;	g:=90;	b:=90;	end;
	white		:begin r:=255;	g:=255;	b:=255;	end;
	black		:begin r:=0;	g:=0;	b:=0;	end;
	magenta		:begin r:=150;	g:=0;	b:=150;	end;
	lightmagenta	:begin r:=255;	g:=0;	b:=255;	end;
	green		:begin r:=0;	g:=190;	b:=0;	end;
	lightgreen	:begin r:=0;	g:=255;	b:=0;	end;
end; {case}
r:=trunc((r/255)*31);
g:=trunc((g/255)*63);
b:=trunc((b/255)*31);
palette16:=(r shl 11) + (g shl 5) + b;

end;
{--------------------------------------------------------------------------}
function readjust(c:integer):integer;
{converts an ms paint color to a native palette color code}

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

     TBitmapInfo = record
                      bmiFileheader   : FileHeader;
                      bmiHeader       : InfoHeader;
                      bmiColors       : array[0..15] of Quad;
     end;

var
     f     :     file of byte;
     info  :     file of TbitmapInfo;
     data  :     TbitmapInfo;
     color :     Pixel;
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
     seek(f,data.bmifileheader.bfoffbits);

     for y:=data.bmiheader.biheight downto 1 do
          for x:=1 to (data.bmiheader.biwidth div 2+3) and not 3  do
               begin
                    read(f,b);
                    color:=b shr 4;
                    Tpixelbuf(screen^.pixels^)[y+ypos,(x*2)+xpos] := palette16(color);
                    color:=b and 15;
                    Tpixelbuf(screen^.pixels^)[y+ypos,(x*2)+1+xpos] := palette16(color);
               end;

     close(f);

end;
{-------------------------------------------------------------------------}
function getpixel(x,y:word):word;
{Get pixel color}

begin
	getpixel:=0; {screen^.pixels^[y,x]; -- needs to be converted to pascal colors}
end;
{-------------------------------------------------------------------------}
procedure putpixel(x,y,c:word);
{Places a pixel of color on the screen}

begin

end;
{-------------------------------------------------------------------------}
procedure outtextxy(x,y:integer;s:string);

var
	font		: pointer;
	fontcolor	: TSDL_Color;
	sdltext		: PSDL_Surface;
	dest		: PSDL_Rect;

begin

fontcolor:=sdlcolor(getcolor);
font:=TTF_OpenFont(getfontface,getfontsize);
{render function wants a C-style string}
s:=s+#0;
sdltext:=TTF_RenderText_Solid(font,@s[1],fontcolor);
new(dest);
dest^.x:=x;
dest^.y:=y;
{
dest^.w:=0;
dest^.h:=0;
}
SDL_BlitSurface(sdltext,NIL,screen,dest);
SDL_Flip(screen);
TTF_CloseFont(font);

end;
{-------------------------------------------------------------------------}
function textwidth(s:string):word;
{Returns width of string in pixels.}

var
	loop	: integer;
	font	: pointer;
	size	: word;
	adv,minx,maxx,miny,maxy:longint;

begin
	font:=TTF_OpenFont(getfontface,getfontsize);
	size:=0;
	adv:=0;
	for loop:=1 to length(s) do
	begin
		TTF_GlyphMetrics(font,ord(s[loop]),minx,maxx,miny,maxy,adv);
		size:=size + adv;
	end;
	textwidth:=size;
end;
{-------------------------------------------------------------------------}
function textheight(s:string):word;
{Returns width of a string in pixels.}

var
	loop	: integer;
	font	: pointer;
	size	: word;
	adv,minx,maxx,miny,maxy:longint;

begin
	font:=TTF_OpenFont(getfontface,getfontsize);
	size:=0;
	for loop:=1 to length(s) do
	begin
		TTF_GlyphMetrics(font,ord(s[loop]),minx,maxx,miny,maxy,adv);
		if (size < maxy) then size:=maxy;
	end;
	textheight:=size;
end;
{-------------------------------------------------------------------------}
procedure DrawPic(beginx,beginy:integer;dosname:string);

var
   previouscolor: byte;

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
{--------------------------------------------------------------------------}
procedure prompt;

var
	origcolor      :    word;
	backgroundcolor:    word;
	x              :    word;
	y              :    word;
	ch             :    char;

begin
	x:=screenw - (textwidth('press a key to continue')+5);
	y:=screenh - (textheight('M')+5);
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
	SDL_Init(SDL_INIT_VIDEO);
	screen:=SDL_SetVideoMode(screenw,screenh,colordepth,SDL_SWSURFACE);
end;
{--------------------------------------------------------------------------}
procedure closescreen;
begin
          SDL_FreeSurface(screen) ;
          SDL_Quit;
end;
{===========================================================================}

begin {main}
	writeln;
	writeln('SDLIO Unit ',sdlio_ver);
	writeln('Copyright (C) 2010 - Angelo Bertolli');
	writeln('This software comes with ABSOLUTELY NO WARRANTY');
	writeln('This is free software and you are welcome');
	writeln('to redistribute it under certain conditions.');
	writeln('(See the file named LICENSE)');
	writeln;

	setcolor(white);
	setbkcolor(black);
	settextstyle(default,horizontal,2);

end.  {main}
