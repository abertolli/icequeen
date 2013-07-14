	version		= '3.0';

	reward		= 100000;

        {
        maps - the displayed map
        codes - the underlying meaning
        }
	surfacemap	= 'surface.map';
	surfacecode	= 'surface.cod';
	cavemap		= 'cave.map';
	cavecode	= 'cave.cod';
	castlemap	= 'castle.map';
	castlecode	= 'castle.cod';
	dungeonmap	= 'dungeon.map';
	dungeoncode	= 'dungeon.cod';
        {
        charts - wandering monster charts
        }
	wildchart	= 'wild.dat';
	cavechart	= 'cave.dat';
	castlechart	= 'castle.dat';
	dungeonchart= 'dungeon.dat';

	chartile	= 'chartile.ln1';
	savedefault	= 'game.sav';

	textdir		= 'text/';
	imagedir	= 'img/';
	mapdir		= 'map/';
	chartdir	= 'chart/';
	savedir		= 'save/';
	itemdir		= 'item';
	monsterdata	= 'monst.dat';
	chartdata	= 'chart.dat';

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

