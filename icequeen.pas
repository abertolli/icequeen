{
	ICEQUEEN.PAS
	Ice Queen - Main program
	Copyright (C) 1996-2010 Angelo Bertolli
}

{$mode TP}
{$ifdef Win32}
{$apptype GUI}
{$r icequeen.res}
{$endif}

program IceQueen;

uses
	{$ifdef Win32}
	wincrt, graph, graphio, dataio, dice;
	{$else}
	graphio, dataio, dice;
	{$endif}

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
	dungeonchart= 'dungeon.dat';

	chartile	= 'chartile.ln1';
	savedefault	= 'game.sav';

	textdir		= 'text/';
	imagedir	= 'img/';
	mapdir		= 'map/';
	chartdir	= 'chart/';
	savedir		= 'save/';
	itemdir		= 'item';
	monsterdir	= 'monst';

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


type

	monsterlist    = array[1..monstermax] of monsterrecord;
	effectrecord    = record
		blue		: boolean;
		courage		: boolean;
		resistfire	: boolean;
		resistcold	: boolean;
		glacier		: boolean;
					 end;
	effectlist	 = array[1..monstermax] of effectrecord;

var
	GAMEOVER	: boolean;
	x			: integer;
	y			: integer;
	nummonsters	: integer;
	monster		: monsterlist;
	player		: character_t;


{--------------------------------------------------------------------------}
function CAPITALIZE(capstring:string):string;

{CAPITALIZE is returned as capstring in all caps.}

var
   loop        : word;

begin
     for loop:=1 to length(capstring) do
          capstring[loop]:=upcase(capstring[loop]);
     capitalize:=capstring;
end;

{-------------------------------------------------------------------------}
procedure drawpic(beginx,beginy:integer;dosname:string);

var
   previouscolor: word;

begin
   dosname:=imagedir+dosname;
   if not(exist(dosname)) then
      begin
         previouscolor:=getcolor;
         setcolor(lightblue);
         setfont('default.ttf',1);
         outtextxy(beginx,beginy,dosname);
	 setcolor(previouscolor);
      end
   else
      drawpicturebyline(beginx,beginy,dosname);
end;
{---------------------------------------------------------------------------}
procedure drawmaptile(xpos,ypos:integer;themap:matrix);

var
	xpix           :    integer;
	ypix           :    integer;
	tilenum        :    integer;
	filename       :    string;

begin
	xpix:=41;
	ypix:=41;
	xpix:=xpix + ((xpos - 1) * 20);         {tile size = 20}
	ypix:=ypix + ((ypos - 1) * 20);
	tilenum:=themap[xpos,ypos];
	case tilenum of
             1:filename:='town.ln1';
             2:filename:='cave.ln1';
             3:filename:='grass.ln1';
             4:filename:='hill.ln1';
             5:filename:='mountain.ln1';
             6:filename:='road.ln1';
             7:filename:='swamp.ln1';
             8:filename:='desert.ln1';
             9:filename:='whitemt.ln1';
             10:filename:='castle.ln1';
             11:filename:='snow.ln1';
             12:filename:='inn.ln1';
             13:filename:='ground.ln1';
             14:filename:='dgt.ln1';
             15:filename:='dww.ln1';
             16:filename:='dnw.ln1';
             17:filename:='dew.ln1';
             18:filename:='dsw.ln1';
             19:filename:='dnwc.ln1';
             20:filename:='dnsw.ln1';
             21:filename:='dsec.ln1';
             22:filename:='dnec.ln1';
             23:filename:='dswc.ln1';
             24:filename:='deww.ln1';
             25:filename:='dna.ln1';
             26:filename:='dea.ln1';
             27:filename:='dwa.ln1';
             28:filename:='dsa.ln1';
             29:filename:='blank.ln1';
	else
             filename:='blank';
	end;
	drawpic(xpix,ypix,filename);
end;

{Title and Main Menu Functions and Procedures}
{--------------------------------------------------------------------------}
procedure titlescreen;

{Ice Queen title screen}

var
    center      :   integer;

begin
    center:=getmaxx DIV 2;
    setfont('gothic.ttf',8);
    setcolor(blue);
    centerwrite(center+3,383,'The Ice Queen');
    setcolor(white);
    centerwrite(center,380,'The Ice Queen');
    setfont('default.ttf',2);
    drawpic(120,10,'tcastle.ln1');
    setfont('default.ttf',2);
    setcolor(lightgray);
    prompt;
end;
{---------------------------------------------------------------------------}
procedure startgame(var player:character_t);

{Starts you off by creating a character.}

const
	MINSCORE       =    3;
	MAXSCORE       =    18;

var
	tempstring     :    string;
	points         :    byte;
	tempint        :    shortint;
	current        :    boolean;
	done           :    boolean;
	validchange    :    boolean;
	basestr        :    byte;
	basedex        :    byte;
	ch             :    char;
	ans            :    char;

begin
	setfont('sanseri.ttf',2);
	repeat
	     cleardevice;
	     homecursor(x,y);
	     setcolor(blue);
	     graphwriteln(x,y,'            CREATE YOUR CHARACTER');
	     graphwriteln(x,y,'');
	     setcolor(white);
	     with player do
	          begin
	               graphwrite(x,y,'Enter name:  ');

	               graphread(x,y,tempstring);
	               name:=tempstring;
	               if (name='') then
	                    begin
	                         graphwrite(x,y,'Landon');
	                         name:='Landon';
	                    end;
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'');
	               graphwrite(x,y,'Sex (M/F)  ');
	               repeat
	                    sex:=readarrowkey;
	               until (sex in ['m','M','f','F']);
	               outtextxy(x,y,sex);
	               if (sex in ['m','M']) then
                            drawpic(x+200,y,'mplayer.ln1')
	               else
                            drawpic(x+200,y,'fplayer.ln1');
	               graphwriteln(x,y,'');
	               setcolor(white);
	               level:=1;
	               experience:=0;
	               endurancemax:=8;
	               endurance:=endurancemax;
	               graphwrite(x,y,'Endurance: ');
	               str(endurancemax,tempstring);
	               graphwriteln(x,y,tempstring);
	               points:=roll('5d6');
	               strength:=roll('1d6');
	               dexterity:=roll('1d6');
	               tempint:=MINSCORE - strength;
	               if (tempint>0) then
	                  begin
	                     strength:=strength + tempint;
	                     points:=points - tempint;
	                  end;
	               tempint:=MINSCORE - dexterity;
	               if (tempint>0) then
	                  begin
	                     dexterity:=dexterity + tempint;
	                     points:=points - tempint;
	                  end;
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'Modify your stats:');
	               current:=true;
	               done:=false;
	               basestr:=strength;
	               basedex:=dexterity;
	               repeat
	                  setfillstyle(solidfill,black);
	                  bar(0,200,300,300);
	                  y:=200;
	                  graphwrite(x,y,'Points: ');
	                  str(points,tempstring);
	                  graphwriteln(x,y,tempstring);
	                  graphwriteln(x,y,'');
	                  if (current) then setcolor(lightcyan);
	                  graphwrite(x,y,'Strength: ');
	                  str(strength,tempstring);
	                  graphwriteln(x,y,tempstring);
	                  setcolor(white);
	                  if not(current) then setcolor(lightcyan);
	                  graphwrite(x,y,'Dexterity: ');
	                  str(dexterity,tempstring);
	                  graphwriteln(x,y,tempstring);
	                  setcolor(white);
	                  graphwriteln(x,y,'');
	                  setfont('default.ttf',4);
	                  graphwriteln(x,y,'Use the arrow keys.');
	                  graphwriteln(x,y,'Press <Enter> when done.');
	                  setfont('sanseri.ttf',2);
	                  validchange:=false;
	                  repeat
	                     ch:=readarrowkey;
	                     case ch of
	                        '8':if not(current) then
	                               begin
	                                  current:=true;
	                                  validchange:=true;
	                               end;
	                        '2':if (current) then
	                               begin
	                                  current:=false;
	                                  validchange:=true;
	                               end;
	                        '6':begin
	                               if (current)and(strength<MAXSCORE)and(points>0) then
	                                  begin
	                                     strength:=strength+1;
	                                     points:=points-1;
	                                     validchange:=true;
	                                  end;
	                               if not(current)and(dexterity<MAXSCORE)and(points>0) then
	                                  begin
	                                     dexterity:=dexterity+1;
	                                     points:=points-1;
	                                     validchange:=true;
	                                  end;
	                            end;
	                        '4':begin
	                               if (current)and(strength>basestr) then
	                                  begin
	                                     strength:=strength-1;
	                                     points:=points+1;
	                                     validchange:=true;
	                                  end;
	                               if not(current)and(dexterity>basedex) then
	                                  begin
	                                     dexterity:=dexterity-1;
	                                     points:=points+1;
	                                     validchange:=true;
	                                  end;
	                            end;
	                        #13:begin
	                               validchange:=true;
	                               done:=true;
	                            end;
	                     end;{case}
	                  until (validchange);
	               until (done);
	               coins:=(roll('3d6')+(points*10)) * 10;
	               graphwriteln(x,y,'');
	               graphwrite(x,y,'Coins: ');
	               str(coins,tempstring);
	               graphwriteln(x,y,tempstring);
	               if (sex in ['m','M']) then
                            picfile:='mplayer'
	               else
                            picfile:='fplayer';
	               numitems:=0;
	               numspells:=0;
	               stages:=[];
	               charges:=0;
	               chargemax:=0;
	          end;
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'          Keep this character (Y/N)');
	     repeat
	          ans:=readarrowkey;
	     until(ans in ['y','Y','n','N']);
	until (ans in ['y','Y']);

end;
{---------------------------------------------------------------------------}
procedure loadgame(var player:character_t);

var
	dosname        :    string;
	done           :    boolean;
	pasfile        :    file of character_t;
	ans            :    char;

begin
	done:=false;
	repeat
	     cleardevice;
	     homecursor(x,y);
	     setcolor(lightgray);
	     setfont('sanseri.ttf',3);
	     graphwriteln(x,y,'[default: '+savedefault+']');
	     graphwriteln(x,y,'');
	     setfont('sanseri.ttf',4);
	     graphwrite(x,y,'Enter File Name: ');
	     setcolor(lightblue);
	     graphread(x,y,dosname);
	     if (dosname='') then
	          dosname:=savedefault;
	     setfont('sanseri.ttf',5);
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'');
	     setcolor(lightgray);
	     if exist(savedir+dosname) then
	          begin
	               graphwriteln(x,y,'Loading...');
	               assign(pasfile,savedir+dosname);
	               reset(pasfile);
	               read(pasfile,player);
	               close(pasfile);
	               done:=true;
	          end
	     else
	          begin
	               setcolor(red);
	               graphwriteln(x,y,'  Sorry, file does not exist.');
	               setfont('sanseri.ttf',3);
	               setcolor(lightgray);
	               x:=10;
	               y:=300;
	               graphwriteln(x,y,'                 (L)oad or (S)tart');
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['l','L','s','S']);
	               if (ans in ['s','S']) then
	                    begin
	                         startgame(player);
	                         done:=true;
	                    end;
	          end;
	until done;
end;

{Calc Stats, View Stats, and Drop Item Procedures}
{---------------------------------------------------------------------------}
procedure calcstats(var player:character_t);

{Calculates the player stats based on level, xp, etc. and returns it.}



var
	tempinteger    :    integer;
	count          :    integer;
    tempset        :    set of item;
    dmgbonus       :    integer;
    tempstring      :   string;

begin
	with player do
	     begin
	          if(level=1)and(experience>=2000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=2)and(experience>=4000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=3)and(experience>=8000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=4)and(experience>=16000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=5)and(experience>=32000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=6)and(experience>=64000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=7)and(experience>=120000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=8)and(experience>=240000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=9)and(experience>=360000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=10)and(experience>=480000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          if(level=11)and(experience>=600000)then
	               begin
	                    level:=level + 1;
	                    tempinteger:=roll('1d8');
	                    endurancemax:=endurancemax+tempinteger;
	                    endurance:=endurance+tempinteger;
	               end;
	          case level of
	            1..3:savingthrow:=16;
	            4..6:savingthrow:=14;
	            7..9:savingthrow:=12;
	          else
	               savingthrow:=10;
	          end;{case}
	          case level of
	            1..3:thac0:=19;
	            4..6:thac0:=17;
	            7..9:thac0:=15;
	          else
	               thac0:=13;
	          end;{case}
	          case strength of
	               1:thac0:=thac0+5;
	               2:thac0:=thac0+4;
	               3:thac0:=thac0+3;
	            4..5:thac0:=thac0+2;
	            6..8:thac0:=thac0+1;
	          13..15:thac0:=thac0-1;
	          16..17:thac0:=thac0-2;
	              18:thac0:=thac0-3;
	              19:thac0:=thac0-4;
	              20:thac0:=thac0-5;
	          end;{case}
	          tempset:=[];
	          for count:=1 to numitems do
	               tempset:=tempset + [item[count]];
	          armorclass:=9;
	          if(magicshield in tempset)then
	               armorclass:=armorclass-4
	          else
	               if(shield in tempset)then
	                    armorclass:=armorclass-1;
	          if(platemail in tempset)then
	               armorclass:=armorclass-6
	          else
	               if(chainmail in tempset)then
	                    armorclass:=armorclass-4;
	          case dexterity of
	               1:armorclass:=armorclass+5;
	               2:armorclass:=armorclass+4;
	               3:armorclass:=armorclass+3;
	            4..5:armorclass:=armorclass+2;
	            6..8:armorclass:=armorclass+1;
	          13..15:armorclass:=armorclass-1;
	          16..17:armorclass:=armorclass-2;
	              18:armorclass:=armorclass-3;
	              19:armorclass:=armorclass-4;
	              20:armorclass:=armorclass-5;
	          end;
              damage:='1d2';
              dmgbonus:=0;
	          if (club in tempset)or(dagger in tempset) then
	               damage:='1d4';
	          if (hammer in tempset)or(staff in tempset) then
	               damage:='1d6';
	          if (axe in tempset)or(sword in tempset) then
	               damage:='1d8';
	          if(magicsword in tempset)then
	               begin
	                    damage:='1d8';
                        dmgbonus:=dmgbonus+3;
	                    if not(flamewand in tempset)then
	                         thac0:=thac0-3;
	               end;
	          if (flamewand in tempset) then
                    damage:='6d6';
	          if not(flamewand in tempset) then
	               case strength of
	                    1:dmgbonus:=dmgbonus-5;
	                    2:dmgbonus:=dmgbonus-4;
	                    3:dmgbonus:=dmgbonus-3;
	                 4..5:dmgbonus:=dmgbonus-2;
	                 6..8:dmgbonus:=dmgbonus-1;
	               13..15:dmgbonus:=dmgbonus+1;
	               16..17:dmgbonus:=dmgbonus+2;
	                   18:dmgbonus:=dmgbonus+3;
	                   19:dmgbonus:=dmgbonus+4;
	                   20:dmgbonus:=dmgbonus+5;
	               end;
              str(dmgbonus,tempstring);
              if (dmgbonus<0) then
                    damage:=damage + tempstring;
              if (dmgbonus>0) then
                    damage:=damage + '+' + tempstring;
	     end;
end;
{---------------------------------------------------------------------------}
procedure dropitem(var player:character_t);

var
	tempstring     :    string;
	tempinteger    :    integer;
	tempcode       :    integer;
	count          :    integer;
	ans            :    char;

begin
	cleardevice;
	homecursor(x,y);
	setfont('sanseri.ttf',3);
	with player do
	     if (numitems>0) then
	          begin
	               setcolor(lightblue);
	               graphwriteln(x,y,'   ITEMS');
	               setcolor(white);
	               for count:=1 to numitems do
	                    begin
	                         str(count,tempstring);
                             {
	                         tempstring:=tempstring + '. ' + item[count].name;
                             }
                             tempstring:=tempstring + '. ' + itemstring(item[count]);
	                         graphwriteln(x,y,tempstring);
	                    end;
	               graphwriteln(x,y,'Drop which one?');
	               str(numitems,tempstring);
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['1'..tempstring[1]]);
	               graphwriteln(x,y,'');
	               val(ans,tempinteger,tempcode);
                   {
	               tempstring:=item[tempinteger].name;
                   }
	               tempstring:=itemstring(item[tempinteger]);
	               graphwrite(x,y,tempstring);
	               graphwriteln(x,y,' will be gone forever.  Drop? (y/n)');
	               drawpic(280,(numitems+7)*textheight('M'),itempicfile(item[tempinteger]));
	               repeat
	                    ans:=readarrowkey;
	               until(ans in ['y','Y','n','N']);
	               if (ans in ['y','Y']) then
	                    begin
	                         for count:=tempinteger to (numitems-1) do
	                              item[count]:=item[count+1];
	                         numitems:=numitems - 1;
	                    end;
	          end;
end;
{---------------------------------------------------------------------------}
procedure graphwritelncol1(var x,y:integer;gstring:string);

begin
	x:=col1;
	graphwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure graphwritelncol2(var x,y:integer;gstring:string);

begin
	x:=col2;
	graphwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure graphwritelncol3(var x,y:integer;gstring:string);


begin
	x:=col3;
	graphwriteln(x,y,gstring);
end;
{---------------------------------------------------------------------------}
procedure viewstats(var player:character_t);

var
	tempstring     :    string;
	count          :    integer;
	score          :    integer;
	totalscore     :    integer;
	stageloop      :    stage;
	s2             :    string;
	ans            :    char;

begin
	repeat
	     cleardevice;
	     calcstats(player);
	     with player do
	          begin
	               drawpic(20,20,picfile);
	               setfont('triplex.ttf',4);
	               setcolor(white);
	               x:=240;
	               y:=25;
	               graphwriteln(x,y,name);
	               graphwriteln(x,y,'');
	               setfont('sanseri.ttf',2);
	               x:=200;
	               str(level,tempstring);
	               tempstring:='level: ' + tempstring;
	               graphwrite(x,y,tempstring);
	               graphwrite(x,y,'     ');
	               if (sex in ['m','M']) then
	                    graphwriteln(x,y,'male')
	               else
	                    graphwriteln(x,y,'female');
	               y:=140;
	               graphwriteln(x,y,'');
	               setcolor(lightred);
	               str(endurance,tempstring);
	               tempstring:='Endurance: ' + tempstring;
	               graphwrite(x,y,tempstring);
	               str(endurancemax,tempstring);
	               tempstring:='/' + tempstring;
	               graphwriteln(x,y,tempstring);
	               graphwriteln(x,y,'');
	               setcolor(lightgray);
	               str(armorclass,tempstring);
	               tempstring:='Armor Class: ' + tempstring;
	               graphwritelncol1(x,y,tempstring);
	               str(thac0,tempstring);
	               tempstring:='To Hit Roll: ' + tempstring;
	               graphwritelncol1(x,y,tempstring);
	               str(strength,tempstring);
	               tempstring:='Strength: ' + tempstring;
	               graphwritelncol1(x,y,tempstring);
	               str(dexterity,tempstring);
	               tempstring:='Dexterity: ' + tempstring;
	               graphwritelncol1(x,y,tempstring);
	               str(savingthrow,tempstring);
	               tempstring:='Saving Throw: ' + tempstring;
	               graphwritelncol1(x,y,tempstring);
	               x:=col1;
	               graphwriteln(x,y,'Damage: '+damage);
                       str(experience,tempstring);
                       tempstring:='Experience: ' + tempstring;
	               graphwritelncol1(x,y,tempstring);

	               score:=0;
	               totalscore:=0;
	               for stageloop:=ring to endgame do
	                    begin
	                         totalscore:=totalscore+1;
	                         if (stageloop in stages) then
	                              score:=score+1;
	                    end;
	               score:=(score DIV totalscore)*100;
	               str(score,tempstring);
	               tempstring:='Score: ' + tempstring + '%';
	               graphwritelncol1(x,y,tempstring);

	               graphwriteln(x,y,'');
	               setcolor(yellow);
	               str(coins,tempstring);
	               tempstring:='Coins: ' + tempstring;
	               graphwritelncol1(x,y,tempstring);
	               y:=140;
	               graphwriteln(x,y,'');
	               setcolor(lightblue);
	               for count:=1 to numitems do
	                    begin
                            {
	                         tempstring:=item[count].name;
                             }
                             tempstring:=itemstring(item[count]);
	                         graphwritelncol2(x,y,tempstring);
	                    end;
	               y:=140;
	               graphwriteln(x,y,'');
	               setcolor(lightmagenta);
	               for count:=1 to numspells do
	                    begin
	                         tempstring:=spellstring(spell[count]);
	                         graphwritelncol3(x,y,tempstring);
	                    end;
	               if (ring in stages) then
	                    begin
	                         setfont('sanseri.ttf',1);
	                         graphwritelncol3(x,y,'');
	                         str(charges,tempstring);
	                         tempstring:='Ring Charges: ' + tempstring;
	                         str(chargemax,s2);
	                         tempstring:=tempstring + '/' + s2;
	                         graphwritelncol3(x,y,tempstring);
	                    end;
	          end;
	     setcolor(lightgreen);
	     setfont('triplex.ttf',3);
	     y:=420;
	     x:=320 - (textwidth('(D)rop or (E)xit') DIV 2);
	     graphwriteln(x,y,'(D)rop or (E)xit');
	     repeat
	          ans:=readarrowkey;
	     until (ans in ['d','D','e','E']);
	     case ans of
	          'd','D':dropitem(player);
	          'e','E':exit;
	     end;{case}
	until FALSE
end;

{---------------------------------------------------------------------------}
procedure died;

var
   ch:char;

begin
	cleardevice;
	setcolor(darkgray);
	setfont('gothic.ttf',6);
	outtextxy(1,80,'      You have died...');
	setfont('sanseri.ttf',8);
	repeat
	     setcolor(roll('1d15'));
	     outtextxy(1,240,'   GAME OVER');
	until keypressed;
	ch:=readarrowkey;
	GAMEOVER:=TRUE;
end;

{Combat Functions and Procedures}
{---------------------------------------------------------------------------}
procedure rollmonsters(var monster:monsterlist;nummonsters:integer;
	                  monsterfile:string);

var

	pasfile        :    text;
    lineoftext     :    string;
	count          :    integer;
	tempmonster    :    monsterrecord;
	loop           :    word;

begin

    {reading monster data should be moved to dataio}

	if not(exist('monst.dat')) then
    begin
        writeln('Could not find monst.dat');
	    halt(1);
    end;
	assign(pasfile,'monst.dat');
	reset(pasfile);

    lineoftext:='';
    {Find the data}
    while not ( (eof(pasfile)) or (pos(monsterfile,lineoftext)>0) ) do
        readln(pasfile,lineoftext);

    if not (pos(monsterfile,lineoftext)>0) then
    begin
        writeln('Could not load '+monsterfile);
        halt(1);
    end;

    {Load the data}
    with tempmonster do
    begin
        readln(pasfile,name);
        readln(pasfile,picfile);
        readln(pasfile,sex);
        readln(pasfile,alignment);
        readln(pasfile,hitdice);
        readln(pasfile,hpbonus);
        {endurance}
        {endurancemax}
        readln(pasfile,armorclass);
        readln(pasfile,thac0);
        readln(pasfile,damage);
        readln(pasfile,attacktype);
        readln(pasfile,savingthrow);
        readln(pasfile,morale);
        readln(pasfile,xpvalue);
        readln(pasfile,treasure);
        {coins}
        readln(pasfile,numspells);
        for loop:=1 to numspells do
             readln(pasfile,spell[loop]);
    end;
	close(pasfile);

    {roll stats here}
	for count:=1 to nummonsters do
	     begin
	          monster[count]:=tempmonster;
	          with monster[count] do
	               begin
	                    endurancemax:=0;
	                    for loop:=1 to hitdice do
	                         endurancemax:=endurancemax + roll('1d8');
	                    if (hpbonus<0) and (endurancemax<(hpbonus*-1)) then
	                         endurancemax:=1
	                    else
	                         endurancemax:=endurancemax + hpbonus;
	                    if (endurancemax<=0) then
	                         endurancemax:=1;
	                    endurance:=endurancemax;
	                    xpvalue:=(monster[count].xpvalue*xpmultiplier)
	                             + (endurance DIV 2);
	                    coins:=roll(treasure);
	               end;
	     end;
end;
{---------------------------------------------------------------------------}
procedure combatmenuprompt;

var ch:char;

begin
	y:=450;
	setfont('default.ttf',1);
	graphwriteln(x,y,'       <press space>');
	ch:=readarrowkey;
end;
{---------------------------------------------------------------------------}
procedure clearcombatmenu;

begin

	setcolor(blue);
	setfillstyle(solidfill,blue);
	bar(40,300,200,460);
	setcolor(lightblue);
	rectangle(40,300,200,460);
	setcolor(lightcyan);
end;
{---------------------------------------------------------------------------}
procedure combatstats(player:character_t);

var
	tempstring     :    string;
	hitbar         :    word;

begin
	setcolor(blue);
	setfillstyle(solidfill,blue);
	bar(420,300,600,460);
	setcolor(lightblue);
	rectangle(420,300,600,460);
	setcolor(lightcyan);
	calcstats(player);
	x:=510 - (textwidth(player.name) DIV 2);
	y:=300;
	outtextxy(x,y,player.name);
	graphwriteln(x,y,'');
	x:=440;
	str(player.level,tempstring);
	tempstring:='Level: ' + tempstring;
	graphwriteln(x,y,tempstring);
	x:=440;
	str(player.endurance,tempstring);
	tempstring:='HP: ' + tempstring + '/';
	graphwrite(x,y,tempstring);
	str(player.endurancemax,tempstring);
	graphwriteln(x,y,tempstring);
	setcolor(lightgray);
	line(438,366,541,366);
	line(438,366,438,371);
	setcolor(black);
	line(439,367,541,367);
	line(439,370,541,370);
	line(439,367,439,370);
	line(541,367,541,370);
	hitbar:=(player.endurance DIV player.endurancemax)*100;
	case hitbar of
	     0..20:setcolor(red);
	     21..50:setcolor(yellow);
	else
	     setcolor(green);
	end; {case}
	line(440,368,440+hitbar,368);
	line(440,369,440+hitbar,369);
	setcolor(black);
	line(441+hitbar,368,540,368);
	line(441+hitbar,369,540,369);
	setcolor(lightcyan);
	x:=440;
	y:=y+15;
	str(player.armorclass,tempstring);
	tempstring:='AC: ' + tempstring;
	graphwriteln(x,y,tempstring);
	x:=440;
	str(player.thac0,tempstring);
	tempstring:='THAC0: ' + tempstring;
	graphwriteln(x,y,tempstring);
	x:=440;
	graphwriteln(x,y,'Dmg: '+player.damage);
        x:=440;
	str(player.savingthrow,tempstring);
	tempstring:='Save: ' + tempstring;
	graphwriteln(x,y,tempstring);

end;
{---------------------------------------------------------------------------}
procedure combatscreen(player:character_t;nummonsters:integer;
	                  monster:monsterlist);

var
	row1width      :    integer;
	row2width      :    integer;
	tempstring     :    string;
	loop           :    byte;

begin
	cleardevice;
	setfont('default.ttf',1);

	{draw the monsters & write names}
	row1width:=(nummonsters * 120) + ((nummonsters - 1) * spacing);
	if (row1width>(480 + (3 * spacing))) then
	     row1width:=480 + (3 * spacing);
	row2width:=((nummonsters - 4) * 120) + ((nummonsters - 5) * spacing);
	x:=(getmaxx DIV 2) - (row1width DIV 2);
	y:=0;
	if (nummonsters<=1) then
	     begin
	          drawpic(x,y,monster[nummonsters].picfile);
	          setcolor(lightgray);
	          tempstring:=monster[nummonsters].name;
	          outtextxy(x+60-(textwidth(tempstring) DIV 2),y+120,tempstring);
	          x:=x+120+spacing;
	     end;
	if (nummonsters<=4)and(nummonsters>1) then
	     for loop:=1 to nummonsters do
	          begin
	               drawpic(x,y,monster[loop].picfile);
	               setcolor(lightgray);
	               str(loop,tempstring);
	               tempstring:=tempstring + '.' + monster[loop].name;
	               outtextxy(x+60-(textwidth(tempstring) DIV 2),y+120,tempstring);
	               x:=x+120+spacing;
	          end;
	if (nummonsters>4) then
	     begin
	          for loop:=1 to 4 do
	               begin
	                    drawpic(x,y,monster[loop].picfile);
	                    setcolor(lightgray);
	                    str(loop,tempstring);
	                    tempstring:=tempstring + '.' + monster[loop].name;
	                    outtextxy(x+60-(textwidth(tempstring) DIV 2),y+120,tempstring);
	                    x:=x+120+spacing;
	               end;
	          x:=(getmaxx DIV 2) - (row2width DIV 2);
	          y:=120 + spacing;
	          for loop:=5 to nummonsters do
	               begin
	                    drawpic(x,y,monster[loop].picfile);
	                    setcolor(lightgray);
	                    str(loop,tempstring);
	                    tempstring:=tempstring + '.' + monster[loop].name;
	                    outtextxy(x+60-(textwidth(tempstring) DIV 2),y+120,tempstring);
	                    x:=x+120+spacing;
	               end;
	     end;
	setfont('sanseri.ttf',1);
	clearcombatmenu;           {Create the combat menu window on the left}
	combatstats(player);       {Create the combat stats window on the right}
	x:=(640 DIV 2) - 60;   {Draw the player in the center}
	y:=340;
	drawpic(x,y,player.picfile);
end;
{---------------------------------------------------------------------------}

procedure attackmonster(var player:character_t;var themonster:monsterrecord;
	                   themonstereffect:effectrecord);

var
	dmg       :    integer;
	s         :    string;
	flame     :    boolean;
	loop      :    integer;
	ac        :    integer;
	hitroll   :    integer;

begin
	clearcombatmenu;
	setfont('sanseri.ttf',1);
	y:=300;
	graphwriteln(x,y,'');
	ac:=themonster.armorclass;
	if (themonstereffect.glacier) and (ac>4) then
	     ac:=4;
	hitroll:=roll('1d20');
	if ((hitroll>=(player.thac0-ac))and(hitroll>1))or(hitroll=20) then
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'        You hit!');
	          graphwriteln(x,y,'');
	          dmg:=roll(player.damage);
	          if (dmg<1) then
	               dmg:=1;
	          flame:=false;
	          for loop:=1 to player.numitems do
	               if (player.item[loop]=flamewand) then
	                    flame:=true;
	          if (flame) and (themonstereffect.resistfire) then
	               dmg:=(dmg DIV 2)+1;
	          str(dmg,s);
	          s:='('+s+')';
	          x:=120-(textwidth(s) DIV 2);
	          graphwriteln(x,y,s);
	          if (dmg>themonster.endurance) then
	               themonster.endurance:=0
	          else
	               themonster.endurance:=themonster.endurance-dmg;
	          if (themonster.endurance=0) then
	               begin
	                    x:=120-(textwidth('KILLED') DIV 2);
	                    graphwriteln(x,y,'KILLED');
	               end;
	     end
	else
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'       You missed');
	     end;
end;
{---------------------------------------------------------------------------}
procedure remove(var numitems:byte;var item:itemarray;loc:integer);

var
	count     :    integer;

begin
	for count:=loc to (numitems-1) do
	      item[count]:=item[count+1];
	numitems:=numitems-1;
end;
{---------------------------------------------------------------------------}
procedure combatuse(var player:character_t;itemnum:integer;
	               var playereffect:effectrecord);

begin
	y:=360;
	if (not (player.item[itemnum] in [redpotion,bluepotion,greenpotion])) then
	   begin
	      graphwriteln(x,y,'        Not usable.');
	   end;
	if (player.item[itemnum] in [redpotion,greenpotion,bluepotion]) then
       case player.item[itemnum] of
	         bluepotion:begin
	                         if not(playereffect.blue) then
	                              begin
	                                   graphwriteln(x,y,'     You become faster');
	                                   graphwriteln(x,y,'       and stronger.');
	                                   player.strength:=player.strength+roll('1d4');
	                                   if (player.strength>20) then
	                                        player.strength:=20;
	                                   player.dexterity:=player.dexterity+roll('1d4');
	                                   if (player.dexterity>20) then
	                                        player.dexterity:=20;
	                                   remove(player.numitems,player.item,itemnum);
	                                   playereffect.blue:=true;
	                              end
	                         else
	                              begin
	                                   graphwriteln(x,y,'     It has no effect.');
	                              end;
	                    end;
	          redpotion:begin
	                         graphwriteln(x,y,'    Healing soothes you.');
	                         player.endurance:=player.endurance+roll('1d6')+1;
	                         if (player.endurance>player.endurancemax) then
	                              player.endurance:=player.endurancemax;
	                         remove(player.numitems,player.item,itemnum);
	                    end;
	        greenpotion:begin
	                         graphwriteln(x,y,'      You feel POWER');
	                         graphwriteln(x,y,'          surging');
	                         graphwriteln(x,y,'     through your body!');
	                         player.endurance:=player.endurancemax;
	                         player.strength:=20;
	                         player.dexterity:=20;
	                         remove(player.numitems,player.item,itemnum);
	                    end;
       end; {case}

end;
{---------------------------------------------------------------------------}
procedure combatcast(var player:character_t;spellnum:integer;
	                var nummonsters:integer;var monster:monsterlist;
	                var playereffect:effectrecord;var monstereffect:effectlist);

var
	damagetype     :    string;
	dmgroll        :    string; {dice}
	originaldmg    :    integer;
	dmg            :    integer;
	count          :    integer;
	tempstring     :    string;
	tempint        :    integer;
	errcode        :    integer;
	thespell       :    spell;
	powerroll      :    integer;
	monsterchart   :    chartrecord;
	pasfile        :    file of chartrecord;
	theroll        :    integer;
	val1           :    integer;
	val2           :    integer;
	monsterfile    :    string;
	newmonster     :    monsterlist;
	numnewmonster  :    integer;
	saveroll       :    integer;
	loop           :    byte;
	ch             :    char;
	ans            :    char;


begin

	thespell:=player.spell[spellnum];
	damagetype:='';
	y:=360;
	case thespell of
	      icestorm:begin
	                    damagetype:='cold';
                            if (player.level > 20) then
                                str(20,tempstring)
                            else
                                str(player.level,tempstring);
                            dmgroll:=tempstring+'d6';
                            dmg:=roll(dmgroll);
	               end;
	     fireblast:begin
	                    damagetype:='fire';
	                    str((((player.level-1) DIV 5)*2)+1,tempstring);
                            dmgroll:=tempstring+'d6+'+tempstring;
                            dmg:=roll(dmgroll);
	               end;
	    web,freeze:begin
	                    graphwriteln(x,y,'     You make your foes');
	                    graphwriteln(x,y,'       easier to hit.');
	                    for loop:=1 to nummonsters do
	                         begin
	                              monster[loop].armorclass:=monster[loop].armorclass+2;
	                              if (monster[loop].armorclass>9) then
	                                   monster[loop].armorclass:=9;
	                         end;
	               end;
   callwild,shatter:begin
	                    graphwriteln(x,y,'     Not a battle spell');
	               end;
	          heal:begin
	                    graphwriteln(x,y,'    Healing soothes you.');
	                    player.endurance:=player.endurance+roll('1d6')+1;
	                    if (player.endurance>player.endurancemax) then
	                         player.endurance:=player.endurancemax;
	                    setfont('sanseri.ttf',1);
	                    combatstats(player);
	                    setfont('default.ttf',1);
	               end;
	       courage:begin
	                    if not(playereffect.courage) then
	                         begin
	                              graphwriteln(x,y,'     You become braver.');
	                              player.strength:=player.strength+roll('1d4')+1;
	                              if (player.strength>20) then
	                                   player.strength:=20;
	                              player.dexterity:=player.dexterity+roll('1d4')+1;
	                              if (player.dexterity>20) then
	                                   player.dexterity:=20;
	                         end
	                    else
	                              graphwriteln(x,y,'     It has no effect.');
	                    playereffect.courage:=true;
	               end;
	    obliterate:begin
	                    y:=320;
	                    graphwriteln(x,y,'      Select a target:');
	                    graphwriteln(x,y,'');
	                    for count:=1 to nummonsters do
	                         begin
	                              str(count,tempstring);
	                              ch:=tempstring[1];
	                              tempstring:='     ';
	                              tempstring:=tempstring + ch + ') ';
	                              tempstring:=tempstring + monster[count].name;
	                              graphwriteln(x,y,tempstring);
	                         end;
	                    repeat
	                         ans:=readarrowkey;
	                    until (ans in ['1'..ch]);
	                    val(ans,tempint,errcode);
	                    clearcombatmenu;
	                    y:=360;
	                    graphwrite(x,y,'     You ');
	                    setcolor(magenta);
	                    graphwrite(x,y,'OBLITERATE');
	                    setcolor(lightcyan);
	                    graphwriteln(x,y,' the');
	                    x:=120-(textwidth(monster[tempint].name) DIV 2);
	                    graphwriteln(x,y,monster[tempint].name);
	                    monster[tempint].endurance:=0;
	                end;
	        icicle:begin
	                    damagetype:='cold';
	                    str((((player.level-1) DIV 5)*2)+1,tempstring);
                            dmgroll:=tempstring+'d6+'+tempstring;
                            dmg:=roll(dmgroll);
	               end;
	         power:begin
	                    powerroll:=roll('1d20');
	                    case powerroll of
	                         1..4:begin
	                                   graphwriteln(x,y,'      You don''t think');
	                                   graphwriteln(x,y,'     anything happened.');
	                              end;
	                            5:begin
	                                   graphwriteln(x,y,'       Roland appears');
	                                   graphwriteln(x,y,'      and punches you!');
	                                   dmg:=roll('1d4');
	                                   if (player.endurance<dmg) then
	                                        player.endurance:=0
	                                   else
	                                        player.endurance:=player.endurance-dmg;
	                              end;
	                         6..7:begin
	                                   graphwriteln(x,y,'      You levitate for');
	                                   graphwriteln(x,y,'          a moment.');
	                              end;
	                         8..9:begin
	                                   graphwriteln(x,y,'      You hear jesters');
	                                   graphwriteln(x,y,'      laughing at you.');
	                              end;
	                       10..11:begin
	                                   graphwriteln(x,y,'       Thousands of');
	                                   graphwriteln(x,y,'     butterflies appear');
	                                   graphwriteln(x,y,'      out of thin air.');
	                              end;
	                       12..14:begin
	                                   graphwriteln(x,y,'    You are kissed by a');
	                                   graphwriteln(x,y,'          faerie.');
	                                   player.endurance:=player.endurance+roll('1d2');
	                                   if (player.endurance>player.endurancemax) then
	                                        player.endurance:=player.endurancemax;
	                              end;
	                       15..16:begin
	                                   graphwriteln(x,y,'    Your left hand turns');
	                                   graphwriteln(x,y,'         into a claw.');
	                                   player.strength:=player.strength+1;
	                                   if (player.strength>20) then
	                                        player.strength:=20;
	                              end;
	                       17..18:begin
	                                   graphwriteln(x,y,'       A voice says,');
	                                   graphwriteln(x,y,'     "watch yourself"');
	                                   player.dexterity:=player.dexterity+1;
	                                   if (player.dexterity>20) then
	                                        player.dexterity:=20;
	                              end;
	                           19:begin
	                                   if (nummonsters=8) then
	                                        begin
	                                             graphwriteln(x,y,'        You hear a');
	                                             graphwriteln(x,y,'      rumbling noise');
	                                        end
	                                   else
	                                        begin
	                                             {------roll monster-----}
	                                             if not(exist(chartdir+wildchart)) then
	                                                  exit;
	                                             assign(pasfile,chartdir+wildchart);
	                                             reset(pasfile);
	                                             read(pasfile,monsterchart);
	                                             close(pasfile);
	                                             with monsterchart do
	                                                begin
	                                                   theroll:=roll(diceroll);
	                                                   for count:=1 to 20 do
	                                                      begin
	                                                         val1:=value[count,1];
	                                                         val2:=value[count,2];
	                                                         if (theroll in [val1..val2]) then
	                                                            begin
	                                                               monsterfile:=filename[count];
	                                                               numnewmonster:=1;
	                                                            end;
	                                                      end;
	                                                end;
	                                             rollmonsters(newmonster,numnewmonster,monsterfile);
	                                             {-----------------------}
	                                             nummonsters:=nummonsters+1;
	                                             monster[nummonsters]:=newmonster[1];
	                                             tempstring:=monster[nummonsters].name;
	                                             tempstring:=capitalize(tempstring);
	                                             x:=120-(textwidth(tempstring) DIV 2);
	                                             graphwriteln(x,y,tempstring);
	                                             graphwriteln(x,y,'');
	                                             tempstring:='appears';
	                                             x:=120-(textwidth(tempstring) DIV 2);
	                                             graphwriteln(x,y,tempstring);
	                                        end;
	                              end;
	                           20:begin
	                                   y:=310;
	                                   graphwriteln(x,y,'      WHOA! MEGADAMAGE!');
	                                   graphwriteln(x,y,'');
                                           dmgroll:='8d8+8';
                                           dmg:=roll(dmgroll);
	                                   thespell:=fireblast;
	                                   case roll('1d6') of
	                                      2:damagetype:='fire';
	                                      3:begin
	                                             damagetype:='cold';
	                                             thespell:=icicle;
	                                        end;
	                                      4:damagetype:='meteor';
	                                      5:damagetype:='acid';
	                                      6:damagetype:='poison';
	                                   else
	                                        damagetype:='lightning';
	                                   end;
	                              end;
	                    else
	                              begin
	                                   graphwriteln(x,y,'      You don''t think');
	                                   graphwriteln(x,y,'     anything happened.');
	                              end;
	                    end;
	                end;
	       glacier:begin
	                    if not(playereffect.glacier) then
	                         begin
	                              graphwriteln(x,y,'     You''re skin takes');
	                              graphwriteln(x,y,'       on a blue hue.');
	                              graphwriteln(x,y,'');
	                              graphwriteln(x,y,'       You feel cold.');
	                         end
	                    else
	                         graphwriteln(x,y,'     It has no effect.');
	                    playereffect.glacier:=true;
	               end;
	  dragonbreath:begin
	                    damagetype:='fire';
	                    dmg:=player.endurance;
	               end;
	    resistfire:begin
	                    if not(playereffect.resistfire) then
	                         begin
	                              graphwriteln(x,y,'    You become resistant');
	                              graphwriteln(x,y,'          to fire.');
	                         end
	                    else
	                         graphwriteln(x,y,'     It has no effect.');
	                    playereffect.resistfire:=true;
	               end;
	    resistcold:begin
	                    if not(playereffect.resistcold) then
	                         begin
	                              graphwriteln(x,y,'    You become resistant');
	                              graphwriteln(x,y,'          to cold.');
	                         end
	                    else
	                         graphwriteln(x,y,'     It has no effect.');
	                    playereffect.resistcold:=true;
	               end;
	end;
	if (dmg<1) then
	     dmg:=1;
	if (thespell in [fireblast,icicle]) then
	     begin
	          y:=320;
	          graphwriteln(x,y,'      Select a target:');
	          graphwriteln(x,y,'');
	          for count:=1 to nummonsters do
	               begin
	                    str(count,tempstring);
	                    ch:=tempstring[1];
	                    tempstring:='     ';
	                    tempstring:=tempstring + ch + ') ';
	                    tempstring:=tempstring + monster[count].name;
	                    graphwriteln(x,y,tempstring);
	               end;
	          repeat
	               ans:=readarrowkey;
	          until (ans in ['1'..ch]);
	          val(ans,tempint,errcode);
	          clearcombatmenu;
	          y:=340;
	          if (monstereffect[count].resistfire)and(damagetype='fire') then
	               dmg:=dmg-player.level;
	          if (monstereffect[count].resistcold)and(damagetype='cold') then
	               dmg:=dmg-player.level;
	          if (dmg<1) then
	               dmg:=1;
	          x:=120-(textwidth(monster[tempint].name) DIV 2);
	          graphwriteln(x,y,monster[tempint].name);
	          str(dmg,tempstring);
	          tempstring:='takes (' + tempstring + ')';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	          tempstring:=damagetype + ' damage';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	          if (monster[tempint].endurance<=dmg) then
	               monster[tempint].endurance:=0
	          else
	               monster[tempint].endurance:=monster[tempint].endurance-dmg;
	          graphwriteln(x,y,'');
	          if (monster[tempint].endurance=0) then
	               graphwriteln(x,y,'           KILLED');
	     end;
	if (thespell in [dragonbreath,icestorm]) then
	     begin
	          y:=360;
	          graphwriteln(x,y,'     All monsters take');
	          graphwriteln(x,y,'          damage...');
	          originaldmg:=dmg;
	          for count:=1 to nummonsters do
	               begin
	                    combatmenuprompt;
	                    clearcombatmenu;
	                    y:=360;
	                    dmg:=originaldmg;
	                    if (monstereffect[count].resistfire) and
	                       (damagetype='fire') then
	                         dmg:=dmg-player.level;
	                    if (monstereffect[count].resistcold) and
	                       (damagetype='cold') then
	                         dmg:=dmg-player.level;
	                    saveroll:=roll('1d20');
	                    if ((saveroll>=monster[count].savingthrow)and(saveroll>1))or(saveroll=20) then
	                         dmg:=dmg DIV 2;
	                    if (dmg<1) then
	                         dmg:=1;
	                    if (nummonsters>1) then
	                         begin
	                              str(count,tempstring);
	                              tempstring:=monster[count].name + ' ' + tempstring;
	                         end
	                    else
	                         tempstring:=monster[count].name;
	                    x:=120-(textwidth(tempstring) DIV 2);
	                    graphwriteln(x,y,tempstring);
	                    str(dmg,tempstring);
	                    tempstring:='takes (' + tempstring + ')';
	                    x:=120-(textwidth(tempstring) DIV 2);
	                    graphwriteln(x,y,tempstring);
	                    tempstring:=damagetype + ' damage';
	                    x:=120-(textwidth(tempstring) DIV 2);
	                    graphwriteln(x,y,tempstring);
	                    if (monster[count].endurance<=dmg) then
	                         monster[count].endurance:=0
	                    else
	                         monster[count].endurance:=monster[count].endurance-dmg;
	                    graphwriteln(x,y,'');
	                    if (monster[count].endurance=0) then
	                         graphwriteln(x,y,'           KILLED');
	               end;
	     end;
	if not(player.spell[spellnum] in [shatter,callwild]) then
	     player.charges:=player.charges-1;

end;
{---------------------------------------------------------------------------}
procedure playerturn(var player:character_t;var nummonsters:integer;
	                var monster:monsterlist;var xppool:longint;
	                var coinpool:longint;var playereffect:effectrecord;
	                var monstereffect:effectlist);

var
	done           :    boolean;
	count          :    integer;
	tempstring     :    string[40];
	action         :    (attack,use,cast);
	tempint        :    integer;
	errcode        :    integer;
	loop           :    integer;
	deadmonster    :    boolean;
	ans            :    char;
	ch             :    char;

begin

	done:=false;
	repeat
	     clearcombatmenu;
	     setfont('sanseri.ttf',1);
	     y:=300;
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'     (A)ttack');
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'     (U)se an item');
	     if (ring in player.stages) then
	          begin
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'     (C)ast a spell');
	               repeat
	                     ans:=readarrowkey;
	               until (ans in ['a','A','u','U','c','C']);
	          end
	     else
	          begin
	               repeat
	                     ans:=readarrowkey;
	               until (ans in ['a','A','u','U']);
	          end;
	     case ans of
	        'a','A':action:=attack;
	        'u','U':action:=use;
	        'c','C':action:=cast;
	     end;{case}
	     clearcombatmenu;
	     setfont('default.ttf',1);
	     y:=300;
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'');
	     if (action=attack) then
	          begin
	               graphwriteln(x,y,'           ATTACK');
	               graphwriteln(x,y,'');
	               for count:=1 to nummonsters do
	                    begin
	                         str(count,tempstring);
	                         ch:=tempstring[1];
	                         tempstring:='     ';
	                         tempstring:=tempstring + ch + ') ';
	                         tempstring:=tempstring + monster[count].name;
	                         graphwriteln(x,y,tempstring);
	                    end;
	               graphwriteln(x,y,'     N)one');
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['1'..ch,'n','N']);
	               done:=not(ans in ['n','N']);
	               val(ans,tempint,errcode);
	               if done then
	                    attackmonster(player,monster[tempint],monstereffect[tempint]);
	          end;
	     if (action=use) then
	          begin
	               graphwriteln(x,y,'          USE ITEM');
	               graphwriteln(x,y,'');
	               for count:=1 to player.numitems do
	                    begin
	                         if (not(player.item[count] in [redpotion,greenpotion,bluepotion])) then
	                              setcolor(cyan)
	                         else
	                              setcolor(lightcyan);
	                         str(count,tempstring);
	                         ch:=tempstring[1];
	                         tempstring:='      ';
	                         tempstring:=tempstring + ch + '. ';
	                         tempstring:=tempstring + itemstring(player.item[count]);
	                         graphwriteln(x,y,tempstring);
	                    end;
	               setcolor(lightcyan);
	               graphwriteln(x,y,'      N)one');
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['1'..ch,'n','N']);
	               done:=not(ans in ['n','N']);
	               if done then
	                    begin
	                         clearcombatmenu;
	                         y:=300;
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'');
	                         val(ans,tempint,errcode);
	                         if (not(player.item[tempint] in [redpotion,greenpotion,bluepotion])) then
	                              done:=false;
	                         combatuse(player,tempint,playereffect);
	                    end;
	          end;
	     if (action=cast) then
	          begin
	               graphwriteln(x,y,'         CAST SPELL');
	               graphwriteln(x,y,'');
	               for count:=1 to player.numspells do
	               begin
	                    if (player.spell[count] in [callwild,shatter]) then
	                         setcolor(cyan)
	                    else
	                         setcolor(lightcyan);
	                    str(count,tempstring);
	                    ch:=tempstring[1];
	                    tempstring:='      ';
	                    tempstring:=tempstring + ch + '. ';
	                    tempstring:=tempstring + spellstring(player.spell[count]);
	                    graphwriteln(x,y,tempstring);
	               end;
	               setcolor(lightcyan);
	               graphwriteln(x,y,'      N)one');
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['1'..ch,'n','N']);
	               done:=not(ans in ['n','N']);
	               if done and (player.charges=0) then
	                    begin
	                         clearcombatmenu;
	                         y:=340;
	                         graphwriteln(x,y,'       You''re out of');
	                         graphwriteln(x,y,'           magic.');
	                         done:=false;
	                    end;
	               if done then
	                    begin
	                         clearcombatmenu;
	                         y:=300;
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'');
	                         val(ans,tempint,errcode);
	                         if (player.spell[tempint] in [callwild,shatter]) then
	                              done:=false;
	                         combatcast(player,tempint,nummonsters,monster,
	                                    playereffect,monstereffect);
	                    end;
	          end;
	     if not(done) then
	          combatmenuprompt;
	until (done);
	deadmonster:=true;
	while deadmonster do
	     begin
	          deadmonster:=false;
	          for count:=1 to nummonsters do
	               if (monster[count].endurance=0) then
	                    begin
	                         tempint:=count;
	                         deadmonster:=true;
	                    end;
	          if deadmonster then
	               begin
	                    xppool:=xppool + monster[tempint].xpvalue;
	                    coinpool:=coinpool + monster[tempint].coins;
	                    for loop:=tempint to (nummonsters-1) do
	                         monster[loop]:=monster[loop+1];
	                    nummonsters:=nummonsters-1;
	               end;
	     end;
	combatmenuprompt;
	if (player.endurance=0) then
	     begin
	        died;
	        exit;
	     end;
	if (nummonsters>0) then
	     combatscreen(player,nummonsters,monster);
end;
{---------------------------------------------------------------------------}
procedure monsterattack(var player:character_t;monsternum:integer;
	                   var themonster:monsterrecord;
	                   var playereffect:effectrecord);

var
	dmg       :    integer;
	tempstring:    string;
	ac        :    integer;
	hitroll   :    integer;

begin
	setfont('default.ttf',1);
	ac:=player.armorclass;
	if (playereffect.glacier) and (ac>4) then
	     ac:=4;
	y:=360;
	if (nummonsters>1) then
	     begin
	          str(monsternum,tempstring);
	          tempstring:=themonster.name + ' ' + tempstring;
	     end
	else
	     tempstring:=themonster.name;
	x:=120-(textwidth(tempstring) DIV 2);
	graphwriteln(x,y,tempstring);
	hitroll:=roll('1d20');
	if ((roll('1d20')>=(themonster.thac0-ac))and(hitroll>1))or(hitroll=20) then
	     begin
	          tempstring:=themonster.attacktype + ' YOU!';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	          dmg:=roll(themonster.damage);
	          if (dmg<1) then
	               dmg:=1;
	          str(dmg,tempstring);
	          tempstring:='('+tempstring+')';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	          if (dmg>player.endurance) then
	               player.endurance:=0
	          else
	               player.endurance:=player.endurance-dmg;
	          if (player.endurance=0) then
	               begin
	                    graphwriteln(x,y,'');
	                    x:=120-(textwidth('KILLED') DIV 2);
	                    graphwriteln(x,y,'KILLED');
	               end;
	     end
	else
	     begin
	          graphwriteln(x,y,'');
	          tempstring:='misses';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	     end;

end;
{---------------------------------------------------------------------------}
procedure monstercast(var player:character_t;spellnum:integer;
	                 monsternum:integer;var themonster:monsterrecord;
	                 var playereffect:effectrecord;
	                 var themonstereffect:effectrecord);

var
	tempstring     :    string;
	thespell       :    spell;
	damagetype     :    string;
	dmgroll        :    string; {dice}
	dmg            :    integer;
	count          :    integer;
	monsterchart   :    chartrecord;
	pasfile        :    file of chartrecord;
	theroll        :    integer;
	val1           :    integer;
	val2           :    integer;
	newmonster     :    monsterlist;
	monsterfile    :    string;
	numnewmonster  :    integer;
	saveroll       :    integer;

begin
	setfont('default.ttf',1);
	y:=340;
	if (nummonsters>1) then
	     begin
	          str(monsternum,tempstring);
	          tempstring:=themonster.name + ' ' + tempstring;
	     end
	else
	     tempstring:=themonster.name;
	x:=120-(textwidth(tempstring) DIV 2);
	graphwriteln(x,y,tempstring);
	thespell:=themonster.spell[spellnum];
	damagetype:='';
	case thespell of
	      icestorm:begin
	                    graphwriteln(x,y,'       casts a spell');
	                    damagetype:='cold';
                            if (themonster.hitdice>20) then
                                str(20,tempstring)
                            else
                                str(themonster.hitdice,tempstring);
                            dmgroll:=tempstring+'d6';
                            dmg:=roll(dmgroll);
	               end;
	     fireblast:begin
	                    graphwriteln(x,y,'       casts a spell');
	                    damagetype:='fire';
	                    str((((themonster.hitdice-1) DIV 5)*2)+1,tempstring);
                            dmgroll:=tempstring+'d6+'+tempstring;
                            dmg:=roll(dmgroll);
	               end;
	        freeze:begin
	                    graphwriteln(x,y,'    freezes you, slowing');
	                    graphwriteln(x,y,'         you down...');
	                    player.dexterity:=player.dexterity-2;
	                    if (player.dexterity<1) then
	                         player.dexterity:=1;
	               end;
	           web:begin
	                    graphwriteln(x,y,'      ties you up with');
	                    graphwriteln(x,y,'         sticky web');
	                    player.dexterity:=player.dexterity-2;
	                    if (player.dexterity<1) then
	                         player.dexterity:=1;
	               end;
   callwild,shatter:begin
	                    graphwriteln(x,y,'       tries to cast');
	                    graphwriteln(x,y,'      a spell but fails');
	               end;
	          heal:begin
	                    graphwriteln(x,y,'          is healed');
	                    themonster.endurance:=themonster.endurance+roll('1d6')+1;
	                    if (themonster.endurance>themonster.endurancemax) then
	                         themonster.endurance:=themonster.endurancemax;
	               end;
	       courage:begin
	                    if not(themonstereffect.courage) then
	                         begin
	                              graphwriteln(x,y,'     becomes faster and');
	                              graphwriteln(x,y,'           stronger');
	                              themonster.armorclass:=themonster.armorclass-1;
	                              themonster.thac0:=themonster.thac0-1;
	                              themonster.damage:=themonster.damage+'+1';
	                         end
	                    else
	                         begin
	                              graphwriteln(x,y,'       tries to cast');
	                              graphwriteln(x,y,'      a spell but fails');
	                         end;
	                    themonstereffect.courage:=true;
	               end;
	    obliterate:begin
	                    y:=360;
	                    setcolor(magenta);
	                    graphwrite(x,y,'      OBLITERATES');
	                    setcolor(lightcyan);
	                    graphwriteln(x,y,' you');
	                    player.endurance:=0;
	                end;
	        icicle:begin
	                    graphwriteln(x,y,'       casts a spell');
	                    damagetype:='cold';
	                    str((((themonster.hitdice-1) DIV 5)*2)+1,tempstring);
                            dmgroll:=tempstring+'d6+'+tempstring;
                            dmg:=roll(dmgroll);
	               end;
	         power:begin
	                    case roll('1d8') of
	                         1..6:begin
	                                   graphwriteln(x,y,'       tries to cast');
	                                   graphwriteln(x,y,'      a spell but fails');
	                              end;
	                            7:begin
	                                   graphwriteln(x,y,'       casts a spell');
	                                   if (nummonsters=8) then
	                                        begin
	                                             graphwriteln(x,y,'        You hear a');
	                                             graphwriteln(x,y,'      rumbling noise');
	                                        end
	                                   else
	                                        begin
	                                             {------roll monster-----}
	                                             if not(exist(chartdir+wildchart)) then
	                                                  exit;
	                                             assign(pasfile,chartdir+wildchart);
	                                             reset(pasfile);
	                                             read(pasfile,monsterchart);
	                                             close(pasfile);
	                                             with monsterchart do
	                                                begin
	                                                   theroll:=roll(diceroll);
	                                                   for count:=1 to 20 do
	                                                      begin
	                                                         val1:=value[count,1];
	                                                         val2:=value[count,2];
	                                                         if (theroll in [val1..val2]) then
	                                                            begin
	                                                               monsterfile:=filename[count];
	                                                               numnewmonster:=1;
	                                                            end;
	                                                      end;
	                                                end;
	                                             rollmonsters(newmonster,numnewmonster,monsterfile);
	                                             {-----------------------}
	                                             nummonsters:=nummonsters+1;
	                                             monster[nummonsters]:=newmonster[1];
	                                             tempstring:=monster[nummonsters].name;
	                                             tempstring:=capitalize(tempstring);
	                                             x:=120-(textwidth(tempstring) DIV 2);
	                                             graphwriteln(x,y,tempstring);
	                                             graphwriteln(x,y,'');
	                                             tempstring:='appears';
	                                             x:=120-(textwidth(tempstring) DIV 2);
	                                             graphwriteln(x,y,tempstring);
	                                        end;
	                              end;
	                            8:begin
	                                   graphwriteln(x,y,'       casts a spell');
                                           dmgroll:='8d8+8';
                                           dmg:=roll(dmgroll);
	                                   thespell:=fireblast;
	                                   case roll('1d6') of
	                                      2:damagetype:='fire';
	                                      3:begin
	                                             damagetype:='cold';
	                                             thespell:=icicle;
	                                        end;
	                                      4:damagetype:='meteor';
	                                      5:damagetype:='acid';
	                                      6:damagetype:='poison';
	                                   else
	                                        damagetype:='lightning';
	                                   end;
	                              end;
	                    end;
	                end;
	       glacier:begin
	                    if not(themonstereffect.glacier) then
	                         begin
	                              graphwriteln(x,y,'         skin takes');
	                              graphwriteln(x,y,'       on a blue hue.');
	                         end
	                    else
	                         begin
	                              graphwriteln(x,y,'       tries to cast');
	                              graphwriteln(x,y,'      a spell but fails');
	                         end;
	                    themonstereffect.glacier:=true;
	               end;
	  dragonbreath:begin
	                    graphwriteln(x,y,'          breathes');
	                    damagetype:='fire';
	                    dmg:=themonster.endurance;
	               end;
	    resistfire:begin
	                    if not(themonstereffect.resistfire) then
	                         begin
	                              graphwriteln(x,y,'      becomes resistant');
	                              graphwriteln(x,y,'          to fire.');
	                         end
	                    else
	                         begin
	                              graphwriteln(x,y,'       tries to cast');
	                              graphwriteln(x,y,'      a spell but fails');
	                         end;
	                    themonstereffect.resistfire:=true;
	               end;
	    resistcold:begin
	                    if not(themonstereffect.resistcold) then
	                         begin
	                              graphwriteln(x,y,'       becomes resistant');
	                              graphwriteln(x,y,'          to cold.');
	                         end
	                    else
	                         begin
	                              graphwriteln(x,y,'       tries to cast');
	                              graphwriteln(x,y,'      a spell but fails');
	                         end;
	                    themonstereffect.resistcold:=true;
	               end;
	end;
	if (dmg<1) then
	     dmg:=1;
	if (thespell in [fireblast,icicle]) then
	     begin
	          if (playereffect.resistfire) and (damagetype='fire') then
	               dmg:=dmg-themonster.hitdice;
	          if (playereffect.resistcold) and (damagetype='cold') then
	               dmg:=dmg-themonster.hitdice;
	          if (dmg<1) then
	               dmg:=1;
	          str(dmg,tempstring);
	          tempstring:='you take (' + tempstring + ')';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	          tempstring:=damagetype + ' damage';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	          if (player.endurance<=dmg) then
	               player.endurance:=0
	          else
	               player.endurance:=player.endurance-dmg;
	          graphwriteln(x,y,'');
	          if (player.endurance=0) then
	               graphwriteln(x,y,'           KILLED');
	     end;
	if (thespell in [dragonbreath,icestorm]) then
	     begin
	          if (playereffect.resistfire) and (damagetype='fire') then
	               dmg:=dmg-themonster.hitdice;
	          if (playereffect.resistcold) and (damagetype='cold') then
	               dmg:=dmg-themonster.hitdice;
	          saveroll:=roll('1d20');
	          if ((saveroll>=player.savingthrow)and(saveroll>1))or(saveroll=20) then
	               dmg:=dmg DIV 2;
	          if (dmg<1) then
	               dmg:=1;
	          str(dmg,tempstring);
	          tempstring:='you take (' + tempstring + ')';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	          tempstring:=damagetype + ' damage';
	          x:=120-(textwidth(tempstring) DIV 2);
	          graphwriteln(x,y,tempstring);
	          if (player.endurance<=dmg) then
	               player.endurance:=0
	          else
	               player.endurance:=player.endurance-dmg;
	          graphwriteln(x,y,'');
	          if (player.endurance=0) then
	               graphwriteln(x,y,'           KILLED');
	     end;
end;
{---------------------------------------------------------------------------}
procedure monsterturn(var player:character_t;var nummonsters:integer;
	                 var monster:monsterlist;var xppool:longint;
	                 var coinpool:longint;var playereffect:effectrecord;
	                 var monstereffect:effectlist);

var
	action         :    (flee,cast,attack);
	loop           :    integer;
	tempint        :    integer;
	avgdmg         :    integer;
	deadmonster    :    boolean;
	count          :    integer;
	spellcounter   :    array[1..monstermax] of integer;
	tempstring     :    string;
	fleehp         :    integer;

begin
	y:=300;
	setfont('sanseri.ttf',1);
	setcolor(lightcyan);
	clearcombatmenu;
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'          The');
	graphwriteln(x,y,'        Monsters');
	graphwriteln(x,y,'         Attack');
	combatmenuprompt;
	for loop:=1 to monstermax do
	     spellcounter[loop]:=0;
	for loop:=1 to nummonsters do
	   begin
	     fleehp:=10;
	     if (monster[loop].endurance>0) then
	          begin
	               with monster[loop] do
	                    begin
	                         action:=attack;
	                         if (alignment in ['n','N']) then
	                              fleehp:=20;
	                         tempint:=(endurance DIV endurancemax) * 100;
	                         if (tempint<=fleehp)and((roll('2d6')>morale)) then
	                              action:=flee;
	                         avgdmg:=rollavg(damage);
	                         if not(action=flee) and (numspells>0)
	                            and (spellcounter[loop]<(numspells+2)) then
	                              begin
	                                   tempint:=(numspells*25)-avgdmg;
	                                   if (tempint>99) then
	                                        tempint:=99;
	                                   if (roll('1d100')<=tempint) then
	                                        action:=cast;
	                              end;
	                         if (action=cast) then
	                              begin
	                                   tempint:=random(numspells)+1;
	                                   case spell[tempint] of
	                                     courage:if (monstereffect[loop].courage) then
	                                                  action:=attack;
	                                  resistcold:if (monstereffect[loop].resistcold) then
	                                                  action:=attack;
	                                  resistfire:if (monstereffect[loop].resistfire) then
	                                                  action:=attack;
	                                     glacier:if (monstereffect[loop].glacier) then
	                                                  action:=attack;
	                                   end;
	                              end;
	                    end;
	          end;
	          clearcombatmenu;
	          if (action=flee) then
	               begin
	                    y:=360;
	                    with monster[loop] do
	                        begin
	                             str(loop,tempstring);
	                             tempstring:=name + ' ' +tempstring;
	                             x:=120-(textwidth(tempstring) DIV 2);
	                             graphwriteln(x,y,tempstring);
	                             graphwriteln(x,y,'');
	                             tempstring:='runs away';
	                             x:=120-(textwidth(tempstring) DIV 2);
	                             graphwriteln(x,y,tempstring);
	                             endurance:=0;
	                             xpvalue:=0;
	                             coins:=0;
	                        end;
	               end;
	          if (action=cast) then
	               begin
	                    monstercast(player,tempint,loop,monster[loop],
	                                playereffect,monstereffect[loop]);
	                    spellcounter[loop]:=spellcounter[loop]+1;
	               end;
	          if (action=attack) then
	               begin
	                    monsterattack(player,loop,monster[loop],
	                                  playereffect);
	               end;
	          setfont('sanseri.ttf',1);
	          combatstats(player);
	          setfont('default.ttf',1);
	          combatmenuprompt;
	          if (player.endurance=0) then
	             begin
	                died;
	                exit;
	             end;
	   end;
	deadmonster:=true;
	while deadmonster do
	     begin
	          deadmonster:=false;
	          for count:=1 to nummonsters do
	               if (monster[count].endurance=0) then
	                    begin
	                         tempint:=count;
	                         deadmonster:=true;
	                    end;
	          if deadmonster then
	               begin
	                    xppool:=xppool + monster[tempint].xpvalue;
	                    coinpool:=coinpool + monster[tempint].coins;
	                    for loop:=tempint to (nummonsters-1) do
	                         monster[loop]:=monster[loop+1];
	                    nummonsters:=nummonsters-1;
	               end;
	     end;
	if (nummonsters>0) then
	     combatscreen(player,nummonsters,monster);
end;
{---------------------------------------------------------------------------}
procedure writeflee;

begin
	setcolor(lightcyan);
	setfont('sanseri.ttf',1);
	outtextxy(40,360,'  You run away...');
end;
{---------------------------------------------------------------------------}
procedure combat(var player:character_t;var nummonsters:integer;
	            monster:monsterlist);

var
	oldplayer      :    character_t;
	xppool         :    longint;
	coinpool       :    longint;
	flee           :    boolean;
	tempstring     :    string;
	playereffect   :    effectrecord;
	monstereffect  :    effectlist;
	loop           :    integer;
	ch             :    char;

begin
	oldplayer:=player;
	flee:=false;
	xppool:=0;
	coinpool:=0;
	with playereffect do
	     begin
	          blue:=false;
	          courage:=false;
	          resistfire:=false;
	          resistcold:=false;
	          glacier:=false;
	     end;
	for loop:=1 to nummonsters do
	     with monstereffect[loop] do
	          begin
	               blue:=false;
	               courage:=false;
	               resistfire:=false;
	               resistcold:=false;
	               glacier:=false;
	          end;
	repeat
	     calcstats(player);
	     combatscreen(player,nummonsters,monster);
	     setcolor(lightcyan);
	     setfont('sanseri.ttf',3);
	     y:=300;
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'      (F)ight');
	     y:=y+10;
	     graphwriteln(x,y,'        or');
	     x:=x+5;
	     y:=y+10;
	     graphwriteln(x,y,'      (R)un');
	     repeat
	          ch:=readarrowkey;
	     until (ch in ['f','F','r','R']);
	     clearcombatmenu;
	     flee:=(ch in ['r','R']);
	     if (roll('1d10')<=roll('1d10')) then              {Roll Initiative}
	          begin
	               monsterturn(player,nummonsters,monster,xppool,coinpool,
	                           playereffect,monstereffect);
	               if GAMEOVER then exit;
	               if not(flee) then
	                    begin
	                         if (nummonsters>0) then
	                              playerturn(player,nummonsters,monster,xppool,
	                                         coinpool,playereffect,monstereffect)
	                    end
	               else
	                    begin
	                         writeflee;
	                         coinpool:=0;
	                    end;
	          end
	     else
	          if not(flee) then
	               begin
	                    playerturn(player,nummonsters,monster,xppool,
	                               coinpool,playereffect,monstereffect);
	                    if (nummonsters>0) then
	                         monsterturn(player,nummonsters,monster,xppool,coinpool,
	                                     playereffect,monstereffect);
	                    if GAMEOVER then exit;
	               end
	          else
	               begin
	                    writeflee;
	                    coinpool:=0;
	               end;
	until (flee)or(nummonsters=0);

	{readjust stats using oldplayer}
	player.strength:=oldplayer.strength;
	player.dexterity:=oldplayer.dexterity;

	with player do                     {Add xp and treasure}
	     begin
	          experience:=experience + xppool;
	          coins:=coins + coinpool;
	          setcolor(white);
	          setfont('default.ttf',1);
	          y:=460;
	          graphwriteln(x,y,'');
	          graphwrite(x,y,'You gain:');
	          str(xppool,tempstring);
	          tempstring:='  ' + tempstring + ' exp, ';
	          graphwrite(x,y,tempstring);
	          str(coinpool,tempstring);
	          tempstring:=tempstring + ' coin(s)';
	          graphwrite(x,y,tempstring);
	          prompt;
	     end;
	calcstats(player);

end;

{Screen Setup}
{--------------------------------------------------------------------------}
procedure clearmap;

begin
	setfillstyle(solidfill,blue);
	bar(41,41,440,320);
end;
{--------------------------------------------------------------------------}
procedure clearmessage;

begin
	setfillstyle(solidfill,darkgray);
	bar(41,361,600,440);
end;
{--------------------------------------------------------------------------}
procedure clearstats;

begin
	setfillstyle(solidfill,red);
	bar(481,41,600,320);
end;
{--------------------------------------------------------------------------}
procedure screensetup;

begin
	setfillstyle(solidfill,lightgray);
	bar(0,0,640,480);
	setfillstyle(solidfill,black);
	bar(38,38,443,323);
	bar(38,358,603,443);
	bar(478,38,603,323);
	clearmap;
	clearmessage;
	clearstats;
end;
{---------------------------------------------------------------------------}
function midstats(thestring:string) :    integer;

begin
	midstats:=541 - (textwidth(thestring) DIV 2);
end;
{---------------------------------------------------------------------------}
procedure writestats(player:character_t);

var

	thestring      :    string;
	tempstring     :    string;
	loop           :    integer;

begin
	clearstats;
	setcolor(lightred);
	with player do
	     begin
	          setfont('sanseri.ttf',2);
	          tempstring:=name;
	          while (textwidth(tempstring)>120) do
	               delete(tempstring,length(tempstring),1);
	          outtextxy(midstats(tempstring),50,tempstring);
	          setfont('default.ttf',1);
	          outtextxy(midstats('ENDURANCE'),80,'ENDURANCE');
	          str(endurance,tempstring);
	          thestring:=tempstring;
	          str(endurancemax,tempstring);
	          thestring:=thestring + '/' + tempstring;
	          outtextxy(midstats(thestring),90,thestring);
	          y:=110;
	          if (numitems>0) then
	               begin
	                    x:=midstats('ITEMS');
	                    graphwriteln(x,y,'ITEMS');
	                    for loop:=1 to numitems do
	                         begin
	                              x:=midstats(itemstring(item[loop]));
	                              graphwriteln(x,y,itemstring(item[loop]));
	                         end;
	               end
	          else
	               begin
	                    x:=midstats('No Items');
	                    graphwriteln(x,y,'No Items');
	               end;
	          graphwriteln(x,y,'');
	          if (numspells>0) then
	               begin
	                    x:=midstats('SPELLS');
	                    graphwriteln(x,y,'SPELLS');
	                    for loop:=1 to numspells do
	                         begin
	                              x:=midstats(spellstring(spell[loop]));
	                              graphwriteln(x,y,spellstring(spell[loop]));
	                         end;
	               end
	          else
	               begin
	                    x:=midstats('No spells');
	                    graphwriteln(x,y,'No spells');
	               end;
	     end;

end;
{--------------------------------------------------------------------------}
procedure homemessage(var x,y:integer);

begin
	x:=45;
	y:=365;
end;
{--------------------------------------------------------------------------}
procedure message(var x,y:integer;gtext:string);

{Each line can be 34 characters long (default font, size 2)}

begin
	x:=45;
	if (y>440) or (y<365) then
	     homemessage(x,y);
	outtextxy(x,y,(gtext));
	y:=y + textheight('M') + 2;
end;
{---------------------------------------------------------------------------}
procedure surfacemessage;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,' Use arrow keys or keypad to move');
	message(x,y,'');
	message(x,y,'    Press <SPACE> for options');
end;

{Town Procedures and functions}
{---------------------------------------------------------------------------}
procedure savegame(player:character_t);

var
	dosname        :    string;
	pasfile        :    file of character_t;
	goahead        :    boolean;
	ans            :    char;

begin
	goahead:=false;
	cleardevice;
	homecursor(x,y);
	setcolor(lightgray);
	setfont('sanseri.ttf',3);
	graphwriteln(x,y,'[default: '+savedefault+']');
	graphwriteln(x,y,'');
	setfont('sanseri.ttf',4);
	graphwrite(x,y,'Enter Save File Name: ');
	setcolor(lightblue);
	graphread(x,y,dosname);
	if (dosname='') then
	     dosname:=savedefault;
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	setcolor(lightgray);
	if exist(savedir+dosname) then
	     begin
	          graphwriteln(x,y,'File exists.');
	          graphwriteln(x,y,'Overwrite? (y/n)');
	          repeat
	               ans:=readarrowkey;
	          until (ans in ['n','N','y','Y']);
	          if (ans in ['y','Y']) then
	               goahead:=true;
	     end
	else
	     goahead:=true;
	if goahead then
	     begin
	          assign(pasfile,savedir+dosname);
	          rewrite(pasfile);
	          write(pasfile,player);
	          close(pasfile);
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'Saved.');
	          setfont('default.ttf',2);
	          prompt;
	     end;
end;
{--------------------------------------------------------------------------}
procedure broke;

begin
	setfont('sanseri.ttf',5);
	outtextxy(1,200,'  You do not have the funds!!');
	setfont('default.ttf',2);
	prompt;
end;
{---------------------------------------------------------------------------}
procedure buyequipment(var player:character_t);

var
	theitem        :    item;
	price          :    integer;
	ans            :    char;

begin
	setcolor(black);
	setfont('triplex.ttf',3);
	outtextxy(10,420,'               (B)uy, (S)ell, or (E)xit');
	setcolor(white);
	with player do
	     if (numitems=itemmax) then
	          begin
	               setcolor(lightgray);
	               outtextxy(10,420,'  Sorry, but you don''t have room in your pack!');
	               setfont('default.ttf',2);
	               prompt;
	          end
	     else
	          begin
	               setfont('default.ttf',1);
	               outtextxy(120,160,'(1) SWORD');
	               outtextxy(120,170,'   10 coins');
	               outtextxy(120,260,'(2) SHIELD');
	               outtextxy(120,270,'   10 coins');
	               outtextxy(120,360,'(3) AXE');
	               outtextxy(120,370,'    7 coins');
	               outtextxy(270,160,'(4) CHAIN MAIL');
	               outtextxy(270,170,'   40 coins');
	               outtextxy(270,260,'(5) PLATE MAIL');
	               outtextxy(270,270,'   60 coins');
	               outtextxy(270,360,'(6) DAGGER');
	               outtextxy(270,370,'    3 coins');
	               outtextxy(420,160,'(7) CLUB');
	               outtextxy(420,170,'    3 coins');
	               outtextxy(420,260,'(8) STAFF');
	               outtextxy(420,270,'    5 coins');
	               outtextxy(420,360,'(9) HAMMER OF WAR');
	               outtextxy(420,370,'    5 coins');
	               setfont('sanseri.ttf',2);
	               setcolor(lightgray);
	               x:=10;
	               y:=420;
	               graphwrite(x,y,'Which item:  ');
	               repeat
	                    ans:=readarrowkey;
	               until(ans in ['1'..'9']);
	               case ans of
                        '1':begin
                        theitem:=sword;
                        price:=10;
                        end;
                        '2':begin
                        theitem:=shield;
                        price:=10;
                        end;
                        '3':begin
                        theitem:=axe;
                        price:=7;
                        end;
                        '4':begin
                        theitem:=chainmail;
                        price:=40;
                        end;
                        '5':begin
                        theitem:=platemail;
                        price:=60;
                        end;
                        '6':begin
                        theitem:=dagger;
                        price:=3;
                        end;
                        '7':begin
                        theitem:=club;
                        price:=3;
                        end;
                        '8':begin
                        theitem:=staff;
                        price:=5;
                        end;
                        '9':begin
                        theitem:=hammer;
                        price:=5;
                        end;
	               end;{case}
	               graphwrite(x,y,itemstring(theitem));
	               graphwrite(x,y,' -- ARE YOU SURE (y/n)');
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['y','Y','n','N']);
	               if (ans in ['y','Y']) and (coins<price) then
	                    begin
	                         setcolor(red);
	                         broke;
	                    end;
	               if (ans in ['y','Y']) and not(coins<price) then
	                    begin
	                         numitems:=numitems + 1;
	                         item[numitems]:=theitem;
	                         coins:=coins - price;
	                    end;
	          end;
end;
{---------------------------------------------------------------------------}
procedure sellequipment(var player:character_t);

var
	price          :    integer;
	tempstring     :    string;
	tempinteger    :    integer;
	tempcode       :    integer;
	count          :    integer;
	ans            :    char;

begin
	cleardevice;
	homecursor(x,y);
	setfont('sanseri.ttf',3);
	with player do
	     if (numitems>0) then
	          begin
	               setcolor(lightblue);
	               graphwriteln(x,y,'   ITEMS');
	               setcolor(white);
	               for count:=1 to numitems do
	                    begin
	                         str(count,tempstring);
	                         tempstring:=tempstring + '. ' + itemstring(item[count]);
	                         graphwriteln(x,y,tempstring);
	                    end;
	               graphwriteln(x,y,'Sell which one?');
	               str(numitems,tempstring);
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['1'..tempstring[1]]);
	               graphwriteln(x,y,'');
	               val(ans,tempinteger,tempcode);
	               tempstring:=itemstring(item[tempinteger]);
                   {
	               price:=item[tempinteger].value DIV 2;
                   }
                   case item[tempinteger] of
                        sword           :price:=5;
                        shield          :price:=5;
                        axe             :price:=4;
                        bluepotion      :price:=50;
                        redpotion       :price:=50;
                        greenpotion     :price:=150;
                        chainmail       :price:=20;
                        platemail       :price:=30;
                        dagger          :price:=2;
                        club            :price:=1;
                        staff           :price:=2;
                        hammer          :price:=3;
                        magicsword      :price:=1500;
                        magicshield     :price:=1500;
                        flamewand       :price:=2500;
                   end; {case}
	               graphwrite(x,y,'Sell '+ tempstring);
	               str(price,tempstring);
	               graphwriteln(x,y,' for ' + tempstring + ' coins? (y/n)');
	               drawpic(280,(numitems+7)*textheight('M'),itempicfile(item[tempinteger]));
	               repeat
	                    ans:=readarrowkey;
	               until(ans in ['y','Y','n','N']);
	               if (ans in ['y','Y']) then
	                    begin
	                         for count:=tempinteger to (numitems-1) do
	                              item[count]:=item[count + 1];
	                         numitems:=numitems - 1;
	                         coins:=coins + price;
	                    end;
	          end;
end;
{---------------------------------------------------------------------------}
procedure weaponshop(var player:character_t);

var
	tempstring     :    string;
	ans            :    char;

begin
	repeat
	     cleardevice;
	     setfont('gothic.ttf',5);
	     homecursor(x,y);
	     setcolor(darkgray);
	     outtextxy(x+3,y+3,'    Ye Olde Equipment Shop');
	     setcolor(lightgray);
	     outtextxy(x,y,'    Ye Olde Equipment Shop');
	     graphwriteln(x,y,'');
	     setfont('triplex.ttf',3);
	     y:=420;
	     graphwriteln(x,y,'               (B)uy, (S)ell, or (E)xit');
	     str(player.coins,tempstring);
	     setfont('default.ttf',1);
	     setcolor(white);
	     outtextxy(240,400,('You have ' + tempstring + ' coins'));

	     drawpic(150,100,'sword.ln1');
		 drawpic(150,200,'shield.ln1');
         drawpic(150,300,'axe.ln1');
         drawpic(300,100,'chain.ln1');
         drawpic(300,200,'plate.ln1');
         drawpic(300,300,'dagger.ln1');
         drawpic(450,100,'club.ln1');
         drawpic(450,200,'staff.ln1');
         drawpic(450,300,'hammer.ln1');

	     repeat
	          ans:=readarrowkey;
	     until (ans in ['e','E','b','B','s','S']);
	     case ans of
	          'e','E':exit;
	          'b','B':buyequipment(player);
	          's','S':sellequipment(player);
	     end;
	until FALSE;
end;
{---------------------------------------------------------------------------}
procedure useitem(var player:character_t);

var
	tempstring     :    string;
	tempinteger    :    integer;
	tempcode       :    integer;
	count          :    integer;
	ans            :    char;

begin
	cleardevice;
	homecursor(x,y);
	setfont('sanseri.ttf',3);
	with player do
	     if (numitems=0) then
	          begin
	               cleardevice;
	               setfont('sanseri.ttf',5);
	               outtextxy(150,150,'You have no items');
	               setfont('default.ttf',2);
	               prompt;
	          end;
	with player do
	     if (numitems>0) then
	          begin
	               setcolor(lightblue);
	               graphwriteln(x,y,'   ITEMS');
	               setcolor(white);
	               for count:=1 to numitems do
	                    begin
	                         str(count,tempstring);
	                         tempstring:=tempstring + '. ' + itemstring(item[count]);
	                         graphwriteln(x,y,tempstring);
	                    end;
	               graphwriteln(x,y,'Use which one?');
	               str(numitems,tempstring);
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['1'..tempstring[1]]);
	               graphwriteln(x,y,'');
	               val(ans,tempinteger,tempcode);
	               if not(item[tempinteger] in [redpotion,greenpotion,bluepotion]) then
	                    begin
	                         graphwriteln(x,y,'Cannot be used here!');
	                    end
	               else
	                    begin
	                         tempstring:=itemstring(item[tempinteger]);
	                         graphwrite(x,y,tempstring);
	                         graphwriteln(x,y,' will be used up.  Use? (y/n)');
	                         drawpic(280,(numitems+7)*textheight('M'),itempicfile(item[tempinteger]));
	                         repeat
	                              ans:=readarrowkey;
	                         until(ans in ['y','Y','n','N']);
	                         if (ans in ['y','Y']) then
	                              begin
	                                   setcolor(green);
	                                   cleardevice;
	                                   setfont('sanseri.ttf',2);
	                                   case item[tempinteger] of
	                                        bluepotion     :writefile(1,textdir+'blue.txt');
	                                        redpotion      :begin
	                                                             writefile(1,textdir+'red.txt');
	                                                             endurance:=endurance + roll('1d6')+1;
	                                                             if (endurance>endurancemax) then
	                                                                  endurance:=endurancemax;
	                                                        end;
	                                        greenpotion    :begin
	                                                             writefile(1,textdir+'green.txt');
	                                                             endurance:=endurancemax;
	                                                        end;
	                                   end;
	                                   for count:=tempinteger to numitems do
	                                        if (count<>numitems) then
	                                             item[count]:=item[count + 1];
	                                   numitems:=numitems - 1;
	                              end;
	                    end;
	               setfont('default.ttf',2);
	               prompt;
	          end;
end;
{---------------------------------------------------------------------------}
procedure magicbuyequipment(var player:character_t);

var
	theitem        :    item;
	price          :    integer;
	getring        :    boolean;
	ans            :    char;

begin
	setcolor(black);
	setfont('triplex.ttf',3);
	outtextxy(10,420,'            (B)uy, (S)ell, (L)earn or (E)xit');
	setcolor(white);
	with player do
	     if (numitems=itemmax) then
	          begin
	               setcolor(lightgray);
	               outtextxy(10,420,'  Sorry, but you don''t have room in your pack!');
	               setfont('default.ttf',2);
	               prompt;
	          end
	     else
	          begin
	               setfont('default.ttf',1);
	               outtextxy(110,160,'(1) BLUE POTION');
	               outtextxy(110,170,'    100 coins');
	               outtextxy(110,260,'(2) RED POTION');
	               outtextxy(110,270,'    100 coins');
	               outtextxy(110,360,'(3) GREEN POTION');
	               outtextxy(110,370,'    300 coins');
	               outtextxy(340,340,'(4) RING OF POWER');
	               outtextxy(340,350,'     800 coins');
	               setfont('sanseri.ttf',2);
	               setcolor(red);
	               x:=10;
	               y:=420;
	               graphwrite(x,y,'Which item:  ');
	               repeat
	                    ans:=readarrowkey;
	               until(ans in ['1'..'4']);
	               getring:=false;
	               case ans of
	                    '1':begin
	                             theitem:=bluepotion;
	                             price:=100;
	                        end;
	                    '2':begin
	                             theitem:=redpotion;
	                             price:=100;
	                        end;
	                    '3':begin
	                             theitem:=greenpotion;
	                             price:=300;
	                        end;
	                    '4':begin
	                             getring:=true;
	                             price:=800;
	                        end;
	               end;
	               if (getring) then
	                    graphwrite(x,y,'Ring of Power')
	               else
	                    graphwrite(x,y,itemstring(theitem));
	               graphwrite(x,y,' -- ARE YOU SURE (y/n)');
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['y','Y','n','N']);
	               if (ans in ['y','Y']) and (coins<price) then
	                    begin
	                         setcolor(red);
	                         broke;
	                    end;
	               if (ans in ['y','Y']) and not(coins<price) then
	                    if (getring) then
	                         begin
	                              setcolor(lightgray);
	                              if (ring in stages) then
	                                   begin
	                                        setfillstyle(solidfill,black);
	                                        bar(1,420,640,480);
	                                        setfont('triplex.ttf',3);
	                                        outtextxy(200,420,'You already have one.');
	                                        setfont('default.ttf',2);
	                                        prompt;
	                                   end
	                              else
	                                   begin
	                                        stages:=stages + [ring];
	                                        coins:=coins - price;
	                                        if not(numspells=spellmax)then
	                                             begin
	                                                  chargemax:=1;
	                                                  charges:=1;
	                                                  numspells:=1;
	                                                  spell[numspells]:=power;
	                                             end;
	                                   end;
	                         end
	                    else
	                         begin
	                              numitems:=numitems + 1;
	                              item[numitems]:=theitem;
	                              coins:=coins - price;
	                         end;
	          end;
end;
{---------------------------------------------------------------------------}
procedure learnspell(var player:character_t);

var
	thespell       :    spell;
	price          :    integer;
	present        :    boolean;
	ans            :    char;
	loop           :    integer;

begin
	setcolor(black);
	setfont('triplex.ttf',3);
	outtextxy(10,420,'            (B)uy, (S)ell, (L)earn or (E)xit');
	setcolor(white);
	with player do
	     if (numspells=spellmax) or not(ring in stages) then
	          begin
	               setcolor(lightgray);
	               if (ring in stages) then
	                    outtextxy(80,420,'Sorry, you can''t learn any more spells.')
	               else
	                    outtextxy(100,420,'You need a ring to store your spells.');
	               setfont('default.ttf',2);
	               prompt;
	          end
	     else
	          begin
	               setfillstyle(solidfill,black);
	               bar(380,280,460,360);
	               setfont('default.ttf',1);
	               outtextxy(360,240,'(1) CALL WILD');
	               outtextxy(360,250,'   100 coins');
	               outtextxy(360,270,'(2) COURAGE');
	               outtextxy(360,280,'   300 coins');
	               outtextxy(360,300,'(3) WEB');
	               outtextxy(360,310,'   400 coins');
	               outtextxy(360,330,'(4) HEAL');
	               outtextxy(360,340,'   500 coins');
	               outtextxy(360,360,'(5) FIRE BLAST');
	               outtextxy(360,370,'   600 coins');
	               setfont('sanseri.ttf',2);
	               setcolor(red);
	               x:=10;
	               y:=420;
	               graphwrite(x,y,'Which spell:  ');
	               repeat
	                    ans:=readarrowkey;
	               until(ans in ['1'..'5']);
	               case ans of
	                    '1':begin
	                             thespell:=callwild;
	                             price:=100;
	                        end;
	                    '2':begin
	                             thespell:=courage;
	                             price:=300;
	                        end;
	                    '3':begin
	                             thespell:=web;
	                             price:=400;
	                        end;
	                    '4':begin
	                             thespell:=heal;
	                             price:=500;
	                        end;
	                    '5':begin
	                             thespell:=fireblast;
	                             price:=600;
	                        end;
	               end;{case}
	               graphwrite(x,y,spellstring(thespell));
	               graphwrite(x,y,' -- ARE YOU SURE (y/n)');
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['y','Y','n','N']);
	               if (ans in ['y','Y']) and (coins<price) then
	                    begin
	                         setcolor(lightblue);
	                         broke;
	                    end;
	               if (ans in ['y','Y']) and not(coins<price) then
	                    begin
	                         present:=false;
	                         for loop:=1 to numspells do
	                              if (spell[loop]=thespell) then
	                                   present:=true;
	                         if (present) then
	                              begin
	                                   setcolor(lightgreen);
	                                   setfont('sanseri.ttf',5);
	                                   outtextxy(1,200,'    You already know that!!');
	                                   setfont('default.ttf',2);
	                                   prompt;
	                              end
	                         else
	                              begin
	                                   chargemax:=chargemax + 1;
	                                   if(chargemax>ringmax)then
	                                        chargemax:=ringmax;
	                                   charges:=charges+1;
	                                   if(charges>chargemax)then
	                                        charges:=chargemax;
	                                   numspells:=numspells + 1;
	                                   spell[numspells]:=thespell;
	                                   coins:=coins - price;
	                              end;
	                    end;
	          end;
end;
{----------------------------------------------------------------------------}
procedure magicshop(var player:character_t);

var
	tempstring     :    string;
	ans            :    char;

begin
	repeat
	     cleardevice;
	     setfont('gothic.ttf',5);
	     homecursor(x,y);
	     setcolor(magenta);
	     outtextxy(x+3,y+3,'          Magic Shop');
	     setcolor(cyan);
	     outtextxy(x,y,'          Magic Shop');
	     graphwriteln(x,y,'');
	     setfont('triplex.ttf',3);
	     y:=420;
	     graphwriteln(x,y,'            (B)uy, (S)ell, (L)earn or (E)xit');
	     str(player.coins,tempstring);
	     setfont('default.ttf',1);
	     setcolor(white);
	     outtextxy(240,400,('You have ' + tempstring + ' coins'));
             drawpic(20,280,'wizard.ln1');
             drawpic(150,100,'potion02.ln1'); {number based on color}
             drawpic(150,200,'potion05.ln1');
             drawpic(150,300,'potion03.ln1');
             drawpic(320,100,'skilbook.ln1');
             drawpic(380,280,'ring.ln1');
	     repeat
	          ans:=readarrowkey;
	     until (ans in ['e','E','b','B','s','S','l','L']);
	     case ans of
	          'e','E':exit;
	          'b','B':magicbuyequipment(player);
	          's','S':sellequipment(player);
	          'l','L':learnspell(player);
	     end;
	until FALSE;
end;
{---------------------------------------------------------------------------}
procedure fakebattle(var player:character_t);

var ch:char;

begin
	cleardevice;
	setcolor(red);
	setfont('sanseri.ttf',4);
	outtextxy(1,200,'You must now battle the Great Demon...');
	prompt;
	cleardevice;
	x:=(getmaxx DIV 2) - 100;
        drawpic(x,1,'gdemon.ln1');
	x:=(getmaxx DIV 2) - 60;
	drawpic(x,300,player.picfile);
	setcolor(red);
	setfont('sanseri.ttf',2);
	x:=(getmaxx DIV 2) - (textwidth('(A)ttack or (R)un') DIV 2);
	outtextxy(x,240,'(A)ttack or (R)un');
	repeat
	     ch:=readarrowkey;
	until (ch in ['a','A','r','R']);
	setfillstyle(solidfill,black);
	bar(1,240,640,300);
	if (ch in ['r','R']) then
	     begin
	          x:=(getmaxx DIV 2) - (textwidth('You''re legs won''t move!') DIV 2);
	          outtextxy(x,240,'You''re legs won''t move!')
	     end
	else
	     begin
	          x:=(getmaxx DIV 2) - (textwidth('You miss!') DIV 2);
	          outtextxy(x,240,'You miss!');
	     end;
	ch:=readarrowkey;
	bar(1,240,640,300);
	setfont('sanseri.ttf',2);
	outtextxy(1,240,'The Great Demon decimates you for 9999 points of damage!');
	ch:=readarrowkey;
	bar(1,240,640,300);
	setfont('sanseri.ttf',4);
	outtextxy(100,240,'Everything starts to go black...');
	player.endurance:=1;
end;
{---------------------------------------------------------------------------}
procedure castspell(var player:character_t;area:location);

var
	tempstring     :    string;
	tempinteger    :    integer;
	tempcode       :    integer;
	count          :    integer;
	ans            :    char;

begin
	cleardevice;
	homecursor(x,y);
	setfont('sanseri.ttf',3);
	with player do
	     if (numspells=0) then
	          begin
	               cleardevice;
	               setfont('sanseri.ttf',5);
	               outtextxy(150,150,'You have no spells');
	               setfont('default.ttf',2);
	               prompt;
	          end;
	with player do
	     if (numspells>0) then
	          begin
	               setcolor(lightblue);
	               graphwriteln(x,y,'   SPELLS');
	               setcolor(white);
	               for count:=1 to numspells do
	                    begin
	                         str(count,tempstring);
	                         tempstring:=tempstring + '. ' + spellstring(spell[count]);
	                         graphwriteln(x,y,tempstring);
	                    end;
	               graphwriteln(x,y,'Use which one?');
	               str(numspells,tempstring);
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['1'..tempstring[1]]);
	               graphwriteln(x,y,'');
	               val(ans,tempinteger,tempcode);
	               tempstring:=spellstring(spell[tempinteger]);
	               graphwrite(x,y,'Use ');
	               graphwrite(x,y,tempstring);
	               graphwriteln(x,y,'? (y/n)');
	               repeat
	                    ans:=readarrowkey;
	               until(ans in ['y','Y','n','N']);
	               if(charges<1)then
	                    begin
	                         setcolor(lightblue);
	                         setfont('sanseri.ttf',3);
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'  Your ring is out of power for today.');
	                         graphwriteln(x,y,'  Sleep and try again tomorrow.');
	                         ans:='n';
	                    end;
	               if (ans in ['y','Y']) then
	                    begin
	                         setcolor(green);
	                         cleardevice;
	                         setfont('sanseri.ttf',2);
	                         case spell[tempinteger] of
	                              icestorm,fireblast,icicle
	                                      :begin
	                                            setfont('sanseri.ttf',4);
	                                            outtextxy(120,180,'That''s a battle-time spell');
	                                            setfont('default.ttf',2);
	   {equal out the unused charge}            charges:=charges+1;
	                                       end;
	                              web:writefile(1,textdir+'027.txt');
	                              callwild:if (area=wilderness) then
	                                            writefile(1,textdir+'024.txt')
	                                       else
	                                            if (area=dungeon) then
	                                                 writefile(1,textdir+'025.txt')
	                                            else
	                                                 writefile(1,textdir+'007.txt');
	                              heal:begin
	                                        writefile(1,textdir+'008.txt');
	                                        endurance:=endurance + roll('1d6') +1;
	                                        if (endurance>endurancemax) then
	                                             endurance:=endurancemax;
	                                   end;
	                              obliterate:begin
	                                              writefile(1,textdir+'026.txt');
	   {equal out the unused charge}              charges:=charges+1;
	                                         end;
	                              power:case roll('1d20') of
	                                  1..3:begin
	                                            writefile(1,textdir+'009.txt');
	                                            endurance:=endurance + roll('1d2');
	                                            if (endurance>endurancemax) then
	                                                 endurance:=endurancemax;
	                                       end;
	                                  4..6:begin
	                                            writefile(1,textdir+'010.txt');
	                                            endurance:=endurance - roll('1d2');
	                                       end;
	                                  7..9:if (area=wilderness) then
	                                            writefile(1,textdir+'023.txt')
	                                       else
	                                            writefile(1,textdir+'011.txt');
	                                10..12:writefile(1,textdir+'012.txt');
	                                13..15:writefile(1,textdir+'028.txt');
	                                    16:if (area=town) then
	                                            writefile(1,textdir+'032.txt')
	                                       else
	                                            fakebattle(player);
	                                    17:begin
	                                            writefile(1,textdir+'033.txt');
	                                            endurance:=endurancemax;
	                                       end;
	                                18..20:writefile(1,textdir+'013.txt');
	                                end;{case}
	                             shatter:writefile(1,textdir+'014.txt');
	                             dragonbreath:if(area=wilderness)then
	                                               writefile(1,textdir+'029.txt')
	                                          else
	                                               if (area=dungeon) then
	                                                    writefile(1,textdir+'030.txt')
	                                               else
	                                                    writefile(1,textdir+'031.txt');
	                             resistfire:writefile(1,textdir+'034.txt');
	                             resistcold:writefile(1,textdir+'035.txt');
	                             courage:writefile(1,textdir+'036.txt');
	                             glacier:writefile(1,textdir+'037.txt');
	                             freeze:writefile(1,textdir+'038.txt');
	                         end;{case}
	                         charges:=charges-1;
	                    end;
	               prompt;
	               if(endurance=0)then
	                    died;
	          end;
end;
{---------------------------------------------------------------------------}
procedure clearpub;

begin
	setfillstyle(solidfill,black);
	bar(1,120,640,480);
end;
{---------------------------------------------------------------------------}
procedure buydrink(var coins:longint);

const
	drinkprice     =    2;

var
	tempstring     :    string;
	ans            :    char;

begin
	y:=135;
	graphwriteln(x,y,'               All Drinks -- 2 coins');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'                     (1) ale');
	graphwriteln(x,y,'                     (2) beer');
	graphwriteln(x,y,'                     (3) wine');
	graphwriteln(x,y,'                     (4) whiskey');
	graphwriteln(x,y,'                     (5) special');
	graphwriteln(x,y,'                     (N) none');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'      "Our special drink is the Beholder''s Spit."');
	str(coins,tempstring);
	setfont('default.ttf',1);
	setcolor(white);
	outtextxy(240,400,('You have ' + tempstring + ' coins'));
	setcolor(lightmagenta);
	setfont('sanseri.ttf',3);
	graphwriteln(x,y,'');
	graphwriteln(x,y,'                 What do you take?');
	repeat
	     ans:=readarrowkey;
	until (ans in ['1'..'5','n','N']);
	if (ans in ['n','N']) then
	     exit;
	if (coins<drinkprice) then
	     begin
	          setcolor(lightred);
	          broke;
	     end
	else
	     begin
	          clearpub;
	          setfont('sanseri.ttf',4);
	          setcolor(red);
	          case ans of
	             '1','2','3':outtextxy(1,180,'      Hey, that''s not bad.  (Burp)');
	             '4':outtextxy(1,200,'          My, that''s good stuff!');
	             '5':outtextxy(1,220,' Whoa!  It really burns as it goes down!');
	          end;{case}
	          coins:=coins - drinkprice;
	          setfont('default.ttf',2);
	          prompt;
	     end;
end;
{---------------------------------------------------------------------------}
procedure skulldice(var player:character_t);


const
	skullprice     =    100;

var
	blackdice      :    integer;
	whitedice      :    integer;
	skulldice      :    integer;
	thepicture     :    string;
	present        :    boolean;
	tempstring     :    string;
	ans            :    char;
	loop           :    integer;

begin
	str(skullprice,tempstring);
	tempstring:='   It will cost '+tempstring+' coins to play a game of Skull Dice';
	outtextxy(1,180,tempstring);
	str(player.coins,tempstring);
	setfont('default.ttf',1);
	setcolor(white);
	outtextxy(240,400,('You have ' + tempstring + ' coins'));
	setcolor(lightmagenta);
	setfont('sanseri.ttf',3);
	outtextxy(1,420,'                  Go ahead? (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['n','N']) then
	     exit;
	with player do
	     if (coins<skullprice) then
	          begin
	               setcolor(lightred);
	               broke;
	          end
	     else
	          begin
	               coins:=coins - skullprice;
	               blackdice:=0;
	               whitedice:=0;
	               skulldice:=0;
	               for loop:=1 to 4 do
	                    begin
	                         case roll('1d6') of
	                              1:begin
	                                     blackdice:=blackdice + 1;
                                             thepicture:='blackdie.ln1';
	                                end;
	                              2,3:begin
	                                       whitedice:=whitedice + 1;
                                               thepicture:='whitedie.ln1';
	                                  end;
	                              4,5,6:begin
	                                         skulldice:=skulldice + 1;
                                                 thepicture:='skulldie.ln1';
	                                    end;
	                         end;{case}
	                         drawpic(loop*115,240,thepicture);
	                    end;
	               x:=10;
	               y:=300;
	               setcolor(yellow);
	               setfont('sanseri.ttf',3);
	               if (skulldice=4) then
	                    begin
	                         graphwriteln(x,y,'"Ha, ha!  You lose!  And now the game begins,"  with');
	                         graphwriteln(x,y,'that Roland pulls out his french fry wand.  You quickly');
	                         graphwriteln(x,y,'dodge his attacks.  Then, Roland just obliterates you.');
	                         setfont('default.ttf',2);
	                         prompt;
	                         died;
	                         exit;
	                    end
	               else
	                    if (skulldice=3) then
	                         graphwriteln(x,y,'     "Watch out!  Almost had to kill ya there."')
	                    else
	                         if (blackdice=4) then
	                              begin
	                                   graphwriteln(x,y,'   "YOU WIN THE GRAND PRIZE!  I will teach you the');
	                                   graphwriteln(x,y,'   obliterate spell."');
	                                   if (numspells=spellmax) then
	                                        graphwriteln(x,y,'       Too bad you can''t learn anymore spells.')
	                                   else
	                                        begin
	                                             present:=false;
	                                             for loop:=1 to numspells do
	                                                  if (spell[loop]=obliterate) then
	                                                       present:=true;
	                                             if (present) then
	                                                  graphwriteln(x,y,'    But you already know how to obliterate things.')
	                                             else
	                                                  if (ring in stages) then
	                                                       begin
	                                                            chargemax:=chargemax + 1;
	                                                            if(chargemax>ringmax)then
	                                                                 chargemax:=ringmax;
	                                                            charges:=charges+1;
	                                                            if(charges>chargemax)then
	                                                                 charges:=chargemax;
	                                                            numspells:=numspells + 1;
	                                                            spell[numspells]:=obliterate;
	                                                       end
	                                                  else
	                                                       graphwriteln(x,y,'        Too bad you don''t have a ring, huh?');
	                                        end;
	                              end
	                         else
	                              if (whitedice=4) then
	                                   begin
	                                        graphwriteln(x,y,'"You are the proud owner of a Ring of Power."');
	                                        if (ring in stages) then
	                                             begin
	                                                  graphwriteln(x,y,'You already have one...');
	                                                  graphwriteln(x,y,'Roland enchants your ring with an extra charge.');
	                                                  chargemax:=chargemax + 1;
	                                                  if (chargemax>ringmax) then
	                                                       charges:=ringmax;
	                                                  charges:=chargemax;
	                                             end
	                                        else
	                                             begin
	                                                  stages:=stages + [ring];
	                                                  if not(numspells=spellmax)then
	                                                       begin
	                                                            chargemax:=1;
	                                                            charges:=1;
	                                                            numspells:=1;
	                                                            spell[numspells]:=power;
	                                                       end;
	                                             end;
	                                   end
	                              else
	                                   if (blackdice=3) then
	                                        begin
	                                             graphwriteln(x,y,'"Great!  Here''s a green potion with your name on it."');
	                                             if (numitems=itemmax) then
	                                                  graphwriteln(x,y,'You must decline since you cannot carry anymore.')
	                                             else
	                                                  begin
	                                                       numitems:=numitems + 1;
	                                                       item[numitems]:=greenpotion;
	                                                  end;
	                                        end
	                                   else
	                                        if (whitedice=3) then
	                                             begin
	                                                  graphwriteln(x,y,'       "You win.  Your prize is a blue potion."');
	                                                  if (numitems=itemmax) then
	                                                       graphwriteln(x,y,'You must decline since you cannot carry anymore.')
	                                                  else
	                                                       begin
	                                                            numitems:=numitems + 1;
	                                                            item[numitems]:=bluepotion;
	                                                       end;
	                                             end
	                                        else
	                                             graphwriteln(x,y,'                "Sorry, no prize."');
	               setfont('default.ttf',2);
	               prompt;
	          end;
end;
{---------------------------------------------------------------------------}
procedure tip(var coins:longint);

const
	tipprice       =    1;

begin
	if (coins<tipprice) then
	     begin
	          setcolor(lightred);
	          broke;
	     end
	else
	     begin
	          coins:=coins - tipprice;
	          outtextxy(1,140,'You toss Roland a coin and he tells you:  ');
	          case roll('1d8') of
	               1:writefile(240,textdir+'015.txt');
	               2:writefile(240,textdir+'016.txt');
	               3:writefile(240,textdir+'017.txt');
	               4:writefile(240,textdir+'018.txt');
	               5:writefile(240,textdir+'019.txt');
	               6:writefile(240,textdir+'020.txt');
	               7:writefile(240,textdir+'021.txt');
	               8:writefile(240,textdir+'022.txt');
	          end;
	          setfont('default.ttf',2);
	          prompt;
	     end;
end;
{---------------------------------------------------------------------------}
procedure attack_roland(var player:character_t);

begin
	nummonsters:=1;
	rollmonsters(monster,nummonsters,'roland.dat');
	monster[1].endurance:=200;
	monster[1].endurancemax:=200;
	combat(player,nummonsters,monster);
	if (nummonsters=0) then
	     begin
	          cleardevice;
	          setcolor(red);
	          setfont('triplex.ttf',3);
	          homecursor(x,y);
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'You have defeated Roland McDoland!');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'However, all the people rush to his aid, and');
	          graphwriteln(x,y,'he is taken to be healed...');
	          prompt;
	          cleardevice;
	     end;
end;
{---------------------------------------------------------------------------}
procedure pub(var player:character_t);

var
	password    :    string;
	tempstring  :    string;
	ans         :    char;

begin
	cleardevice;
        drawpic(2,1,'pub.ln1');
        drawpic(40,160,'dwarf.ln1');
	setfont('sanseri.ttf',3);
	setcolor(magenta);
	x:=210;
	y:=200;
	graphwriteln(x,y,'Bobo the Dwarf is the bouncer here.');
	x:=210;
	graphwriteln(x,y,'   "What''s the password?"');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	setcolor(lightmagenta);
	graphwrite(x,y,'You respond:  ');
	graphread(x,y,password);
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	setcolor(magenta);
	if not(capitalize(password)='CRYSTAL SHARD') then
	     begin
	          graphwriteln(x,y,'"Sorry, no password, no entrance,"  Bobo shoves');
	          graphwriteln(x,y,'you off.');
	          setfont('default.ttf',2);
	          prompt;
	     end
	else
	     begin
	          graphwriteln(x,y,'"Great!  Come on in!"  You enter the Metallic Beholder');
	          graphwriteln(x,y,'Pub.');
	          setfont('default.ttf',2);
	          prompt;
	          repeat
	               clearpub;
                       drawpic(240,140,'roland.ln1');
	               setfont('sanseri.ttf',3);
	               setcolor(lightmagenta);
	               outtextxy(1,280,'      "So, what''ll it be," asks Roland McDoland');
	               setfont('triplex.ttf',3);
	               homecursor(x,y);
	               y:=420;
	               graphwriteln(x,y,'            (B)uy, (P)lay, (T)ip or (E)xit');
	               str(player.coins,tempstring);
	               setfont('default.ttf',1);
	               setcolor(white);
	               outtextxy(240,400,('You have ' + tempstring + ' coins'));
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['e','E','b','B','p','P','t','T','*']);
	               clearpub;
	               setfont('sanseri.ttf',3);
	               setcolor(magenta);
	               homecursor(x,y);
	               case ans of
	                    'e','E':exit;
	                    'b','B':buydrink(player.coins);
	                    'p','P':skulldice(player);
	                    't','T':tip(player.coins);
	                        '*':attack_roland(player);
	               end;{case}
	               if (GAMEOVER) then exit;
	          until FALSE;
	     end;
end;
{---------------------------------------------------------------------------}
procedure inn(var player:character_t);

const
	innprice      =    5;

var
	tempstring     :    string;
	ans            :    char;

begin
	cleardevice;
	setfont('gothic.ttf',5);
	homecursor(x,y);
	setcolor(darkgray);
	outtextxy(x+1,y+1,'     The Eagle Talon Inn');
	setcolor(cyan);
	outtextxy(x,y,'     The Eagle Talon Inn');
        drawpic(420,120,'innkeep.ln1');
	setfont('sanseri.ttf',3);
	setcolor(lightblue);
	str(innprice,tempstring);
	outtextxy(1,160,'    "We charge '+ tempstring + ' coins a night."');
	str(player.coins,tempstring);
	setfont('default.ttf',1);
	setcolor(white);
	outtextxy(240,400,('You have ' + tempstring + ' coins'));
	setcolor(lightcyan);
	setfont('sanseri.ttf',3);
	outtextxy(1,420,'             Do you stay the night? (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['n','N','y','Y']);
	if (ans in ['n','N']) then
	     exit
	else
	     with player do
	          if (coins<innprice) then
	               begin
	                    setcolor(yellow);
	                    broke;
	               end
	          else
	               begin
	                    cleardevice;
	                    setcolor(yellow);

	                    y:=120;
	                    graphwriteln(x,y,'                     Zzzzzzzz....');
	                    graphwriteln(x,y,'');
	                    setcolor(cyan);
	                    coins:=coins - innprice;
	                    graphwriteln(x,y,'     You sleep the night and gain a little health.');
	                    endurance:=endurance + roll('1d4');
	                    if(endurance>endurancemax)then
	                         endurance:=endurancemax;
	                    charges:=chargemax;
	                    if (roll('1d100')<=5) then
	                         begin
	                              graphwriteln(x,y,'');
	                              graphwriteln(x,y,'');
	                              setcolor(blue);
	                              setfont('triplex.ttf',2);
	                              graphwrite(x,y,'You find a small note under ');
	                              graphwriteln(x,y,'your pillow that says, "the');
	                              graphwriteln(x,y,'password is... crystal shard"');
	                         end;
	                    setfont('default.ttf',2);
	                    prompt;
	               end;
end;
{---------------------------------------------------------------------------}
procedure townoptions(var leavetown:boolean);

var ans:char;

begin
	setcolor(lightblue);
	setfont('default.ttf',3);
	x:=10;
	y:=100;
	graphwriteln(x,y,'      Town Options');
	graphwriteln(x,y,'');
	setfont('default.ttf',2);
	graphwriteln(x,y,'');
	setcolor(lightcyan);
	graphwrite(x,y,'            V');
	setcolor(lightblue);
	graphwriteln(x,y,'iew Stats');
	graphwriteln(x,y,'');
	setcolor(lightcyan);
	graphwrite(x,y,'            U');
	setcolor(lightblue);
	graphwriteln(x,y,'se Item');
	graphwriteln(x,y,'');
	setcolor(lightcyan);
	graphwrite(x,y,'            C');
	setcolor(lightblue);
	graphwriteln(x,y,'ast Spell');
	graphwriteln(x,y,'');
	setcolor(lightcyan);
	graphwrite(x,y,'            L');
	setcolor(lightblue);
	graphwriteln(x,y,'eave Town');
	graphwriteln(x,y,'');
	setcolor(lightcyan);
	graphwrite(x,y,'            S');
	setcolor(lightblue);
	graphwriteln(x,y,'ave Game');
	graphwriteln(x,y,'');
	setcolor(lightcyan);
	graphwrite(x,y,'            Q');
	setcolor(lightblue);
	graphwriteln(x,y,'uit Game');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	setcolor(lightcyan);
	graphwrite(x,y,'  ** ');
	setcolor(lightblue);
	graphwrite(x,y,'any other key--Back to Town');
	setcolor(lightcyan);
	graphwriteln(x,y,' **');
	ans:=readarrowkey;
	case ans of
	 'v','V':viewstats(player);
	 'u','U':useitem(player);
	 'c','C':castspell(player,town);
	 'l','L':leavetown:=true;
	 's','S':savegame(player);
	 'q','Q':GAMEOVER:=TRUE;
	end;{case}
end;
{---------------------------------------------------------------------------}
procedure thetown(var player:character_t);

var
	leavetown      :    boolean;
	ans            :    char;

begin
	if (not(endgame in player.stages))and(iceq in player.stages) then
	     begin
	          cleardevice;
	          setfont('triplex.ttf',3);
	          setcolor(red);
	          writefile(1,textdir+'081.txt');
	          prompt;
	          player.coins:=player.coins+reward;
	          player.stages:=player.stages + [endgame];
	     end;
	leavetown:=false;
	repeat
	     cleardevice;
             drawpic(45,45,'thetown.ln1');
	     setfont('default.ttf',1);
	     setcolor(white);
	     x:=10;
	     y:=410;
	     graphwriteln(x,y,'                        choose a place to visit (1-4)');
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'                          press <SPACE> for options');
	     repeat
	          ans:=readarrowkey;
	     until (ans in ['1'..'4',' ']);
	     cleardevice;
	     case ans of
	          '1':weaponshop(player);
	          '2':magicshop(player);
	          '3':inn(player);
	          '4':pub(player);
	     end;{case}
	     if (ans=' ') then
	        townoptions(leavetown);
	     if GAMEOVER then leavetown:=true;
	until LEAVETOWN;
end;

{The Elf Skull Inn}
{---------------------------------------------------------------------------}
procedure clearesi;

begin
	setfillstyle(solidfill,black);
	bar(0,175,640,480);
end;
{---------------------------------------------------------------------------}
procedure esi_gossip;

begin
	setcolor(lightred);
	graphwriteln(x,y,'You overhear some gossip...');
	graphwriteln(x,y,'');
	case roll('1d8') of
	   1:writefile(250,textdir+'040.txt');
	   2:writefile(250,textdir+'041.txt');
	   3:writefile(250,textdir+'042.txt');
	   4:writefile(250,textdir+'043.txt');
	   5:writefile(250,textdir+'044.txt');
	   6:writefile(250,textdir+'045.txt');
	   7:writefile(250,textdir+'046.txt');
	   8:writefile(250,textdir+'047.txt');
	end;{case}

end;
{---------------------------------------------------------------------------}
procedure esi_dilvish(var player:character_t);

var
	tempmonster    :    monsterlist;
	ans            :    char;

begin
	setcolor(green);
	writefile(200,textdir+'048.txt');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['y','Y']) then
	     begin
	          clearesi;
	          writefile(175,textdir+'049.txt');
	          repeat
	               ans:=readarrowkey;
	          until (ans in ['a','A','s','S']);
	          player.stages:=player.stages + [dilvish];
	          if (ans in ['a','A']) then
	               begin
	                    nummonsters:=1;
	                    rollmonsters(tempmonster,nummonsters,'dilvish.dat');
	                    monster[1]:=tempmonster[1];
	                    rollmonsters(tempmonster,nummonsters,'prudence.dat');
	                    monster[2]:=tempmonster[1];
	                    rollmonsters(tempmonster,nummonsters,'spirit.dat');
	                    monster[3]:=tempmonster[1];
	                    rollmonsters(tempmonster,nummonsters,'marcus.dat');
	                    monster[4]:=tempmonster[1];
	                    nummonsters:=4;
	                    combat(player,nummonsters,monster);
	                    cleardevice;
                            drawpic(70,10,'esi.ln1');
	                    setfont('default.ttf',6);
	                    setcolor(green);
	                    y:=175;
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'');
	                    if (nummonsters=0) then
	                         begin
	                              graphwriteln(x,y,'You killed the elf and his companions.');
	                         end
	                    else
	                         graphwriteln(x,y,'You escape and climb back up through the trap door.');
	                    graphwriteln(x,y,'You quickly go back to the bar.');
	               end
	          else
	               begin
	                    clearesi;
	                    writefile(175,textdir+'050.txt');
	                    prompt;
	                    clearesi;
	                    writefile(175,textdir+'051.txt');
	                    repeat
	                         ans:=readarrowkey;
	                    until (ans in ['y','Y','n','N']);
	                    clearesi;
	                    y:=175;
	                    if (ans in ['y','Y']) and
	                       not((player.numspells=spellmax) or not(ring in player.stages))then
	                         with player do
	                              begin
	                                   graphwriteln(x,y,'You learn SHATTER.');
	                                   chargemax:=chargemax + 1;
	                                   if(chargemax>ringmax)then
	                                        chargemax:=ringmax;
	                                   charges:=charges+1;
	                                   if(charges>chargemax)then
	                                        charges:=chargemax;
	                                   numspells:=numspells + 1;
	                                   spell[numspells]:=shatter;
	                              end
	                    else
	                         if (player.numspells=spellmax) then
	                              graphwriteln(x,y,'Sorry, you can''t learn any more spells.')
	                         else
	                              if not(ring in player.stages) then
	                                   graphwriteln(x,y,'You need a ring to store your spells.')
	                              else
	                                        graphwriteln(x,y,'You humbly decline his offer.');
	                    graphwriteln(x,y,'Dilvish and his companions bid you farewell.');
	               end;
	     end;
end;
{---------------------------------------------------------------------------}
procedure esi_encounter(var player:character_t);

var ans:char;

begin
	setcolor(lightblue);
	case roll('1d6') of
	   1:begin
	          if not(baltar in player.stages) then
	               begin
	                    writefile(200,textdir+'052.txt');
	                    repeat
	                         ans:=readarrowkey;
	                    until (ans in ['y','Y','n','N']);
	                    clearesi;
	                    if (ans in ['y','Y']) then
	                         writefile(175,textdir+'058.txt')
	                    else
	                         begin
	                              clearesi;
	                              writefile(175,textdir+'059.txt');
	                              repeat
	                                   ans:=readarrowkey;
	                              until (ans in ['y','Y','n','N']);
	                              clearesi;
	                              if (ans in ['n','N']) then
	                                   writefile(175,textdir+'060.txt')
	                              else
	                                   begin
	                                        nummonsters:=1;
	                                        rollmonsters(monster,nummonsters,'baltar.dat');
	                                        combat(player,nummonsters,monster);
	                                        cleardevice;
                                                drawpic(70,10,'esi.ln1');
	                                        setfont('default.ttf',6);
	                                        setcolor(lightblue);
	                                        y:=175;
	                                        graphwriteln(x,y,'');
	                                        graphwriteln(x,y,'');
	                                        if (nummonsters=0) then
	                                             begin
	                                                  player.stages:=player.stages+[baltar];
	                                                  graphwriteln(x,y,'The crowd goes wild as you defeat Baltar!');
	                                             end
	                                        else
	                                             graphwriteln(x,y,'You are able to unlock the cage and escape.');
	                                        graphwriteln(x,y,'You go back to the bar.');
	                                   end;
	                         end;
	               end
	          else
	               esi_gossip;
	     end;
	   2:begin
	          writefile(200,textdir+'053.txt');
	     end;
	   3:begin
	          writefile(200,textdir+'054.txt');
	     end;
	   4:begin
	          writefile(200,textdir+'055.txt');
	     end;
	   5:begin
	          writefile(200,textdir+'056.txt');
	     end;
	   6:begin
	          writefile(200,textdir+'057.txt');
	     end;
	end;{case}

end;
{---------------------------------------------------------------------------}
procedure esi_drink(var player:character_t);

var
	tempstring     :    string;
	drinkprice     :    integer;
	ans            :    char;

begin
	y:=175;
	graphwriteln(x,y,'''''What''ll ya have?'''' asks Ahab the one-eyed bartender.');
	graphwriteln(x,y,'He points to a sign over the bar...');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'     (1) beer           (1 coins)');
	graphwriteln(x,y,'     (2) ale            (1 coins)');
	graphwriteln(x,y,'     (3) mead           (2 coins)');
	graphwriteln(x,y,'     (4) wine           (2 coins)');
	graphwriteln(x,y,'     (5) rum            (3 coins)');
	graphwriteln(x,y,'     (6) whiskey        (3 coins)');
	graphwriteln(x,y,'     (7) gin            (3 coins)');
	graphwriteln(x,y,'     (8) vodka          (3 coins)');
	graphwriteln(x,y,'     (9) Gorgon''s Milk   (5 coins)');
	graphwriteln(x,y,'     (N) No thanks');
	str(player.coins,tempstring);
	setfont('default.ttf',1);
	setcolor(white);
	outtextxy(250,460,('You have ' + tempstring + ' coins'));
	setcolor(yellow);
	setfont('default.ttf',6);
	graphwriteln(x,y,'');
	graphwriteln(x,y,'What do you take?');
	repeat
	     ans:=readarrowkey;
	until (ans in ['1'..'9','n','N']);
	if (ans in ['n','N']) then
	     begin
	          setcolor(lightblue);
	          graphwriteln(x,y,'                         Ahab grumbles');
	          setfont('default.ttf',6);
	          prompt;
	          exit;
	     end;
	case ans of
	     '1':drinkprice:=1;
	     '2':drinkprice:=1;
	     '3':drinkprice:=2;
	     '4':drinkprice:=2;
	     '5':drinkprice:=3;
	     '6':drinkprice:=3;
	     '7':drinkprice:=3;
	     '8':drinkprice:=3;
	     else
	          drinkprice:=5;
	end;
	if (player.coins<drinkprice) then
	     begin
	          setcolor(green);
	          broke;
	     end
	else
	     begin
	          clearesi;
	          y:=175;
	          setcolor(red);
	          graphwriteln(x,y,'You sit down and have you''re drink.');
	          player.coins:=player.coins - drinkprice;
	          graphwriteln(x,y,'');
	          case roll('1d100') of
	              1..20:begin
	                         writefile(200,textdir+'061.txt');
	                    end;
	             21..80:begin
	                         esi_gossip;
	                    end;
	             81..90:begin
	                         graphwriteln(x,y,'Ahab leans over to tell you a secret.');
	                         graphwriteln(x,y,'     ''''Should ye wish to stay the night, I could send a little');
	                         graphwriteln(x,y,'     company up to yer room, if ya know what I mean.''''');
	                         graphwriteln(x,y,'Ahab lifts the patch over his eye to give you a wink.');
	                    end;
	             91..95:begin
	                         if (dilvish in player.stages) then
	                              esi_gossip
	                         else
	                              esi_dilvish(player);
	                    end;
	            96..100:begin
	                         esi_encounter(player);
	                    end;
	           end;{case}
	          setfont('default.ttf',6);
	          prompt;
	     end;

end;
{---------------------------------------------------------------------------}
procedure esi_room(var player:character_t);

var
	roomprice      :    longint;
	company        :    boolean;
	ans            :    char;


begin
	y:=175;
	graphwriteln(x,y,'''''Rooms are 5 coins per night,'''' says Ahab.');
	roomprice:=5;
	graphwriteln(x,y,'');
	graphwrite(x,y,'Do you want a room?  (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['y','Y']) then
	     begin
	          graphwriteln(x,y,'  y');
	          graphwriteln(x,y,'''How about a little company tonight?  Only 20 coins.''');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'You respond?  (y/n)');
	          repeat
	               ans:=readarrowkey;
	          until (ans in ['y','Y','n','N']);
	          company:=(ans in ['y','Y']);
	          if (company) then
	               roomprice:=roomprice+20;
	          if (player.coins<roomprice) then
	               begin
	                    clearesi;
	                    setcolor(green);
	                    broke;
	                    exit;
	               end
	          else
	               player.coins:=player.coins - roomprice;
	          clearesi;
	          y:=175;
	          setcolor(magenta);
	          graphwriteln(x,y,'You stay the night at the Elf Skull Inn.');
	          graphwriteln(x,y,'');
	          player.charges:=player.chargemax;
	          if (company) then
	               begin
	                    writefile(200,textdir+'062.txt');
	                    prompt;
	                    clearesi;
	                    y:=175;
	                    if (roll('1d100')<=6) then
	                         begin
	                              writefile(175,textdir+'063.txt');
	                              prompt;
	                              nummonsters:=1;
	                              rollmonsters(monster,nummonsters,'succubus.dat');
	                              combat(player,nummonsters,monster);
	                              cleardevice;
                                      drawpic(70,10,'esi.ln1');
	                              setfont('default.ttf',6);
	                              x:=10;
	                              y:=175;
	                              setcolor(magenta);
	                              graphwriteln(x,y,'Maybe you should enjoy your room alone from now on...');
	                         end
	                    else
	                         begin
	                              x:=10;
	                              graphwriteln(x,y,'You enjoy yourselves, but don''t get much rest.');
	                              player.endurance:=player.endurance + roll('1d2');
	                              if (player.endurance>player.endurancemax) then
	                                   player.endurance:=player.endurancemax;
	                         end;
	               end
	          else
	               begin
	                    graphwriteln(x,y,'Loud parties and bouts of laughter keep you up half the night,');
	                    graphwriteln(x,y,'but eventually you get to sleep.');
	                    player.endurance:=player.endurance + roll('1d3');
	                    if (player.endurance>player.endurancemax) then
	                         player.endurance:=player.endurancemax;
	               end;
	          prompt;
	     end;
end;
{---------------------------------------------------------------------------}
procedure esi_dice(var player:character_t);

var
	tempstring     :    string;
	bet            :    word;
	errcode        :    integer;
	die            :    array[1..2] of integer;
	loop           :    integer;
	total          :    integer;
	ans            :    char;
	ch             :    char;

begin
	y:=175;
	graphwriteln(x,y,'You walk over to the craps table.');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'Do you play?  (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['y','Y']) then
	     begin
	          graphwriteln(x,y,'');
	          graphwrite(x,y,'You bet (up to 1000 coins): ');
	          graphread(x,y,tempstring);
	          val(tempstring,bet,errcode);
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          if (bet<1) then
	               begin
	                    graphwriteln(x,y,'What''s the point of playing for nothing?');
	                    prompt;
	                    exit;
	               end;
	          if (bet>1000) then
	               begin
	                    graphwriteln(x,y,'Sorry, they don''t accept such high bets.');
	                    prompt;
	                    exit;
	               end;
	          if (player.coins<bet) then
	               begin
	                    setcolor(lightcyan);
	                    broke;
	                    exit;
	               end;
	          clearesi;
	          y:=175;
	          setcolor(cyan);
	          graphwriteln(x,y,'You have placed your bet, now press space to roll the dice.');
	          repeat
	               ch:=readarrowkey;
	          until (ch=' ');
	          for loop:=1 to 2 do
	               begin
	                    die[loop]:=roll('1d6');
	                    case die[loop] of
                                 1:drawpic(200+((loop-1)*50),200,'die1.ln1');
                                 2:drawpic(200+((loop-1)*50),200,'die2.ln1');
                                 3:drawpic(200+((loop-1)*50),200,'die3.ln1');
                                 4:drawpic(200+((loop-1)*50),200,'die4.ln1');
                                 5:drawpic(200+((loop-1)*50),200,'die5.ln1');
                                 6:drawpic(200+((loop-1)*50),200,'die6.ln1');
	                    end;{case}
	               end;
	          setcolor(cyan);
	          x:=10;
	          y:=250;
	          total:=die[1] + die[2];
	          if (total=2) or (total=12) then
	               begin
	                    graphwriteln(x,y,'Sorry, you lose.');
	                    player.coins:=player.coins - bet;
	                    prompt;
	                    exit;
	               end;
	          if (total=7) then
	               begin
	                    graphwriteln(x,y,'Excellent!  You win!');
	                    player.coins:=player.coins + bet;
	                    prompt;
	                    exit;
	               end;
	          graphwriteln(x,y,'Roll again... (press space)');
	          repeat
	               ch:=readarrowkey;
	          until (ch=' ');
	          for loop:=1 to 2 do
	               begin
	                    die[loop]:=roll('1d6');
	                    case die[loop] of
                                 1:drawpic(200+((loop-1)*50),300,'die1.ln1');
                                 2:drawpic(200+((loop-1)*50),300,'die2.ln1');
                                 3:drawpic(200+((loop-1)*50),300,'die3.ln1');
                                 4:drawpic(200+((loop-1)*50),300,'die4.ln1');
                                 5:drawpic(200+((loop-1)*50),300,'die5.ln1');
                                 6:drawpic(200+((loop-1)*50),300,'die6.ln1');
	                    end;{case}
	               end;
	          setcolor(cyan);
	          x:=10;
	          y:=350;
	          if (total<>(die[1]+die[2])) then
	               begin
	                    graphwriteln(x,y,'Very unfortunate, you lose.');
	                    player.coins:=player.coins - bet;
	               end
	          else
	               begin
	                    graphwriteln(x,y,'Congratulations.  You win!');
	                    player.coins:=player.coins + bet;
	               end;
	          prompt;
	     end;
end;
{---------------------------------------------------------------------------}
procedure esi_magic(var player:character_t);

var
	theitem        :    item;
	price          :    integer;
	ans            :    char;

begin
	y:=175;
	setcolor(lightcyan);
	graphwriteln(x,y,'The Magic Merchant welcomes you warmly to examine his wares.');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'     1) Red Potion    ONLY 100 coins!');
	graphwriteln(x,y,'     2) Blue Potion   ONLY 120 coins!');
	graphwriteln(x,y,'     3) Green Potion  ONLY 300 coins!');
	graphwriteln(x,y,'     4) Ring Charge   ONLY 400 coins!');
	graphwriteln(x,y,'     N)one');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'''''What do you like?'''' grins the Magic Merchant.');
	graphwriteln(x,y,'');
	repeat
	     ans:=readarrowkey;
	until (ans in ['1'..'4','n','N']);
	if (ans in ['n','N']) then
	     exit;
	case ans of
	     '1':begin
	              theitem:=redpotion;
	              price:=100;
	         end;
	     '2':begin
	              theitem:=bluepotion;
	              price:=120;
	         end;
	     '3':begin
	              theitem:=greenpotion;
	              price:=300;
	         end;
	     '4':begin
	              price:=400;
	              if not(ring in player.stages) then
	                   graphwriteln(x,y,'But you don''t have a ring!')
	              else
	                   begin
	                        if (price>player.coins) then
	                             begin
	                                  setcolor(brown);
	                                  broke;
	                                  exit;

	                             end;
	                        if (player.charges=ringmax) then
	                             begin
	                                  graphwriteln(x,y,'Your ring cannot contain more charges.');
	                                  prompt;
	                                  exit;
	                             end;
	                        player.charges:=player.charges+1;
	                        player.chargemax:=player.chargemax+1;
	                        player.coins:=player.coins-price;
	                        graphwriteln(x,y,'''''Pleasure doing business with you!''''');
	                        prompt;
	                   end;
	         end;
	end;
	if (ans in ['1'..'3']) then
	     begin
	          if (player.numitems=itemmax) then
	               begin
	                    setcolor(lightgray);
	                    outtextxy(10,420,'  Sorry, but you don''t have room in your pack!');
	                    prompt;
	                    exit;
	               end;
	          if (price>player.coins) then
	               begin
	                    setcolor(brown);
	                    broke;
	                    exit;
	               end;
	          player.numitems:=player.numitems+1;
	          player.item[player.numitems]:=theitem;
	          player.coins:=player.coins-price;
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'Sold!');
	          prompt;
	     end;
end;
{---------------------------------------------------------------------------}
procedure esi_arm(var player:character_t);

var
	opponent       :    byte;
	tempstring     :    string;
	bet            :    word;
	errcode        :    integer;
	win            :    boolean;
	done           :    boolean;
	position       :    shortint;
	ans            :    char;
	ch             :    char;


begin
	setcolor(lightgreen);
	writefile(175,textdir+'064.txt');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['y','Y']) then
	     begin
	          clearesi;
	          y:=175;
	          setcolor(lightgreen);
	          graphwrite(x,y,'Place your wager (up to 100 coins): ');
	          graphread(x,y,tempstring);
	          val(tempstring,bet,errcode);
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          if (bet<1) then
	               begin
	                    graphwriteln(x,y,'What''s the point of playing for nothing?');
	                    prompt;
	                    exit;
	               end;
	          if (bet>100) then
	               begin
	                    graphwriteln(x,y,'''''Too high for my taste.''''');
	                    prompt;
	                    exit;
	               end;
	          if (player.coins<bet) then
	               begin
	                    graphwriteln(x,y,'You secretly bet money you don''t have.');
	                    prompt;
	               end;
	          clearesi;
	          x:=10;
	          y:=175;
	          setcolor(lightgreen);
	          graphwriteln(x,y,'Ready.  Set.  Go!  (press space)');
	          done:=false;
	          position:=0;
	          opponent:=roll('1d6')+12;
	          repeat
	               repeat
	                    ch:=readarrowkey;
	               until (ch=' ');
	               case position of
	                   -1:begin
	                           if ((roll('1d20')+player.strength-10)>(roll('1d20')+opponent)) then
	                                position:=0
	                           else
	                                position:=-2;
	                      end;
	                    0:begin
	                           if ((roll('1d20')+player.strength)>(roll('1d20')+opponent)) then
	                                position:=1
	                           else
	                                position:=-1;
	                      end;
	                    1:begin
	                           if ((roll('1d20')+player.strength+10)>(roll('1d20')+opponent)) then
	                                position:=2
	                           else
	                                position:=0;
	                      end;
	               end;{case}
	               clearesi;
	               y:=175;
	               case position of
	                   -2:begin
	                           graphwriteln(x,y,'You have lost!');
	                           done:=true;
	                           win:=false;
	                      end;
	                   -1:begin
	                           graphwriteln(x,y,'You are losing...  (press space)');
	                      end;
	                    0:begin
	                           graphwriteln(x,y,'You both continue to struggle.  (press space)');
	                      end;
	                    1:begin
	                           graphwriteln(x,y,'You are winning...  (press space)');
	                      end;
	                    2:begin
	                           graphwriteln(x,y,'You defeat the wimp.');
	                           done:=true;
	                           win:=true;
	                      end;
	               end;{case}
	          until (done);
	          graphwriteln(x,y,'');
	          if (win) then
	               begin
	                    graphwriteln(x,y,'The wimp hands you your money.');
	                    player.coins:=player.coins+bet;
	               end
	          else
	               begin
	                    graphwriteln(x,y,'It''s time for you to pay up.');
	                    graphwriteln(x,y,'');
	                    if (bet>player.coins) then
	                         begin
	                              graphwriteln(x,y,'''''We don''t like people who bet with no money!''''');
	                              graphwriteln(x,y,'They attack.');
	                              prompt;
	                              nummonsters:=roll('1d4')+2;
	                              rollmonsters(monster,nummonsters,'brawler.dat');
	                              combat(player,nummonsters,monster);
	                              cleardevice;
	                              if GAMEOVER then exit;
                                      drawpic(70,10,'esi.ln1');
	                              setfont('default.ttf',6);
	                              x:=10;
	                              y:=175;
	                              setcolor(lightgreen);
	                              graphwriteln(x,y,'After the fight you go back to the bar.');
	                         end
	                    else
	                         begin
	                              graphwriteln(x,y,'''''Thanks,'''' he laughs.  ''''Come back any time.''''');
	                              player.coins:=player.coins-bet;
	                         end;
	               end;
	          prompt;
	     end;
end;
{---------------------------------------------------------------------------}
procedure esi_knife(var player:character_t);

var
	opponent       :    byte;
	tempstring     :    string;
	bet            :    word;
	errcode        :    integer;
	win            :    boolean;
	score          :    array[1..2] of byte;
	loop           :    integer;
	ans            :    char;
	ch             :    char;

begin
	setcolor(lightgray);
	writefile(175,textdir+'065.txt');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['y','Y']) then
	     begin
	          clearesi;
	          y:=175;
	          setcolor(lightgray);
	          graphwrite(x,y,'Place your wager (up to 100 coins): ');
	          graphread(x,y,tempstring);
	          val(tempstring,bet,errcode);
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          if (bet<1) then
	               begin
	                    graphwriteln(x,y,'What''s the point of playing for nothing?');
	                    prompt;
	                    exit;
	               end;
	          if (bet>100) then
	               begin
	                    graphwriteln(x,y,'''''Ahem.  I don''t carry that much money.''''');
	                    prompt;
	                    exit;
	               end;
	          if (player.coins<bet) then
	               begin
	                    graphwriteln(x,y,'You secretly bet money you don''t have.');
	                    prompt;
	               end;
	          clearesi;
	          x:=10;
	          y:=175;
	          setcolor(lightgray);
	          score[1]:=0;
	          score[2]:=0;
	          opponent:=roll('1d6')+12;
	          for loop:=1 to 3 do
	               begin
	                    clearesi;
	                    x:=10;
	                    y:=175;
	                    setcolor(lightgray);
	                    case loop of
	                         1:graphwriteln(x,y,'First throw.');
	                         2:graphwriteln(x,y,'Second throw.');
	                         3:graphwriteln(x,y,'Third throw.');
	                    end;
	                    graphwriteln(x,y,'');
	                    graphwrite(x,y,'He throws...  ');
	                    setcolor(lightred);
	                    case (roll('1d20')+opponent) of
	                       38..40:begin
	                                   graphwriteln(x,y,'BULLSEYE! (20 pts)');
	                                   score[1]:=score[1] + 20;
	                              end;
	                       30..37:begin
	                                   graphwriteln(x,y,'good shot. (10 pts)');
	                                   score[1]:=score[1] + 10;
	                              end;
	                       20..29:begin
	                                   graphwriteln(x,y,'decent shot. (5 pts)');
	                                   score[1]:=score[1] + 5;
	                              end;
	                       10..19:begin
	                                   graphwriteln(x,y,'barely hit the board. (3 pts)');
	                                   score[1]:=score[1] + 3;
	                              end;
	                       else
	                              begin
	                                   graphwriteln(x,y,'missed the board completely. (0 pts)');
	                                   score[1]:=score[1] + 0;
	                              end;
	                    end;{case}
	                    setcolor(lightgray);
	                    graphwriteln(x,y,'');
	                    graphwrite(x,y,'You throw... (press space)  ');
	                    repeat
	                         ch:=readarrowkey;
	                    until (ch=' ');
	                    setcolor(lightred);
	                    case (roll('1d20')+player.dexterity) of
	                       38..40:begin
	                                   graphwriteln(x,y,'BULLSEYE! (20 pts)');
	                                   score[2]:=score[2] + 20;
	                              end;
	                       30..37:begin
	                                   graphwriteln(x,y,'they are impressed. (10 pts)');
	                                   score[2]:=score[2] + 10;
	                              end;
	                       20..29:begin
	                                   graphwriteln(x,y,'you''re not too quick... (5 pts)');
	                                   score[2]:=score[2] + 5;
	                              end;
	                       10..19:begin
	                                   graphwriteln(x,y,'barely hit the board. (3 pts)');
	                                   score[2]:=score[2] + 3;
	                              end;
	                       else
	                              begin
	                                   graphwriteln(x,y,'they all laugh at you. (0 pts)');
	                                   score[2]:=score[2] + 0;
	                              end;
	                    end;{case}
	                    setcolor(lightgray);
	                    prompt;
	               end;
	          clearesi;
	          x:=10;
	          y:=175;
	          setcolor(lightgray);
	          win:=(score[1]<score[2]);
	          graphwriteln(x,y,'');
	          if (win) then
	               begin
	                    graphwriteln(x,y,'He shamefully hands you the money.');
	                    player.coins:=player.coins+bet;
	               end
	          else
	               begin
	                    graphwriteln(x,y,'The winner looks at you expectantly.');
	                    graphwriteln(x,y,'');
	                    if (bet>player.coins) then
	                         begin
	                              graphwriteln(x,y,'''''Don''t have the money?!''''');
	                              graphwriteln(x,y,'They attack.');
	                              prompt;
	                              nummonsters:=roll('1d6')+2;
	                              rollmonsters(monster,nummonsters,'bandit.dat');
	                              combat(player,nummonsters,monster);
	                              cleardevice;
                                      drawpic(70,10,'esi.ln1');
	                              setfont('default.ttf',6);
	                              x:=10;
	                              y:=175;
	                              setcolor(lightgray);
	                              graphwriteln(x,y,'After the fight you go back to the bar.');
	                         end
	                    else
	                         begin
	                              graphwriteln(x,y,'''''Pleasure doing business with you.''''');
	                              player.coins:=player.coins-bet;
	                         end;
	               end;
	          prompt;
	     end;

end;
{---------------------------------------------------------------------------}
procedure esi_wheel(var player:character_t);

const
	delayvalue     =    1000;

var
	password       :    string;
	done           :    boolean;
	ans            :    char;
	ch             :    char;

begin
	x:=10;
	y:=175;
	setcolor(red);
	graphwriteln(x,y,'You walk over to one of Roland''s Roving Jesters who is clad in');
	graphwriteln(x,y,'red and yellow.  He guardes a barred door.');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'''''What do you want?'''' he asks.');
	graphwriteln(x,y,'');
	graphwrite(x,y,'You say:  ');
	graphread(x,y,password);
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	if not(capitalize(password)='CRYSTAL SHARD') then
	     begin
	          setcolor(yellow);
	          graphwriteln(x,y,'''''Bobo warned me about you.  I can''t let you in.''''');
	          prompt;
	     end
	else
	     begin
	          setcolor(yellow);
	          graphwriteln(x,y,'He opens the door for you...');
	          prompt;
	          done:=false;
	          repeat
	               clearesi;
	               x:=10;
	               y:=175;
	               setcolor(red);
	               setfont('default.ttf',6);
	               graphwriteln(x,y,'Welcome to Roland McDoland''s');
	               graphwriteln(x,y,'    Wheel of Fortune!');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'For ONLY 500 coins you can spin');
	               graphwriteln(x,y,'the wheel of fortune!');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'Do you want to spin?  (y/n)');
                       drawpic(350,175,'wheel.ln1');
	               repeat
	                    ans:=readarrowkey;
	               until (ans in ['y','Y','n','N']);
	               done:=(ans in ['n','N']);
	               if (ans in ['y','Y']) then
	                    begin
	                         if (player.coins<500) then
	                              begin
	                                   setcolor(yellow);
	                                   broke;
	                                   exit;
	                              end;
	                         player.coins:=player.coins - 500;
	                         setcolor(yellow);
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'You spin the wheel...');
	                         prompt;
	                         clearesi;
	                         x:=15;
	                         y:=300;
	                         setcolor(red);
	                         graphwriteln(x,y,'                 press space to stop the wheel');
	                         x:=165;
	                         y:=180;
	                         repeat
	                              repeat
                                           drawpic(x,y,'wheel1.ln1');
	                                   delay(delayvalue);
                                           drawpic(x,y,'wheel2.ln1');
	                                   delay(delayvalue);
                                           drawpic(x,y,'wheel3.ln1');
	                                   delay(delayvalue);
                                           drawpic(x,y,'wheel4.ln1');
	                                   delay(delayvalue);
	                              until KEYPRESSED;
	                              ch:=readarrowkey;
	                         until (ch=' ');
	                         y:=350;
	                         setfont('default.ttf',1);
	                         setcolor(white);
	                         case (roll('4d8')) of
	                            4:begin
	                                   writefile(350,textdir+'066.txt');
                                           drawpic(165,180,'wheel1.ln1');
                                           drawpic(300,220,'wheart.ln1');
	                                   player.endurancemax:=player.endurancemax+100;
	                                   player.endurance:=player.endurance+100;
	                              end;
	                           32:begin
	                                   writefile(350,textdir+'067.txt');
                                           drawpic(165,180,'wheel3.ln1');
                                           drawpic(300,220,'bskull.ln1');
	                                   prompt;
	                                   died;
	                                   exit;
	                              end;
	                         else
	                              case roll('1d8') of
	                                 1:begin
	                                        writefile(350,textdir+'068.txt');
                                                drawpic(165,180,'wheel3.ln1');
                                                drawpic(300,220,'moon.ln1');
	                                        if (player.coins>1000) then
	                                             player.coins:=player.coins - 1000
	                                        else
	                                             player.coins:=0;
	                                        if (player.experience>1000) then
	                                             player.experience:=player.experience - 1000
	                                        else
	                                             player.experience:=0;
	                                   end;
	                                 2:begin
	                                        writefile(350,textdir+'069.txt');
                                                drawpic(165,180,'wheel1.ln1');
                                                drawpic(300,220,'candle.ln1');
	                                        if (player.strength<20) then
	                                             player.strength:=player.strength + 1;
	                                   end;
	                                 3:begin
	                                        writefile(350,textdir+'070.txt');
                                                drawpic(165,180,'wheel3.ln1');
                                                drawpic(300,220,'lit.ln1');
	                                        if (player.dexterity>1) then
	                                             player.dexterity:=player.dexterity - 1;
	                                   end;
	                                 4:begin
	                                        writefile(350,textdir+'071.txt');
                                                drawpic(165,180,'wheel1.ln1');
                                                drawpic(300,220,'heart.ln1');
	                                        player.endurancemax:=player.endurancemax+1;
	                                        player.endurance:=player.endurance+1;
	                                   end;
	                                 5:begin
	                                        writefile(350,textdir+'072.txt');
                                                drawpic(165,180,'wheel3.ln1');
                                                drawpic(300,220,'skull.ln1');
	                                        if (player.endurancemax>1) then
	                                             player.endurancemax:=player.endurancemax - 1;
	                                        if (player.endurance>1) then
	                                             player.endurance:=player.endurance - 1;
	                                   end;
	                                 6:begin
	                                        writefile(350,textdir+'073.txt');
                                                drawpic(165,180,'wheel1.ln1');
                                                drawpic(300,220,'water.ln1');
	                                        if (player.dexterity<20) then
	                                             player.dexterity:=player.dexterity + 1;
	                                   end;
	                                 7:begin
	                                        writefile(350,textdir+'074.txt');
                                                drawpic(165,180,'wheel3.ln1');
                                                drawpic(300,220,'eye.ln1');
	                                        if (player.strength>1) then
	                                             player.strength:=player.strength - 1;
	                                   end;
	                                 8:begin
	                                        writefile(350,textdir+'075.txt');
                                                drawpic(165,180,'wheel1.ln1');
                                                drawpic(300,220,'sun.ln1');
	                                        player.coins:=player.coins + 1000;
	                                        player.experience:=player.experience + 1000;
	                                   end;
	                              end;{case}
	                         end;{case}
	                         prompt;
	                    end;
	          until (done);
	     end;
end;
{---------------------------------------------------------------------------}
procedure elfskullinn(var player:character_t);

var
	tempstring  :    string;
	ans         :    char;

begin
	cleardevice;
        drawpic(70,10,'esi.ln1');
	setcolor(yellow);
	setfont('default.ttf',5);
	writefile(180,textdir+'039.txt');
	prompt;
	repeat
	     clearesi;
	     homecursor(x,y);
	     y:=240;
	     setcolor(yellow);
	     setfont('default.ttf',6);
	     graphwriteln(x,y,'     1) Look around');
	     graphwriteln(x,y,'     2) Order a drink');
	     graphwriteln(x,y,'     3) Rent a room');
	     graphwriteln(x,y,'     4) Try your luck at dice');
	     y:=240;
	     x:=320;
	     graphwriteln(x,y,'     5) Visit the Magic Merchant');
	     x:=320;
	     graphwriteln(x,y,'     6) Arm wrestling table');
	     x:=320;
	     graphwriteln(x,y,'     7) Knife throwing board');
	     x:=320;
	     graphwriteln(x,y,'     8) Go over to the jester');
	     graphwriteln(x,y,'');
	     graphwriteln(x,y,'                       (V)iew your stats');
	     graphwriteln(x,y,'                    (E)xit the Elf Skull Inn');
	     str(player.coins,tempstring);
	     setfont('default.ttf',1);
	     setcolor(white);
	     outtextxy(240,460,('You have ' + tempstring + ' coins'));
	     repeat
	          ans:=readarrowkey;
	     until (ans in ['1'..'8','e','E','v','V']);
	     clearesi;
	     setcolor(yellow);
	     setfont('default.ttf',6);
	     homecursor(x,y);
	     case ans of
	       'e','E':exit;
	       'v','V':begin
	                    viewstats(player);
	                    cleardevice;
                            drawpic(70,10,'esi.ln1');
	               end;
	           '1':begin
	                    setcolor(yellow);
	                    setfont('default.ttf',5);
	                    writefile(180,textdir+'039.txt');
	                    prompt;
	               end;
	           '2':begin
	                    esi_drink(player);
	               end;
	           '3':begin
	                    esi_room(player);
	               end;
	           '4':begin
	                    esi_dice(player);
	               end;
	           '5':begin
	                    esi_magic(player);
	               end;
	           '6':begin
	                    esi_arm(player);
	               end;
	           '7':begin
	                    esi_knife(player);
	               end;
	           '8':begin
	                    esi_wheel(player);
	               end;
	     end;{case}
	     if GAMEOVER then exit;
	until FALSE;
end;


{---------------------------------------------------------------------------}
procedure encounter(chartfile:string);

var
	monsterchart   :    chartrecord;
	pasfile        :    file of chartrecord;
	theroll        :    integer;
	count          :    integer;
	val1           :    integer;
	val2           :    integer;
	monsterfile    :    string;
	monmax         :    integer;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'           You encounter');
	message(x,y,'');
	message(x,y,'             MONSTERS!');
	prompt;
	if not(exist(chartdir+chartfile)) then
	     exit;
	assign(pasfile,chartdir+chartfile);
	reset(pasfile);
	read(pasfile,monsterchart);
	close(pasfile);

	with monsterchart do
	     begin
	          theroll:=roll(diceroll);
	          monmax:=rollmax(diceroll);
	          for count:=1 to monmax do
	               begin
	                    val1:=value[count,1];
	                    val2:=value[count,2];
	                    if (theroll in [val1..val2]) then
	                         begin
	                              monsterfile:=filename[count];
	                              nummonsters:=roll(number[count]);
	                              if (nummonsters>monstermax) then
	                                   nummonsters:=monstermax;
	                              if (nummonsters<1) then
	                                   nummonsters:=1;
	                         end;
	               end;
	     end;

	rollmonsters(monster,nummonsters,monsterfile);
	combat(player,nummonsters,monster);

end;

{Dungeon/Cave/Castle Engine}
{---------------------------------------------------------------------------}
procedure dungeonoptions;

var ans:char;


begin
	cleardevice;
	setcolor(magenta);
	setfont('default.ttf',3);
	x:=10;
	y:=100;
	graphwriteln(x,y,'    Dungeon Options');
	graphwriteln(x,y,'');
	setfont('default.ttf',2);
	graphwriteln(x,y,'');
	setcolor(lightmagenta);
	graphwrite(x,y,'            V');
	setcolor(magenta);
	graphwriteln(x,y,'iew Stats');
	graphwriteln(x,y,'');
	setcolor(lightmagenta);
	graphwrite(x,y,'            U');
	setcolor(magenta);
	graphwriteln(x,y,'se Item');
	graphwriteln(x,y,'');
	setcolor(lightmagenta);
	graphwrite(x,y,'            C');
	setcolor(magenta);
	graphwriteln(x,y,'ast Spell');
	graphwriteln(x,y,'');
	setcolor(lightmagenta);
	graphwrite(x,y,'            Q');
	setcolor(magenta);
	graphwriteln(x,y,'uit Game');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	setcolor(lightmagenta);
	graphwrite(x,y,'  ** ');
	setcolor(magenta);
	graphwrite(x,y,'any other key--Back to Game');
	setcolor(lightmagenta);
	graphwriteln(x,y,' **');
	ans:=readarrowkey;
	case ans of
	 'v','V':begin
	              calcstats(player);
	              viewstats(player);
	         end;
	 'u','U':useitem(player);
	 'c','C':castspell(player,dungeon);
	 'q','Q':GAMEOVER:=TRUE;
	end;{case}
end;
{---------------------------------------------------------------------------}
procedure cave_locked(var player:character_t;var px,py:integer;lastx,lasty:integer);

var
	ans  :    char;
	done :    boolean;
	loop :    integer;
	ch   :    char;
	errcode:  integer;
	tempstring:string;

begin
	done:=false;
	if not(unlocked in player.stages) then
	     repeat
	          cleardevice;
                  drawpic(10,10,'ldoor.ln1');
	          setcolor(lightmagenta);
	          x:=10;
	          y:=300;
	          setfont('sanseri.ttf',2);
	          graphwriteln(x,y,'You come across a locked door.');
	          graphwriteln(x,y,'(A)ttack it');
	          graphwriteln(x,y,'(U)se an item');
	          graphwriteln(x,y,'(C)ast a spell');
	          graphwriteln(x,y,'Use a (k)ey');
	          graphwriteln(x,y,'(L)eave');
	          repeat
	               ans:=readarrowkey;
	          until (ans in ['a','A','u','U','c','C','k','K','l','L']);
	          done:=ans in ['l','L'];
	          cleardevice;
	          homecursor(x,y);
	          case ans of
	            'a','A':begin
	                         graphwriteln(x,y,'You attack the door, but it doesn''t budge...');
	                         prompt;
	                    end;
	            'u','U':begin
	                         graphwriteln(x,y,'Use which item?');
	                         with player do
	                              for loop:=1 to numitems do
	                                   begin
	                                        str(loop,tempstring);
	                                        ch:=tempstring[1];
	                                        tempstring:='      ';
	                                        tempstring:=tempstring + ch + '. ';
	                                        tempstring:=tempstring + itemstring(item[loop]);
	                                        graphwriteln(x,y,tempstring);
	                                   end;
	                         graphwriteln(x,y,'     (N)evermind');
	                         repeat
	                              ans:=readarrowkey;
	                         until (ans in ['1'..ch,'n','N']);
	                         graphwriteln(x,y,'');
	                         graphwrite(x,y,'You point the ');
	                         tempstring:=ans;
	                         val(tempstring,loop,errcode);
	                         tempstring:=itemstring(player.item[loop]);
	                         graphwrite(x,y,tempstring);
	                         graphwriteln(x,y,' at the door.');
	                         graphwriteln(x,y,'It does nothing.');
	                         prompt;
	                    end;
	            'c','C':if (player.charges>0) then
	                      begin
	                         graphwriteln(x,y,'Cast which spell?');
	                         with player do
	                              for loop:=1 to numspells do
	                                   begin
	                                        str(loop,tempstring);
	                                        ch:=tempstring[1];
	                                        tempstring:='      ';
	                                        tempstring:=tempstring + ch + '. ';
	                                        tempstring:=tempstring + spellstring(spell[loop]);
	                                        graphwriteln(x,y,tempstring);
	                                   end;
	                         graphwriteln(x,y,'     (N)evermind');
	                         repeat
	                              ans:=readarrowkey;
	                         until (ans in ['1'..ch,'n','N']);
	                         tempstring:=ans;
	                         val(tempstring,loop,errcode);
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'');
	                         if not(player.spell[loop] in [obliterate,shatter]) then
	                              begin
	                                   graphwrite(x,y,'You cast ');
	                                   tempstring:=spellstring(player.spell[loop]);
	                                   graphwriteln(x,y,tempstring);
	                                   graphwriteln(x,y,'It does nothing useful.');
	                              end
	                         else
	                              if (player.spell[loop]=shatter) then
	                                   begin
	                                        graphwriteln(x,y,'You freeze the lock, making it brittle.');
	                                        graphwriteln(x,y,'');
	                                        graphwriteln(x,y,'With one swift blow, you break off the lock.');
	                                        player.stages:=player.stages + [unlocked];
	                                        done:=true;
	                                   end
	                              else
	                                   begin
	                                        graphwriteln(x,y,'You obliterate the door.');
	                                        player.stages:=player.stages + [unlocked];
	                                        done:=true;
	                                   end;
	                         if not(ans in ['n','N']) then
	                              player.charges:=player.charges-1;
	                         prompt;
	                      end
	                    else
	                      begin
	                           graphwriteln(x,y,'You have not more charges in your ring.');
	                           prompt;
	                      end;
	            'k','K':if (key in player.stages) then
	                         begin
	                              graphwriteln(x,y,'The key doesn''t work.');
	                              prompt;
	                         end
	                    else
	                         begin
	                              graphwriteln(x,y,'You don''t have any keys.');
	                              prompt;
	                         end;
	          end;{case}
	          cleardevice;
	     until (done);
	if not(unlocked in player.stages) then
	     begin
	          px:=lastx;
	          py:=lasty;
	     end;
	screensetup;
end;
{---------------------------------------------------------------------------}
procedure cave_staircase;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'    You are on a staircase that');
	message(x,y,'      descends to the north.');
end;
{---------------------------------------------------------------------------}
procedure secret_passage;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,'   You are in a secret passage.');
end;
{---------------------------------------------------------------------------}
procedure castle_courtyard;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,' You are in the castle courtyard.');
end;
{---------------------------------------------------------------------------}
procedure castle_guest;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,' This appears to be a guest room.');
end;
{---------------------------------------------------------------------------}
procedure castle_banquet;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,'   This is a vast banquet hall.');
end;
{---------------------------------------------------------------------------}
procedure castle_master;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,'       The Queen''s bedroom.');
end;
{---------------------------------------------------------------------------}
procedure castle_kitchen;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,'        An empty kitchen.');
end;
{---------------------------------------------------------------------------}
procedure cave_key(var player:character_t);

var ans:char;

begin
	if not(key in player.stages) then
	     begin
	          clearmessage;
	          homemessage(x,y);
	          setfont('default.ttf',2);
	          setcolor(black);
	          message(x,y,'          You find a key.');
	          message(x,y,'');
	          message(x,y,'          Take it? (y/n)');
	          repeat
	               ans:=readarrowkey;
	          until (ans in ['y','Y','n','N']);
	          if (ans in ['Y','y']) then
	               player.stages:=player.stages + [key];
	          clearmessage;
	     end;
end;
{---------------------------------------------------------------------------}
procedure dungeon_treasure(var player:character_t);

var ans:char;

begin
	if not(treasure in player.stages) then
	     begin
	          clearmessage;
	          homemessage(x,y);
	          setfont('default.ttf',2);
	          setcolor(black);
	          message(x,y,'     You find some treasure.');
	          message(x,y,'');
	          message(x,y,'          Take it? (y/n)');
	          repeat
	               ans:=readarrowkey;
	          until (ans in ['y','Y','n','N']);
	          if (ans in ['Y','y']) then
	               begin
	                    player.stages:=player.stages + [treasure];
	                    player.coins:=player.coins + 1000 + roll('1d1000');
	               end;
	          clearmessage;
	     end;
end;
{---------------------------------------------------------------------------}
procedure dungeon_trap(var player:character_t);

var
	tempstring     :    string;
	dmg            :    byte;

begin
	tempstring:='';
	case roll('1d6') of
	   1:tempstring:='an explosion trap.';
	   2:tempstring:='a falling block trap.';
	   3:tempstring:='a gas trap.';
	   4:tempstring:='an arrow trap.';
	   5:tempstring:='an axe trap.';
	   6:tempstring:='a pit trap.';
	end;
	dmg:=roll('2d6');
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	if (roll('1d20')>player.savingthrow) then
	     begin
	          message(x,y,'');
	          message(x,y,'You are able to avoid');
	          message(x,y,tempstring);
	     end
	else
	     begin
	          message(x,y,'');
	          message(x,y,'You take damage from');
	          message(x,y,tempstring);
	          if (dmg>=player.endurance) then
	               begin
	                    prompt;
	                    message(x,y,'You die...');
	                    died;
	               end
	          else
	               player.endurance:=player.endurance-dmg;
	     end;
	prompt;
	screensetup;
end;
{---------------------------------------------------------------------------}
procedure cave_library;

var ans:char;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'You find a massive book on a podium.');
	message(x,y,'');
	message(x,y,' Do you want to look at it? (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['Y','y']) then
	     begin
	          cleardevice;
	          setcolor(magenta);
	          setfont('sanseri.ttf',2);
	          writefile(1,textdir+'076.txt');
	          prompt;
	          died;
	     end;
	clearmessage;
end;
{---------------------------------------------------------------------------}
procedure cave_sword(var player:character_t);

var ch:char;

begin
	cleardevice;
	setcolor(brown);
	setfont('triplex.ttf',3);
	homecursor(x,y);
	if not(msword in player.stages) then
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'A large bat-winged creature with the body of a lion');
	          graphwriteln(x,y,'and the head of a man guards a sword here.  It sees');
	          graphwriteln(x,y,'you and attacks!');
                  drawpic(200,200,'manticor.ln1');
	          prompt;
	          nummonsters:=1;
	          rollmonsters(monster,nummonsters,'manticor.dat');
	          combat(player,nummonsters,monster);
	          if (nummonsters=0) then
	               begin
	                    player.stages:=player.stages + [msword];
	                    cleardevice;
	                    setcolor(lightblue);
	                    setfont('triplex.ttf',3);
	                    homecursor(x,y);
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'CONGRATULATIONS!');
	                    graphwriteln(x,y,'You find a magic sword.');
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'');
                            drawpic(x,y,'magicswd.ln1');
	                    if (player.numitems<itemmax) then
	                          begin
	                               player.numitems:=player.numitems + 1;
	                               player.item[player.numitems]:=magicsword;
	                               setcolor(lightblue);
	                               graphwriteln(x,y,'     You pick up the magic sword.');
	                               prompt;
	                          end
	                    else
	                          begin
	                               setcolor(lightblue);
	                               graphwriteln(x,y,'     You are carrying too many items.');
	                               graphwriteln(x,y,'     Do you want to drop one? (y/n)');
	                               repeat
	                                    ch:=readarrowkey;
	                               until(ch in ['n','N','y','Y']);
	                               if (ch in ['y','Y']) then
	                                    begin
	                                         dropitem(player);
	                                         player.numitems:=player.numitems+1;
	                                         player.item[player.numitems]:=magicsword;
	                                    end
	                               else
	                                    begin
	                                         graphwriteln(x,y,'');
	                                         graphwriteln(x,y,'     You leave the sword here.');
	                                         prompt;
	                                    end;
	                           end;
	                    end
	          end
	     else
	          begin
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'There is a manticore carcass here, being eaten by');
	               graphwriteln(x,y,'ants.');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'There doesn''t seem to be anything of interest here.');
	               prompt;
	          end;
	screensetup;
end;
{---------------------------------------------------------------------------}
procedure cave_shield(var player:character_t);

var ch:char;

begin
	cleardevice;
	setcolor(darkgray);
	setfont('triplex.ttf',3);
	homecursor(x,y);
	if not(mshield in player.stages) then
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'A dark, panther-like creature with tentacles looks');
	          graphwriteln(x,y,'at you.  It seems to fade in and out of existence.');
	          graphwriteln(x,y,'It decides it''s hungry and attacks!');
                  drawpic(200,200,'displace.ln1');
	          prompt;
	          nummonsters:=1;
	          rollmonsters(monster,nummonsters,'displace.dat');
	          combat(player,nummonsters,monster);
	          if (nummonsters=0) then
	               begin
	                    player.stages:=player.stages + [mshield];
	                    cleardevice;
	                    setcolor(lightblue);
	                    setfont('triplex.ttf',3);
	                    homecursor(x,y);
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'CONGRATULATIONS!');
	                    graphwriteln(x,y,'You find a magic shield.');
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'');
                            drawpic(x,y,'magicshl.ln1');
	                    if (player.numitems<itemmax) then
	                          begin
	                               player.numitems:=player.numitems + 1;
	                               player.item[player.numitems]:=magicshield;
	                               setcolor(lightblue);
	                               graphwriteln(x,y,'     You pick up the magic shield.');
	                               prompt;
	                          end
	                    else
	                          begin
	                               setcolor(lightblue);
	                               graphwriteln(x,y,'     You are carrying too many items.');
	                               graphwriteln(x,y,'     Do you want to drop one? (y/n)');
	                               repeat
	                                    ch:=readarrowkey;
	                               until(ch in ['n','N','y','Y']);
	                               if (ch in ['y','Y']) then
	                                    begin
	                                        dropitem(player);
	                                         player.numitems:=player.numitems+1;
	                                         player.item[player.numitems]:=magicshield;
	                                    end
	                               else
	                                    begin
	                                         graphwriteln(x,y,'');
	                                         graphwriteln(x,y,'     You leave the shield here.');
	                                         prompt;
	                                    end;
	                           end;
	                    end
	          end
	     else
	          begin
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'There is a bad smell...');
	               graphwriteln(x,y,'');
	               graphwriteln(x,y,'There doesn''t seem to be anything of interest here.');
	               prompt;
	          end;
	screensetup;
end;
{---------------------------------------------------------------------------}
procedure dungeon_lizard(var player:character_t;var px,py:integer;lastx,lasty:integer);

begin
	cleardevice;
	setcolor(lightblue);
	setfont('triplex.ttf',3);
	homecursor(x,y);
	if not(lizard in player.stages) then
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'This is the home of a large lizard with six legs.');
	          graphwriteln(x,y,'It rears up to atack you!');
                  drawpic(200,200,'salamand.ln1');
	          prompt;
	          nummonsters:=1;
	          rollmonsters(monster,nummonsters,'salamand.dat');
	          combat(player,nummonsters,monster);
	          if (nummonsters=0) then
	               player.stages:=player.stages + [lizard]
	          else
	               begin
	                    px:=lastx;
	                    py:=lasty;
	               end;
	     end;
	screensetup;
end;
{---------------------------------------------------------------------------}
procedure castle_barracks;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,'You find yourself in the barracks.');
	message(x,y,'    The soldiers here attack!');
	prompt;
	encounter(castlechart);
	screensetup;
end;
{---------------------------------------------------------------------------}
procedure castle_knight(var player:character_t;var px,py:integer;lastx,lasty:integer);

begin
	cleardevice;
	setcolor(cyan);
	setfont('triplex.ttf',3);
	homecursor(x,y);
	if not(knight in player.stages) then
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'Lorn Paradox, the Ice Queen''s knight lives here,');
	          graphwriteln(x,y,'and he just happens to be at home.  He attacks!');
                  drawpic(200,200,'knight.ln1');
	          prompt;
	          nummonsters:=1;
	          rollmonsters(monster,nummonsters,'knight.dat');
	          combat(player,nummonsters,monster);
	          if (nummonsters=0) then
	               player.stages:=player.stages + [knight]
	          else
	               begin
	                    px:=lastx;
	                    py:=lasty;
	               end;
	     end;
	screensetup;
end;
{---------------------------------------------------------------------------}
procedure castle_throne(var player:character_t;var px,py:integer;lastx,lasty:integer);

begin
	cleardevice;
	setcolor(blue);
	setfont('triplex.ttf',3);
	homecursor(x,y);
	if not(iceq in player.stages) then
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'You have entered the throne room of the Ice Queen');
	          graphwriteln(x,y,'herself!  And here she is.');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'She eyes you suspiciously, "I knew you''d get here');
	          graphwriteln(x,y,'eventually.  You have forced me to kill you..."');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'She begins conjuring strong magic and attacks!');
                  drawpic(210,300,'icequeen.ln1');
	          prompt;
	          nummonsters:=1;
	          rollmonsters(monster,nummonsters,'icequeen.dat');
	          monster[1].endurance:=40;
	          combat(player,nummonsters,monster);
	          if (nummonsters=0) then
	               begin
	                    player.stages:=player.stages + [iceq];
	                    cleardevice;
	                    setcolor(yellow);
	                    setfont('triplex.ttf',3);
	                    writefile(1,textdir+'080.txt');
	                    prompt;
	               end
	          else
	               begin
	                    px:=lastx;
	                    py:=lasty;
	               end;
	     end
	else
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'There is a headless Ice Queen in the throne room.');
	          prompt;
	     end;
	screensetup;
end;
{---------------------------------------------------------------------------}
procedure stair_up;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,'  There are stairs going up here.');
	prompt;
end;
{---------------------------------------------------------------------------}
procedure dungeon_engine(var player:character_t;themap:string;
	                    thecode:string;monsterchart:string;px,py:integer);

var
	dmap           :    matrix;
	dcode          :    matrix;
	lastx          :    integer;
	lasty          :    integer;
	pasfile        :    file of matrix;
	exitx          :    integer;
	exity          :    integer;
	exitdungeon    :    boolean;
	ans            :    char;

begin
	exitx:=px;
	exity:=py;
	assign(pasfile,mapdir+themap);
	reset(pasfile);
	read(pasfile,dmap);
	close(pasfile);
	assign(pasfile,mapdir+thecode);
	reset(pasfile);
	read(pasfile,dcode);
	close(pasfile);
	exitdungeon:=false;
	screensetup;
	writestats(player);
	repeat
	     drawmaptile(px,py,dmap);
	     if (px>1)and(dmap[px-1,py]<>28) then
	          drawmaptile(px-1,py,dmap);
	     if (px<20)and(dmap[px+1,py]<>28) then
	          drawmaptile(px+1,py,dmap);
	     if (py>1)and(dmap[px,py-1]<>28) then
	          drawmaptile(px,py-1,dmap);
	     if (py<14)and(dmap[px,py+1]<>28) then
	          drawmaptile(px,py+1,dmap);
	     if (px>1)and(py>1)and(dmap[px-1,py-1]<>28) then
	          drawmaptile(px-1,py-1,dmap);
	     if (px<20)and(py<14)and(dmap[px+1,py+1]<>28) then
	          drawmaptile(px+1,py+1,dmap);
	     if (px>1)and(py<14)and(dmap[px-1,py+1]<>28) then
	          drawmaptile(px-1,py+1,dmap);
	     if (px<20)and(py>1)and(dmap[px+1,py-1]<>28) then
	          drawmaptile(px+1,py-1,dmap);
	     setcolor(red);
	     setfillstyle(solidfill,red);
	     fillellipse((px*20)+31,(py*20)+31,3,3);
	     lastx:=px;
	     lasty:=py;
	     writestats(player);
	     repeat
	          ans:=readarrowkey;

	     until (ans in ['2','4','6','8',' ']);
	     clearmessage;
	     if (dcode[px,py]=28) then
	          begin
	               setcolor(blue);
	               setfillstyle(solidfill,blue);
	               fillellipse((px*20)+31,(py*20)+31,3,3);
	          end;
	     if (ans='2')and(py<14)and(dcode[px,py+1]<>1) then
	          py:=py + 1;
	     if (ans='8')and(py>1)and(dcode[px,py-1]<>1) then
	          py:=py - 1;
	     if (ans='6')and(px<20)and(dcode[px+1,py]<>1) then
	          px:=px + 1;
	     if (ans='4')and(px>1)and(dcode[px-1,py]<>1) then
	          px:=px - 1;
	     if (ans=' ') then
	          begin
	               dungeonoptions;
	               if not(GAMEOVER) then
	                  begin
	                     screensetup;
	                     writestats(player);
	                  end;
	          end;
	     if (px<>lastx)or(py<>lasty) then
	          begin
	               drawmaptile(lastx,lasty,dmap);
	               case dcode[px,py] of
	                    0:if (roll('1d100')<=dungeonchance) then
	                           begin
	                                encounter(monsterchart);
	                                if not(GAMEOVER) then screensetup;
	                           end;
	                    9:cave_sword(player);
	                   10:cave_shield(player);
	                   11:cave_library;
	                   12:cave_key(player);
	                   13:cave_staircase;
	                   14:cave_locked(player,px,py,lastx,lasty);
	                   15:dungeon_treasure(player);
	                   16:dungeon_trap(player);
	                   17:dungeon_lizard(player,px,py,lastx,lasty);
	                   18:
{stair down}
begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,' There are stairs going down here.');
	message(x,y,'');
	message(x,y,'     Do you take them? (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['y','Y']) then
	     dungeon_engine(player,dungeonmap,dungeoncode,dungeonchart,px,py);
	screensetup;
end;

	                   19:stair_up;
	                   20:castle_knight(player,px,py,lastx,lasty);
	                   21:castle_barracks;
	                   22:castle_courtyard;
	                   23:castle_guest;
	                   24:castle_banquet;
	                   25:castle_master;
	                   26:castle_kitchen;
	                   27:castle_throne(player,px,py,lastx,lasty);
	                   28:secret_passage;
	               end;
	               drawmaptile(lastx,lasty,dmap);
	               if (px=exitx)and(py=exity) then
	                    begin
	                         clearmessage;
	                         homemessage(x,y);
	                         setfont('default.ttf',2);
	                         setcolor(black);
	                         message(x,y,'');
	                         message(x,y,'            Exit? (y/n)');
	                         repeat
	                              ans:=readarrowkey;
	                         until (ans in ['y','Y','n','N']);
	                         exitdungeon:=ans in ['y','Y'];
	                         screensetup;
	                    end;
	          end;

	   if GAMEOVER then exitdungeon:=true;
	until exitdungeon;
end;

{Surface World Functions and Procedures}
{---------------------------------------------------------------------------}
procedure thedragon(var player:character_t);

var ch:char;

begin
	cleardevice;
	setcolor(red);
	setfont('triplex.ttf',3);
	homecursor(x,y);
	if not(dragon in player.stages) then
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'The wind blows quietly, and you get an eerie feeling');
	          graphwriteln(x,y,'as you enter this place.  When you look up into the');
	          graphwriteln(x,y,'mountains, you see that you have stumbled upon');
	          graphwriteln(x,y,'the cave of the great Red Dragon!');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'It''s not too late to turn back.');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          setcolor(lightgray);
	          graphwrite(x,y,'                  Turn back now?  (y/n)');
	          repeat
	               ch:=readarrowkey;
	          until(ch in ['y','Y','n','N']);
	          if (ch in ['y','Y']) then
	               begin
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'     You wisely choose to leave.');
	                    prompt;
	               end
	          else
	               begin
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'');
	                    graphwriteln(x,y,'     You enter the dragon''s lair...');
	                    prompt;
	                    nummonsters:=1;
	                    rollmonsters(monster,nummonsters,'dragon.dat');
	                    monster[1].endurance:=80;
	                    monster[1].endurancemax:=80;
	                    combat(player,nummonsters,monster);
	                    if (nummonsters=0) then
	                         begin
	                              player.stages:=player.stages + [dragon];
	                              cleardevice;
	                              setcolor(lightblue);
	                              setfont('triplex.ttf',3);
	                              homecursor(x,y);
	                              graphwriteln(x,y,'');
	                              graphwriteln(x,y,'');
	                              graphwriteln(x,y,'CONGRATULATIONS!');
	                              graphwriteln(x,y,'You have defeated the great Red Dragon.');
	                              graphwriteln(x,y,'In the dragon''s horde, you find the Flame Wand.');
	                              graphwriteln(x,y,'');
	                              graphwriteln(x,y,'');
                                      drawpic(x,y,'flamewnd.ln1');
	                              if (player.numitems<itemmax) then
	                                   begin
	                                        player.numitems:=player.numitems + 1;
	                                        player.item[player.numitems]:=flamewand;
	                                        setcolor(lightblue);
	                                        graphwriteln(x,y,'     You pick up the Flame Wand as your own.');
	                                        prompt;
	                                   end
	                              else
	                                   begin
	                                        setcolor(lightblue);
	                                        graphwriteln(x,y,'     You are carrying too many items.');
	                                        graphwriteln(x,y,'     Do you want to drop one? (y/n)');
	                                        repeat
	                                             ch:=readarrowkey;
	                                        until(ch in ['n','N','y','Y']);
	                                        if (ch in ['y','Y']) then
	                                             begin
	                                                 dropitem(player);
	                                                  player.numitems:=player.numitems+1;
	                                                  player.item[player.numitems]:=flamewand;
	                                             end
	                                        else
	                                             begin
	                                                  graphwriteln(x,y,'');
	                                                  graphwriteln(x,y,'     You leave the wand here.');
	                                                  prompt;
	                                             end;
	                                   end;
	                         end;
	               end;
	     end
	else
	     begin
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'This was once the dwelling place of the ancient');
	          graphwriteln(x,y,'Red Dragon.');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'You see a huge red carcass nearby with flies');
	          graphwriteln(x,y,'buzzing around it.');
	          graphwriteln(x,y,'');
	          graphwriteln(x,y,'There doesn''t seem to be anything of interest here.');
	          prompt;
	     end;
end;
{---------------------------------------------------------------------------}
procedure thepassword;

begin
	cleardevice;
	homecursor(x,y);
	setfont('sanseri.ttf',4);
	setcolor(lightblue);
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'   In the side of the icy rock');
	graphwriteln(x,y,'mountains you see something written');
	graphwriteln(x,y,'etched in the stone.  It says:');
	setfont('triplex.ttf',6);
	graphwriteln(x,y,'');
	repeat
	    setcolor(roll('1d15'));
	    outtextxy(x,y,'     crystal shard');
	until Keypressed;
	prompt;
end;
{---------------------------------------------------------------------------}
procedure enterinn;


var ans:char;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,' The Elf Skull Inn -- enter? (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['Y','y']) then
	     elfskullinn(player)
	else
	     surfacemessage;
end;
{---------------------------------------------------------------------------}
procedure entertown;

var ans:char;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,'   Gilantry City -- enter? (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['Y','y']) then
	     thetown(player)
	else
	     surfacemessage;
end;
{---------------------------------------------------------------------------}
procedure entercave;

var ans:char;

begin
	clearmessage;
	homemessage(x,y);
	setfont('default.ttf',2);
	setcolor(black);
	message(x,y,'');
	message(x,y,'       A Cave -- enter? (y/n)');
	repeat
	     ans:=readarrowkey;
	until (ans in ['y','Y','n','N']);
	if (ans in ['Y','y']) then
	     dungeon_engine(player,cavemap,cavecode,cavechart,20,8)
	else
	     surfacemessage;
end;
{---------------------------------------------------------------------------}
procedure entercastle(var player:character_t);

var
	enter:    boolean;
	done :    boolean;
	tempstring:string;
	errcode:integer;
	ans:char;
	loop:integer;
	ch:char;

begin
	enter:=false;
	cleardevice;
        drawpic(120,1,'tcastle.ln1');
	setcolor(white);
	message(x,y,'');
	setfont('sanseri.ttf',2);
	graphwriteln(x,y,'You approach the ice castle.  A cold wind blows.');
	if (endgame in player.stages) then
	     begin
	          graphwriteln(x,y,'It has been sealed by the Wizards of Gilantry.');
	          prompt;
	          exit;
	     end;
	prompt;
	done:=false;
	repeat
	     cleardevice;
	     setcolor(white);
	     writefile(1,textdir+'077.txt');
	     repeat
	          ans:=readarrowkey;
	     until (ans in ['b','B','o','O','c','C','l','L']);
	     cleardevice;
	     homecursor(x,y);
	     case ans of
	        'b','B':begin
	                     writefile(1,textdir+'078.txt');
	                     prompt;
	                end;
	        'o','O':begin
	                     writefile(1,textdir+'079.txt');
	                     prompt;
	                end;
	        'c','C':if (player.charges>0) then
	                      begin
	                         graphwriteln(x,y,'Cast which spell?');
	                         with player do
	                              for loop:=1 to numspells do
	                                   begin
	                                        str(loop,tempstring);
	                                        ch:=tempstring[1];
	                                        tempstring:='      ';
	                                        tempstring:=tempstring + ch + '. ';
	                                        tempstring:=tempstring + spellstring(spell[loop]);
	                                        graphwriteln(x,y,tempstring);
	                                   end;
	                         graphwriteln(x,y,'     (N)evermind');
	                         repeat
	                              ans:=readarrowkey;
	                         until (ans in ['1'..ch,'n','N']);
	                         tempstring:=ans;
	                         val(tempstring,loop,errcode);
	                         graphwriteln(x,y,'');
	                         graphwriteln(x,y,'');
	                         if not(player.spell[loop] in [obliterate,callwild]) then
	                              begin
	                                   graphwrite(x,y,'You cast ');
	                                   tempstring:=spellstring(player.spell[loop]);
	                                   graphwriteln(x,y,tempstring);
	                                   graphwriteln(x,y,'It does nothing useful.');
	                                   prompt;
	                              end
	                         else
	                              if (player.spell[loop]=callwild) then
	                                   begin
	                                        graphwriteln(x,y,'An giant bird known as a roc comes to your');
	                                        graphwriteln(x,y,'aid...');
	                                        graphwriteln(x,y,'It cries as it circles and the guards upon');
	                                        graphwriteln(x,y,'the castle duck down to hide.  The roc lands');
	                                        graphwriteln(x,y,'and you hoist yourself upon it.  It flies you');
	                                        graphwriteln(x,y,'over the wall.  The roc leaves and the guards attack.');
	                                        prompt;
	                                        encounter(castlechart);
	                                        done:=true;
	                                        enter:=true;
	                                   end
	                              else
	                                   begin
	                                        graphwriteln(x,y,'You obliterate the gate.');
	                                        graphwriteln(x,y,'Upon seeing this some of the guards make a run');
	                                        graphwriteln(x,y,'for it.  The others attack...');
	                                        prompt;
	                                        encounter(castlechart);
	                                        done:=true;
	                                        enter:=true;
	                                   end;
	                         if not(ans in ['n','N']) then
	                              player.charges:=player.charges-1;
	                      end
	                else
	                      begin
	                           graphwriteln(x,y,'You have not more charges in your ring.');
	                           prompt;
	                      end;
	        'l','L':done:=true;
	     end;{case}
	until done;
	if (enter) then
	     dungeon_engine(player,castlemap,castlecode,castlechart,10,13);

end;
{---------------------------------------------------------------------------}
procedure drawmap(themap:matrix);

var
   row:byte;
   col:byte;

begin
	for row:=1 to rowmax do
	     for col:=1 to colmax do
	          drawmaptile(col,row,themap);
end;
{---------------------------------------------------------------------------}
procedure drawplayer(xpos,ypos:integer;chartile:string);

var
	xpix           :    integer;
	ypix           :    integer;

begin
	xpix:=41;
	ypix:=41;
	xpix:=xpix + ((xpos - 1) * 20);
	ypix:=ypix + ((ypos - 1) * 20);
	drawpic(xpix,ypix,chartile);
end;
{---------------------------------------------------------------------------}
procedure surfacescreen(surfacemap:matrix);

begin
	screensetup;
	drawmap(surfacemap);
	surfacemessage;
	writestats(player);
end;
{---------------------------------------------------------------------------}
procedure surfaceoptions;

var ans:char;

begin
	cleardevice;
	setcolor(green);
	setfont('default.ttf',3);
	x:=10;
	y:=100;
	graphwriteln(x,y,'   Wilderness Options');
	graphwriteln(x,y,'');
	setfont('default.ttf',2);
	graphwriteln(x,y,'');
	setcolor(lightgreen);
	graphwrite(x,y,'            V');
	setcolor(green);
	graphwriteln(x,y,'iew Stats');
	graphwriteln(x,y,'');
	setcolor(lightgreen);
	graphwrite(x,y,'            U');
	setcolor(green);
	graphwriteln(x,y,'se Item');
	graphwriteln(x,y,'');
	setcolor(lightgreen);
	graphwrite(x,y,'            C');
	setcolor(green);
	graphwriteln(x,y,'ast Spell');
	graphwriteln(x,y,'');
	setcolor(lightgreen);
	graphwrite(x,y,'            Q');
	setcolor(green);
	graphwriteln(x,y,'uit Game');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	graphwriteln(x,y,'');
	setcolor(lightgreen);
	graphwrite(x,y,'  ** ');
	setcolor(green);
	graphwrite(x,y,'any other key--Back to Game');
	setcolor(lightgreen);
	graphwriteln(x,y,' **');
	ans:=readarrowkey;
	case ans of
	 'v','V':begin
	              calcstats(player);
	              viewstats(player);
	         end;
	 'u','U':useitem(player);
	 'c','C':castspell(player,wilderness);
	 'q','Q':GAMEOVER:=TRUE;
	end;{case}
end;
{---------------------------------------------------------------------------}
procedure surface(var player:character_t);

var
	px             :    integer;
	py             :    integer;
	lastx          :    integer;
	lasty          :    integer;
	code           :    matrix;
	map            :    matrix;
	pasfile        :    file of matrix;
	ans:char;

begin
	assign(pasfile,mapdir+surfacemap);
	reset(pasfile);
	read(pasfile,map);
	close(pasfile);
	assign(pasfile,mapdir+surfacecode);
	reset(pasfile);
	read(pasfile,code);
	close(pasfile);
	surfacescreen(map);
	px:=10;
	py:=11;
	repeat
	     drawplayer(px,py,chartile);
	     lastx:=px;
	     lasty:=py;
	     repeat
	          ans:=readarrowkey;
	     until (ans in ['2','4','6','8',' ']);
	     if (ans='2')and(py<14)and(code[px,py+1]<>1) then
	          py:=py + 1;
	     if (ans='8')and(py>1)and(code[px,py-1]<>1) then
	          py:=py - 1;
	     if (ans='6')and(px<20)and(code[px+1,py]<>1) then
	          px:=px + 1;
	     if (ans='4')and(px>1)and(code[px-1,py]<>1) then
	          px:=px - 1;
	     if (ans=' ') then
	          begin
	               surfaceoptions;
	               if not(GAMEOVER) then surfacescreen(map);
	          end;
	     if (px<>lastx)or(py<>lasty) then
	          begin
	               drawmaptile(lastx,lasty,map);
	               case code[px,py] of
	                    0:if (roll('1d100')<=wildchance) then
	                           begin
	                                encounter(wildchart);
	                                if not(GAMEOVER) then
	                                   surfacescreen(map);
	                           end;
	                    2:if (roll('1d100')<=roadchance) then
	                           begin
	                                encounter(wildchart);
	                                if not(GAMEOVER) then
	                                   surfacescreen(map);
	                           end;
	                    3:entertown;
	                    4:enterinn;
	                    5:entercave; {* cave *}
	                    6:thedragon(player);
	                    7:thepassword;
	                    8:entercastle(player); {* castle *}
	               end;
	               if (code[px,py] in [3..8])and not(GAMEOVER) then
	                    surfacescreen(map);
	          end;
	until (GAMEOVER);
end;

{---------------------------------------------------------------------------}
procedure mainmenu;

var
   ans          :   char;
   ch           :   char;
   center       :   integer;

begin
    center:=getmaxx DIV 2;
	repeat
	     cleardevice;
	     setfont('gothic.ttf',8);
	     setcolor(lightgray);
	     centerwrite(center,10,'The Ice Queen');
	     ans:='I';
	     repeat
	          setfont('default.ttf',5);
	          setcolor(lightblue);
	          centerwrite(center,120,'Introduction');
	          centerwrite(center,180,'Start');
	          centerwrite(center,240,'Load');
	          centerwrite(center,300,'Quit');
	          setcolor(white);
	          case ans of
	               'I':centerwrite(center,120,'Introduction');
	               'S':centerwrite(center,180,'Start');
	               'L':centerwrite(center,240,'Load');
	               'Q':centerwrite(center,300,'Quit');
	          end;
	          ch:=readarrowkey;
	          case ch of
	               '8':case ans of
	                        'I':ans:='Q';
	                        'S':ans:='I';
	                        'L':ans:='S';
	                        'Q':ans:='L';
	                   end;
	               '2':case ans of
	                        'I':ans:='S';
	                        'S':ans:='L';
	                        'L':ans:='Q';
	                        'Q':ans:='I';
	                   end;
	          end;
	          if ((ch=#13) and (ans in ['I']) or (ch in ['i','I']))then
              begin
	                cleardevice;
	                homecursor(x,y);
	                setfont('default.ttf',2);
	                setcolor(lightblue);
	                writefile(y,textdir+'intro.txt');
	                prompt;
	                cleardevice;
	                setfont('gothic.ttf',8);
	                setcolor(lightgray);
	                centerwrite(center,10,'The Ice Queen');
	          end;
	     until ((ch=#13) and (ans in ['S','L','Q'])) or
	           (ch in ['s','S','l','L','q','Q']);
	     if (ch in ['s','S','l','L','q','Q']) then
	          ans:=ch;
	     GAMEOVER:=FALSE;
	     case ans of
	          'S','s':startgame(player);
	          'L','l':loadgame(player);
	          'Q','q':begin
	                     closescreen;
	                     halt;
	                  end;
	     end;{case}
	     if (ans in ['s','S','l','L']) then
	        begin
	           thetown(player);
	           if not(GAMEOVER) then surface(player);
	        end;
	until FALSE;
end;

{===========================================================================}

begin {main}

	openscreen;
	titlescreen;
	mainmenu;
	closescreen;

end.  {main}
