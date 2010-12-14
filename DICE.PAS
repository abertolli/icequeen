{
	DICE.PAS
	Dice functions and procedures
	Copyright (C) 1999-2010 Angelo Bertolli
}

unit Dice;

INTERFACE

function d(dnum:integer):integer;
function roll(s:string):integer;
function rollmin(s:string):integer;
function rollmax(s:string):integer;
function rollavg(s:string):integer;

IMPLEMENTATION

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
function rollmin(s:string):integer;

{Take a string in dice notation, and return the minimum possible result}

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
		rollmin:=rollmin(copy(s,1,target-1)) + rollmin(copy(s,target+1,length(s)));
		exit;
	end;

	target:=pos('-',s);
	if (target<>0) then
	begin
		rollmin:=rollmin(copy(s,1,target-1)) - rollmin(copy(s,target+1,length(s)));
		exit;
	end;

	target:=pos('d',s);
	if (target=0) then
		target:=pos('D',s);
	if (target<>0) then
	begin
		val(copy(s,1,target-1),ndice,errcode);				{get dnum}
                rollmin:=ndice;
		exit;
	end;

	val(s,value,errcode);
	rollmin:=value;

end;
{--------------------------------------------------------------------------}
function rollmax(s:string):integer;

{Take a string in dice notation, and return the maximum possible result.}

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
		rollmax:=rollmax(copy(s,1,target-1)) + rollmax(copy(s,target+1,length(s)));
		exit;
	end;

	target:=pos('-',s);
	if (target<>0) then
	begin
		rollmax:=rollmax(copy(s,1,target-1)) - rollmax(copy(s,target+1,length(s)));
		exit;
	end;

	target:=pos('d',s);
	if (target=0) then
		target:=pos('D',s);
	if (target<>0) then
	begin
		val(copy(s,1,target-1),ndice,errcode);				{get dnum}
		val(copy(s,target+1,length(s)),nsides,errcode);		{get dsides}
                rollmax:=ndice * nsides;
		exit;
	end;

	val(s,value,errcode);
	rollmax:=value;

end;
{--------------------------------------------------------------------------}
function rollavg(s:string):integer;

{Take a string in dice notation, and return the average result.}
begin
        rollavg:=(rollmin(s) + rollmax(s)) DIV 2;
end;
{--------------------------------------------------------------------------}

begin
	randomize;
end.
