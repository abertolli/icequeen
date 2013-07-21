	version		= '3.0';

	reward		= 100000;

        {
        maps - the displayed map
        codes - the underlying meaning
        }
	surfacemap	= 'game/surface.map';
	surfacecode	= 'game/surface.dat';
	cavemap		= 'game/cave.map';
	cavecode	= 'game/cave.dat';
	castlemap	= 'game/castle.map';
	castlecode	= 'game/castle.dat';
	dungeonmap	= 'game/dungeon.map';
	dungeoncode	= 'game/dungeon.dat';

	chartile	= 'chartile.ln1';
	savedefault	= 'game.sav';

	savedir		= 'save/';
	itemdir		= 'item';
    chartfile   = 'game/charts.dat';
	monsterfile	= 'game/monsters.dat';
    textfile    = 'game/text.dat';

	{used for text columns}
	col1	= 20;	 {column 1 for viewing stats}
	col2	= 240;	 {column 2 for viewing stats}
	col3	= 440;	 {column 3 for viewing stats}

	{encounters}
	wildchance		= 10;	  {% chance per square to encounter.}
	roadchance		= 5;		{% chance per square on the road.}
	dungeonchance	= 20;	  {% chance per square in the dungeon.}

	{combat constants}
	spacing		= 25;	  {spacing between pictures}

	monstermax	= 8;	{number of monsters in one battle}
	xpmultiplier= 5;	{xp value multiplier for monsters}
	maxlevel	= 12;	{number of levels character can achieve}
	ringmax		= 20;	{maximum charges a ring can have}

    menumax     =   9;     {Max no of menu items}

