{$ifndef CONFIG.PAS}

const
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
	dungeonchart	= 'dungeon.dat';

	leftpic		= 'msoldier';
	rightpic	= 'landon';
	chartile	= 'chartile';
	savedefault	= 'game.sav';

	textdir		= 'text/';
	imagedir	= 'img/';
	mapdir		= 'map/';
	chartdir	= 'chart/';
	savedir		= 'save/';
	itemdir		= 'item';
	monsterdir	= 'monst';

{$define CONFIG.PAS}
{$endif}
