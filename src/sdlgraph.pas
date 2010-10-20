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

IMPLEMENTATION

var
	graph_env	: record
		color		: word;
		bkcolor		: word;
		fontface	: byte;
		fontdirection	: byte;
		fontsize	: byte;
		screenw		: integer;
		screenh		: integer;
		colordepth	: byte;
		driverpath	: string;
	end;

{Include helper (non-interface) functions.}
{$I sdlgraphx.pas}
{--------------------------------------------------------------------------}
procedure cleardevice;
{Clears the graphical screen (with the current background color), and sets the pointer at (0,0).}
begin end;
{--------------------------------------------------------------------------}
function getcolor:word;
begin
	getcolor:=graph_env.color;
end;
{--------------------------------------------------------------------------}
procedure setcolor(c:word);
begin
	graph_env.color:=c;
end;
{--------------------------------------------------------------------------}
function getbkcolor:word;
begin
	getbkcolor:=graph_env.bkcolor;
end;
{--------------------------------------------------------------------------}
procedure setbkcolor(c:word);
begin
	graph_env.bkcolor:=c;
end;
{--------------------------------------------------------------------------}
function getmaxx:smallint;
begin
	getmaxx:=graph_env.screenw;
end;
{--------------------------------------------------------------------------}
function getmaxy:smallint;
begin
	getmaxy:=graph_env.screenh;
end;
{--------------------------------------------------------------------------}
procedure settextstyle(face,direction,size:byte);
begin
	with graph_env do
	begin
		fontface:=face;
		fontdirection:=direction;
		fontsize:=size;
	end;
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
{--------------------------------------------------------------------------}
procedure initgraph(var driver,mode:smallint;const path:string)
begin
	{Initialize all variables.  Right now we enforce one mode only.}
	with graph_env do
	begin
		driverpath:=path;
		screenw:=640;
		screenh:=480;
		colordepth:=4; { 16 color palette }
		color:=white;
		bkcolor:=black;
		fontface:=default;
		fontdirection:=horizontal;
		fontsize:=2;
	end;
end;
{--------------------------------------------------------------------------}
begin {main}
end.  {main}
