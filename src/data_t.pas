const
	{used for text columns}
	col1	= 20;	  {column 1 for viewing stats}
	col2	= 240;	 {column 2 for viewing stats}
	col3	= 440;	 {column 3 for viewing stats}

	{used for maps}
	rowmax	= 14;	  {number of rows on a map}
	colmax	= 20;	  {number of columns on a map}

	monstermax	= 8;		{number of monsters in one battle}
	xpmultiplier	= 5;		{xp value multiplier for monsters}
	itemmax		= 9;
	spellmax	= 8;		{number of spells that can be in the ring}
	maxlevel	= 12;	  {number of levels character can achieve}
	ringmax		= 20;	  {maximum charges a ring can have}

	{encounters}
	wildchance	= 10;	  {% chance per square to encounter.}
	roadchance	= 5;		{% chance per square on the road.}
	dungeonchance	= 20;	  {% chance per square in the dungeon.}

	{combat constants}
	spacing		= 25;	  {spacing between pictures}


type
	spell		= (icestorm,fireblast,web,callwild,heal,courage,
                          freeze,obliterate,icicle,power,shatter,glacier,
                          dragonbreath,resistfire,resistcold);
	matrix		= array[1..colmax,1..rowmax] of integer;
	spellarray	= array[1..spellmax] of spell;
	dicerecord	= record
		rollnum		: word;
		dicetype	: word;
		bonus		: integer;
	end;
	{stages: keep endgame as the last enum type}
	stage		= (ring,dragon,dilvish,baltar,key,unlocked,msword,mshield,knight,treasure,lizard,iceq,endgame);
	location	= (town,wilderness,dungeon);

	item_t		= record
		name		: string;
		item_type	: byte;
		value		: word;
		picfile		: string;
		msg		: string;
		data		: array[1..8] of shortint;
	end;

	itemarray	= array[1..itemmax] of item_t;
	character_t	= record
		name		: string;
		picfile		: string;
		sex		: char;
		level		: byte;
		endurance	: word;
		endurancemax	: word;
		armorclass	: integer;
		thac0		: shortint;
		damage		: dicerecord;
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
		sex		: char;
		alignment	: char;
		hitdice		: byte;
		hpbonus		: shortint;
		endurance	: word;
		endurancemax	: word;
		armorclass	: integer;
		thac0		: shortint;
		damage		: dicerecord;
		attacktype	: string;
		savingthrow	: byte;
		morale		: byte;
		xpvalue		: word;
		treasure	: dicerecord;
		coins		: word;
		numspells	: byte;
		spell		: spellarray;
	end;

	monsterlist    = array[1..monstermax] of monsterrecord;
	chartrecord    = record
		value		: array[1..20,1..2] of byte;
		filename	: array[1..20] of string;
		number		: array[1..20] of dicerecord;
		diceroll	: dicerecord;
	end;

	effectrecord    = record
		blue		: boolean;
		courage		: boolean;
		resistfire	: boolean;
		resistcold	: boolean;
		glacier		: boolean;
					 end;
	effectlist	 = array[1..monstermax] of effectrecord;

