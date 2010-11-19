{
FileIO Unit
Copyright (C) 1996-2010 Angelo Bertolli

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

unit DataIO;

INTERFACE

const

	{used for maps}
	rowmax	= 14;	  {number of rows on a map}
	colmax	= 20;	  {number of columns on a map}
	
	itemmax		= 9;
	spellmax	= 8;	{number of spells that can be in the ring}

type
	spell		= (icestorm,fireblast,web,callwild,heal,courage,
				freeze,obliterate,icicle,power,shatter,glacier,
				dragonbreath,resistfire,resistcold);

	matrix		= array[1..colmax,1..rowmax] of integer;
	spellarray	= array[1..spellmax] of spell;

    {stages: keep endgame as the last enum type}
	stage		= (ring,dragon,dilvish,baltar,key,unlocked,msword,
				mshield,knight,treasure,lizard,iceq,endgame);

	location	= (town,wilderness,dungeon);

    item		= (weapon,shield,armor,potion);
	
	item_t		= record
		name		: string;
		item_type	: item;
		value		: word;
		picfile		: string;
		msg			: string;
		data		: array[1..8] of integer;
	end;

	itemarray	= array[1..itemmax] of item_t;
	
	character_t	= record
		name		: string;
		picfile		: string;
		sex			: char;
		level		: byte;
		endurance	: word;
		endurancemax: word;
		armorclass	: integer;
		thac0		: shortint;
		damage		: string; {roll}
		savingthrow	: byte;
		experience	: longint;
		coins		: longint;
		numitems	: byte;
		item		: itemarray;
		numspells	: byte;
		spell		: spellarray;
		strength	: byte;
		dexterity	: byte;
		stages		: set of stage;
		charges		: byte;
		chargemax	: byte;
	end;


	monsterrecord  = record
		name		: string;
		picfile		: string;
		sex			: char;
		alignment	: char;
		hitdice		: byte;
		hpbonus		: shortint;
		endurance	: word;
		endurancemax: word;
		armorclass	: integer;
		thac0		: shortint;
		damage		: string; {roll}
		attacktype	: string;
		savingthrow	: byte;
		morale		: byte;
		xpvalue		: word;
		treasure	: string; {roll}
		coins		: word;
		numspells	: byte;
		spell		: spellarray;
	end;

	chartrecord    = record
		value		: array[1..20,1..2] of byte;
		filename	: array[1..20] of string;
		number		: array[1..20] of string; {roll}
		diceroll	: string; {roll}
	end;


function exist(dosname:string):boolean;

IMPLEMENTATION

{--------------------------------------------------------------------------}
function exist(dosname:string) : boolean;

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

begin

end.