{
	DATAIO.PAS
	Copyright (C) 1996-2010 Angelo Bertolli
}

unit DataIO;

INTERFACE

const

	{used for maps}
	rowmax	= 14;	  {number of rows on a map}
	colmax	= 20;	  {number of columns on a map}
	
	itemmax		= 9;
	spellmax	= 8;	{number of spells that can be in the ring}

    chartdata   = 'game/chart.dat';

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

	{
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
    }

    item        = (sword,shield,axe,bluepotion,redpotion,greenpotion,chainmail,platemail,dagger,club,staff,hammer,magicsword,magicshield,flamewand);

	itemarray	= array[1..itemmax] of item;
	
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
		diceroll	: string; {roll}
		value		: array[1..20,1..2] of byte;
		number		: array[1..20] of string; {roll}
		monsterid	: array[1..20] of string;
	end;


function itempicfile(theitem:item):string;
function spellstring(thespell:spell):string;
function itemstring(theitem:item):string;
function exist(dosname:string):boolean;
function getchart(chartid:string):chartrecord;

IMPLEMENTATION

{---------------------------------------------------------------------------}
function itempicfile(theitem:item):string;

begin
    case theitem of
        sword           :   itempicfile:='sword.ln1';
        shield          :   itempicfile:='shield.ln1';
        axe             :   itempicfile:='axe.ln1';
        bluepotion      :   itempicfile:='potion1.ln1';
        redpotion       :   itempicfile:='potion2.ln1';
        greenpotion     :   itempicfile:='potion3.ln1';
        chainmail       :   itempicfile:='chain.ln1';
        platemail       :   itempicfile:='plate.ln1';
        dagger          :   itempicfile:='dagger.ln1';
        club            :   itempicfile:='club.ln1';
        staff           :   itempicfile:='staff.ln1';
        hammer          :   itempicfile:='hammer.ln1';
        magicsword      :   itempicfile:='magicswd.ln1';
        magicshield     :   itempicfile:='magicshl.ln1';
        flamewand       :   itempicfile:='flamewnd.ln1';
    else
        itempicfile:='blank.ln1';
    end;{case}

end;

{---------------------------------------------------------------------------}
function spellstring(thespell:spell):string;

begin
	case thespell of
	     icestorm       :   spellstring:='ice storm';
	     fireblast      :   spellstring:='fire blast';
	     web            :   spellstring:='web';
	     callwild       :   spellstring:='call wild';
	     heal           :   spellstring:='heal';
	     courage        :   spellstring:='courage';
	     freeze         :   spellstring:='freeze';
	     obliterate     :   spellstring:='obliterate';
	     icicle         :   spellstring:='icicle';
	     power          :   spellstring:='power';
	     shatter        :   spellstring:='shatter';
	     glacier        :   spellstring:='glacier';
	     dragonbreath   :   spellstring:='dragon breath';
	     resistfire     :   spellstring:='resist fire';
	     resistcold     :   spellstring:='resist cold';
	end;{case}
end;

{---------------------------------------------------------------------------}
function itemstring(theitem:item):string;

begin
    case theitem of
        sword           :   itemstring:='sword';
        shield          :   itemstring:='shield';
        axe             :   itemstring:='axe';
        bluepotion      :   itemstring:='blue potion';
        redpotion       :   itemstring:='red potion';
        greenpotion     :   itemstring:='green potion';
        chainmail       :   itemstring:='chain mail';
        platemail       :   itemstring:='plate mail';
        dagger          :   itemstring:='dagger';
        club            :   itemstring:='club';
        staff           :   itemstring:='staff';
        hammer          :   itemstring:='hammer';
        magicsword      :   itemstring:='magic sword';
        magicshield     :   itemstring:='magic shield';
        flamewand       :   itemstring:='flame wand';
    end;{case}
end;
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
function getchart(chartid:string):chartrecord;

var
    pasfile         :   text;
    chart           :   chartrecord;
    lineoftext      :   string;
    search          :   string;
    loop            :   integer;
    ch              :   char;
    split           :   integer;

begin
    
    if not(exist(chartdata)) then
    begin
        writeln('Could not open '+chartdata);
        halt(1);
    end;
    assign(pasfile,chartdata);
    reset(pasfile);

    lineoftext:='';
    search:='~'+chartid;
    while not ( (eof(pasfile)) or (pos(search,lineoftext)>0) ) do
        readln(pasfile,lineoftext);

    if not (pos(search,lineoftext)>0) then
    begin
        writeln('Could not find '+chartid);
        halt(1);
    end;

    with chart do
    begin
        readln(pasfile,diceroll);
        for loop:=1 to 20 do
        begin
            read(pasfile,value[loop,1]);
            read(pasfile,value[loop,2]);
            read(pasfile,ch);
            readln(pasfile,lineoftext);
            split:=pos(':',lineoftext);
            number[loop]:=copy(lineoftext,1,split-1);
            monsterid[loop]:=copy(lineoftext,split+1,length(lineoftext));
        end;
    end;
	close(pasfile);

    getchart:=chart;

end;
{--------------------------------------------------------------------------}

begin

end.
