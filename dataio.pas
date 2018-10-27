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
	
	itemmax		= 8;
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


function capitalize(capstring:string):string;
function itempicfile(theitem:item):string;
function spellstring(thespell:spell):string;
function itemstring(theitem:item):string;
function exist(dosname:string):boolean;
procedure existorquit(filename:string);
function openandseek(var f:text;filename,search:string):boolean;
procedure readmatrix(filename,matrixid:string;var m:matrix);
procedure readchart(chartfile,chartid:string;var chart:chartrecord);
procedure writegame(filename:string;player:character_t);
procedure readgame(filename:string;var player:character_t);
procedure readmonster(filename,monsterid:string;var monster:monsterrecord);

IMPLEMENTATION

{--------------------------------------------------------------------------}
function capitalize(capstring:string):string;

var
   loop        : word;

begin
     for loop:=1 to length(capstring) do
          capstring[loop]:=upcase(capstring[loop]);
     capitalize:=capstring;
end;
{---------------------------------------------------------------------------}
function itempicfile(theitem:item):string;

begin
    case theitem of
        sword           :   itempicfile:='sword.bmp';
        shield          :   itempicfile:='shield.bmp';
        axe             :   itempicfile:='axe.bmp';
        bluepotion      :   itempicfile:='potion-b.bmp';
        redpotion       :   itempicfile:='potion-r.bmp';
        greenpotion     :   itempicfile:='potion-g.bmp';
        chainmail       :   itempicfile:='chain.bmp';
        platemail       :   itempicfile:='plate.bmp';
        dagger          :   itempicfile:='dagger.bmp';
        club            :   itempicfile:='club.bmp';
        staff           :   itempicfile:='staff.bmp';
        hammer          :   itempicfile:='hammer.bmp';
        magicsword      :   itempicfile:='magicswd.bmp';
        magicshield     :   itempicfile:='magicshl.bmp';
        flamewand       :   itempicfile:='flamewnd.bmp';
    else
        itempicfile:='blank.bmp';
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
procedure existorquit(filename:string);

{Basically die if file doesn't exist.}

begin
    if not(exist(filename)) then
    begin
        writeln('Could not open '+filename);
        halt(1);
    end;
end;
{--------------------------------------------------------------------------}
function openandseek(var f:text;filename,search:string):boolean;

{
Opens a file and searches for a line that matches a particular string.
    * If the search is found:
        1) f is returned opened with the pointer at the next line
        2) function result is true
    * If search is not found:
        1) f is returned closed
        2) function result is false
}

var
    s           :   string;
    loc         :   integer;
    found       :   boolean;

begin
    existorquit(filename);
    loc:=0;
    found:=false;
    assign(f,filename);
    reset(f);
    while not((seekeof(f)) or (loc>0)) do
    begin
        readln(f,s);
        loc:=pos(search,s);
    end;

    if (loc>0) then
        found:=true
    else
        close(f);

    openandseek:=found;
end;
{--------------------------------------------------------------------------}
procedure readmatrix(filename,matrixid:string;var m:matrix);

var
	f	: text;
	row	: byte;
	col	: byte;

begin
	existorquit(filename);

	if not(openandseek(f,filename,'~'+matrixid)) then
	begin
		writeln('Could not find '+matrixid);
		halt(1);
	end;

	for row:=1 to rowmax do
	begin
		for col:=1 to colmax do
			read(f,m[col,row]);
		readln(f);
	end;
	close(f);
end;
{--------------------------------------------------------------------------}
procedure readchart(chartfile,chartid:string;var chart:chartrecord);

var
    pasfile         :   text;
    lineoftext      :   string;
    search          :   string;
    loop            :   integer;
    ch              :   char;
    split           :   integer;

begin
    existorquit(chartfile);
    assign(pasfile,chartfile);
    reset(pasfile);

    lineoftext:='';
    search:='~'+chartid;
    while not ( (seekeof(pasfile)) or (pos(search,lineoftext)>0) ) do
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

end;
{--------------------------------------------------------------------------}
procedure writegame(filename:string;player:character_t);

var
     savefile   :    text;
     loop       :   integer;
     st         :   stage;

begin
     assign(savefile,filename);
     rewrite(savefile);
     with player do
     begin
        writeln(savefile,name);
        writeln(savefile,picfile);
        writeln(savefile,sex);
        writeln(savefile,level);
        writeln(savefile,endurance);
        writeln(savefile,endurancemax);
        writeln(savefile,armorclass);
        writeln(savefile,thac0);
        writeln(savefile,damage);
        writeln(savefile,savingthrow);
        writeln(savefile,experience);
        writeln(savefile,coins);
        writeln(savefile,numitems);
        for loop:=1 to numitems do
            writeln(savefile,item[loop]);
        writeln(savefile,numspells);
        for loop:=1 to numspells do
            writeln(savefile,spell[loop]);
        writeln(savefile,strength);
        writeln(savefile,dexterity);
        writeln(savefile,charges);
        writeln(savefile,chargemax);
        for st:=ring to endgame do
            if (st in stages) then
                writeln(savefile,st);
    end;
    close(savefile);

end;
{--------------------------------------------------------------------------}
procedure readgame(filename:string;var player:character_t);

var
    savefile        :   text;
    loop            :   integer;
    st              :   stage;

begin
	assign(savefile,filename);
	reset(savefile);
    with player do
    begin
        readln(savefile,name);
        readln(savefile,picfile);
        readln(savefile,sex);
        readln(savefile,level);
        readln(savefile,endurance);
        readln(savefile,endurancemax);
        readln(savefile,armorclass);
        readln(savefile,thac0);
        readln(savefile,damage);
        readln(savefile,savingthrow);
        readln(savefile,experience);
        readln(savefile,coins);
        readln(savefile,numitems);
        for loop:=1 to numitems do
            readln(savefile,item[loop]);
        readln(savefile,numspells);
        for loop:=1 to numspells do
            readln(savefile,spell[loop]);
        readln(savefile,strength);
        readln(savefile,dexterity);
        readln(savefile,charges);
        readln(savefile,chargemax);
        stages:=[];
        while not(seekeof(savefile)) do
        begin
            readln(savefile,st);
            stages:=stages + [st];
        end;
    end;
	close(savefile);
end;
{--------------------------------------------------------------------------}
procedure readmonster(filename,monsterid:string;var monster:monsterrecord);

var
    f       :   text;
    loop    :   integer;

begin
    if not(openandseek(f,filename,'~'+monsterid)) then
    begin
        writeln('Could not find '+monsterid);
        halt(1);
    end;

    {load}
    with monster do
    begin
        readln(f,name);
        readln(f,picfile);
        readln(f,sex);
        readln(f,alignment);
        readln(f,hitdice);
        readln(f,hpbonus);
        {endurance}
        {endurancemax}
        readln(f,armorclass);
        readln(f,thac0);
        readln(f,damage);
        readln(f,attacktype);
        readln(f,savingthrow);
        readln(f,morale);
        readln(f,xpvalue);
        readln(f,treasure);
        {coins}
        readln(f,numspells);
        for loop:=1 to numspells do
             readln(f,spell[loop]);
    end;

    close(f);

end;
{--------------------------------------------------------------------------}


begin

end.
