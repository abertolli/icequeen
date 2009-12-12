const

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
     leftpic        =    'msoldier.ln1';
     rightpic       =    'landon.ln1';
     chartile       =    'chartile.ln1';
     savedefault    =    'game.sav';

     TXT_dir        =    'text/';
     PIC_dir        =    'img/';
     MAP_dir        =    'map/';
     MON_dir        =    'monst/';
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
     itemmax        =    9;        {number of items a character can carry}
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
     item           =    (sword,shield,axe,bluepotion,redpotion,greenpotion,
                          chainmail,platemail,dagger,club,staff,hammer,
                          magicsword,magicshield,flamewand);
     spell          =    (icestorm,fireblast,web,callwild,heal,courage,freeze,
                          obliterate,icicle,power,shatter,glacier,
                          dragonbreath,resistfire,resistcold);
     stage          =    (ring,dragon,dilvish,baltar,key,unlocked,msword,
                          mshield,knight,treasure,lizard,iceq,endgame);
                         {keep endgame as the last enum type}
     location       =    (town,wilderness,dungeon);
     matrix         =    array[1..colmax,1..rowmax] of integer;
     itemarray      =    array[1..itemmax] of item;
     spellarray     =    array[1..spellmax] of spell;
     dicerecord     =    record
        rollnum        :    word;
        dicetype       :    word;
        bonus          :    integer;
                         end;
     playerrecord   =    record
        name           :    string;
        picfile        :    string;
        sex            :    char;
        level          :    byte;
        endurance      :    word;
        endurancemax   :    word;
        armorclass     :    integer;
        thac0          :    shortint;
        damage         :    dicerecord;
        savingthrow    :    byte;
        experience     :    longint;
        coins          :    longint;
        numitems       :    byte;
        item           :    itemarray;
        numspells      :    byte;
        spell          :    spellarray;
        strength       :    byte;
        dexterity      :    byte;
        stages         :    set of stage;
        charges        :    byte;
        chargemax      :    byte;
                         end;
     monsterrecord  =    record
        name           :    string;
        picfile        :    string;
        sex            :    char;
        alignment      :    char;
        hitdice        :    byte;
        hpbonus        :    shortint;
        endurance      :    word;
        endurancemax   :    word;
        armorclass     :    integer;
        thac0          :    shortint;
        damage         :    dicerecord;
        attacktype     :    string;
        savingthrow    :    byte;
        morale         :    byte;
        xpvalue        :    word;
        treasure       :    dicerecord;
        coins          :    word;
        numspells      :    byte;
        spell          :    spellarray;
                         end;
     monsterlist    =    array[1..monstermax] of monsterrecord;
     chartrecord    =    record
        value          :    array[1..20,1..2] of byte;
        filename       :    array[1..20] of string;
        number         :    array[1..20] of dicerecord;
        diceroll       :    dicerecord;
                         end;
     effectrecord    =    record
        blue           :    boolean;
        courage        :    boolean;
        resistfire     :    boolean;
        resistcold     :    boolean;
        glacier        :    boolean;
                          end;
     effectlist      =    array[1..monstermax] of effectrecord;

