Unit Ice;

INTERFACE

uses crt, graph;

{$I global.pas}

function READARROWKEY    :    char;
function exist(dosname:stringtype) : boolean;
function D(dnum:integer):integer;
function DROLL(diceroll:dicerecord):integer;
function CAPITALIZE(capstring:stringtype):stringtype;
procedure gfilesloc(var gdriver,gmode:integer;gpath:string);
procedure DRAWPICTUREBYLINE(beginx,beginy:integer;dosname:stringtype);
procedure drawmaptile(xpos,ypos:integer;themap:matrix);
procedure drawitem(xpos,ypos:integer;theitem:item);
procedure prompt;
procedure HOMECURSOR(var x,y:integer);
procedure GWRITE(var x,y:integer;gtext:string);
procedure GWRITELN(var x,y:integer;gtext:string);
procedure GREAD(var x,y:integer;var gtext:stringtype);
procedure writefile(beginy:integer;dosname:stringtype);
procedure titlescreen;
procedure introduction;
procedure credits;
procedure menuscreen;
procedure startgame(var player:playerrecord);
procedure loadgame(var player:playerrecord);
procedure mainmenu;
function itemstring(theitem:item):stringtype;
function spellstring(thespell:spell):stringtype;
procedure calcstats(var player:playerrecord);
procedure dropitem(var player:playerrecord);
procedure viewstats(var player:playerrecord);
procedure died;
procedure rollmonsters(var monster:monsterlist;nummonsters:integer;monsterfile:stringtype);
procedure combat(var player:playerrecord;var nummonsters:integer;monster:monsterlist);
procedure clearmap;
procedure clearmessage;
procedure clearstats;
procedure screensetup;
procedure writestats(player:playerrecord);
procedure homemessage(var x,y:integer);
procedure message(var x,y:integer;gtext:string);
procedure surfacemessage;
procedure savegame(player:playerrecord);
procedure broke;
procedure useitem(var player:playerrecord);
procedure castspell(var player:playerrecord;area:location);
procedure thetown(var player:playerrecord);

IMPLEMENTATION

{$I IO.PAS}
{$I DRAW.PAS}
{$I GWRITE.PAS}
{$I TITLE.PAS}
{$I GETNAME.PAS}
{$I VIEW.PAS}
{$I DEATH.PAS}
{$I COMBAT.PAS}
{$I SCREEN.PAS}
{$I TOWN.PAS}

{===========================================================================}

begin {main}

end.  {main}
