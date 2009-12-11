{include switches.pas}

program IceQueen;

uses crt, graph, ice;

{---------------------------------------------------------------------------}
procedure initgame(var configuration:configrecord);

var
     pasfile        :    file of configrecord;

begin
     randomize;
     settextstyle(default,horizontal,2);     {default text style}
{
make dynamic in config.dat:   (defaults)

use configfile

 }
     with configuration do
          begin
               surfacemap:='surface.map';
               surfacecode:='surface.cod';
               cavemap:='cave.map';
               cavecode:='cave.cod';
               castlemap:='castle.map';
               castlecode:='castle.cod';
               dungeonmap:='dungeon.map';
               dungeoncode:='dungeon.cod';
               wildchart:='wild.dat';
               cavechart:='cave.dat';
               dungeonchart:='dungeon.dat';
               castlechart:='castle.dat';
               leftpic:='msoldier.ln1';
               rightpic:='landon.ln1';
               chartile:='chartile.ln1';
               savegame:='game.sav';
          end;

     assign(pasfile,configfile);
     rewrite(pasfile);
     write(pasfile,configuration);
     close(pasfile);

end;

{$I ESI.PAS}

{---------------------------------------------------------------------------}
procedure encounter(chartfile:stringtype);

var
     monsterchart   :    chartrecord;
     pasfile        :    file of chartrecord;
     theroll        :    integer;
     count          :    integer;
     val1           :    integer;
     val2           :    integer;
     monsterfile    :    stringtype;
     tempstring     :    stringtype;
     monmax         :    integer;

begin
     clearmessage;
     homemessage(x,y);
     settextstyle(default,horizontal,2);
     setcolor(black);
     message(x,y,'           You encounter');
     message(x,y,'');
     message(x,y,'             MONSTERS!');
     prompt;
     if not(exist(chartfile)) then
          exit;
     assign(pasfile,chartfile);
     reset(pasfile);
     read(pasfile,monsterchart);
     close(pasfile);

     with monsterchart do
          begin
               theroll:=droll(diceroll);
               monmax:=diceroll.rollnum*diceroll.dicetype+diceroll.bonus;
               for count:=1 to monmax do
                    begin
                         val1:=value[count,1];
                         val2:=value[count,2];
                         if (theroll in [val1..val2]) then
                              begin
                                   monsterfile:=filename[count];
                                   nummonsters:=droll(number[count]);
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

{$I DUNGEON.PAS}
{$I SURFACE.PAS}

{===========================================================================}

begin {main}

     gfilesloc(device,mode,'c:\tp\bgi');
     initgame(cfg);

     {MAIN}

     titlescreen;
     mainmenu;
     thetown(player);
     surface(player);

     {QUICKSTART}
{
     loadgame(player);
     elfskullinn(player);
}

{
     thetown(player);
     surface(player);
}
     closegraph;
end.  {main}
