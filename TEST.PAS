{
	Tests for functions and procedures that need them
	Copyright (C) 2010 Angelo Bertolli
}

program Test;

uses crt;

var
	ch		: char;
	s		: string;
	loop	: integer;
	i		: integer;

{$I DICE.PAS}
{--------------------------------------------------------------------------}


begin {main}
	randomize;
	clrscr;
	write('Enter a number of sides for one die: ');
	readln(i);
	writeln('Result: ',d(i));
	write('Enter a dice notation: ');
	readln(s);
	writeln('Result:');
	writeln(roll(s));
	writeln('End of Test.');
	readln;
end. {main}
