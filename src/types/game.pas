const

     version        =    '3.0';

     reward         =    100000;

     surfacemap     =    'surface.map';
     surfacecode    =    'surface.cod';
     cavemap        =    'cave.map';
     cavecode       =    'cave.cod';
     castlemap      =    'castle.map';
     castlecode     =    'castle.cod';
     dungeonmap     =    'dungeon.map';
     dungeoncode    =    'dungeon.cod';
     wildchart      =    'wild.dat';
     cavechart      =    'cave.dat';
     castlechart    =    'castle.dat';
     dungeonchart   =    'dungeon.dat';
     leftpic        =    'msoldier.bmp';
     rightpic       =    'landon.bmp';
     chartile       =    'chartile.bmp';
     savedefault    =    'game.sav';

     TXT_dir        =    'text/';
     PIC_dir        =    'img/';
     MAP_dir        =    'map/';
     CHT_dir        =    'chart/';
     SAV_dir        =    'save/';

     {used for text columns}
     col1           =    20;       {column 1 for viewing stats}
     col2           =    240;      {column 2 for viewing stats}
     col3           =    440;      {column 3 for viewing stats}

     {used for maps}
     rowmax         =    14;       {number of rows on a map}
     colmax         =    20;       {number of columns on a map}

     monstermax     =    8;        {number of monsters in one battle}
     spellmax       =    8;        {number of spells that can be in the ring}
     maxlevel       =    12;       {number of levels character can achieve}
     ringmax        =    20;       {maximum charges a ring can have}

     {encounters}
     wildchance     =    10;       {% chance per square to encounter.}
     roadchance     =    5;        {% chance per square on the road.}
     dungeonchance  =    20;       {% chance per square in the dungeon.}

     {combat constants}
     spacing        =    25;       {spacing between pictures}

     xpmultiplier   =    5;        {xp value multiplier for monsters}

type
     spell          =    (icestorm,fireblast,web,callwild,heal,courage,freeze,
                          obliterate,icicle,power,shatter,glacier,
                          dragonbreath,resistfire,resistcold);
     matrix         =    array[1..colmax,1..rowmax] of integer;
     spellarray     =    array[1..spellmax] of spell;
     dicerecord     =    record
        rollnum        :    word;
        dicetype       :    word;
        bonus          :    integer;
                         end;
     stage          =    (ring,dragon,dilvish,baltar,key,unlocked,msword,
                          mshield,knight,treasure,lizard,iceq,endgame);
                         {keep endgame as the last enum type}
     location       =    (town,wilderness,dungeon);
