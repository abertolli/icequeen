{$ifndef DICE.PAS}
{
Dice functions and procedures
Copyright (C) 1999-2005 Angelo Bertolli

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

{--------------------------------------------------------------------------}
function d(dnum:integer):integer;
{ The value of d(dnum) is returned as a random number between 1 and dnum.}

begin
	d:=random(dnum)+1;
end;

{--------------------------------------------------------------------------}
function roll(s:string):integer;

{Take a string in dice notation, and return a result.}

var
	target		: integer;
	ndice		: integer;
	nsides		: integer;
	value		: integer;
	loop		: integer;
	errcode		: integer;

begin

	{ Look for a + or - }
	target:=pos('+',s);
	if (target<>0) then
	begin
		roll:=roll(copy(s,1,target-1)) + roll(copy(s,target+1,length(s)));
		exit;
	end;

	target:=pos('-',s);
	if (target<>0) then
	begin
		roll:=roll(copy(s,1,target-1)) - roll(copy(s,target+1,length(s)));
		exit;
	end;

	target:=pos('d',s);
	if (target=0) then
		target:=pos('D',s);
	if (target<>0) then
	begin
		val(copy(s,1,target-1),ndice,errcode);				{get dnum}
		val(copy(s,target+1,length(s)),nsides,errcode);		{get dsides}
		value:=0;
		for loop:=1 to ndice do
		begin
			value:=value + d(nsides);
		end;
		roll:=value;
		exit;
	end;

	val(s,value,errcode);
	roll:=value;

end;
{--------------------------------------------------------------------------}
{$define DICE.PAS}
{$endif}
