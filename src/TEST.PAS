{$define DEBUG}
{
Tests for functions and procedures that need them
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

Angelo Bertolli <angelo.bertoli@gmail.com>
}

program Test;

uses crt;

var
	ch:char;
	s:string;
	loop:integer;

{$I DICE.PAS}
{--------------------------------------------------------------------------}


begin {main}
	clrscr;
	write('Enter dice notation: ');
	readln(s);
	writeln(roll(s));
end. {main}
