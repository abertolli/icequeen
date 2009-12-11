{I/O and other Functions and Procedures}
{--------------------------------------------------------------------------}
function READARROWKEY    :    char;

{This function can be used instead of readkey, returning an arrow key value as
its keypad counterpart.}

var
     key            :    char;

begin
     key:=readkey;
     if key=#0 then
          begin
               key:=readkey;
               case key of
                    #72:key:='8';
                    #77:key:='6';
                    #75:key:='4';
                    #80:key:='2';
               end;
          end;
     readarrowkey:=key;
end;
{--------------------------------------------------------------------------}
function exist(dosname:stringtype) : boolean;

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
function D(dnum:integer):integer; begin d:=random(dnum)+1; end;

{The value of d(dnum) is returned as a random number between 1 and dnum.}

{--------------------------------------------------------------------------}
function DROLL(diceroll:dicerecord):integer;

{Returns the value of dice rolled based on dicerecord format (#d#+#).}

var
     sum  :    integer;
     loop :    integer;

begin
     sum:=0;
     for loop:=1 to diceroll.rollnum do
          sum:=sum + (d(diceroll.dicetype));
     sum:=sum + diceroll.bonus;
     if (sum<0) then
          sum:=0;
     droll:=sum;
end;
{--------------------------------------------------------------------------}
function CAPITALIZE(capstring:stringtype):stringtype;

{CAPITALIZE is returned as capstring in all caps.}

begin
     for loop:=1 to length(capstring) do
          capstring[loop]:=upcase(capstring[loop]);
     capitalize:=capstring;
end;
{--------------------------------------------------------------------------}
procedure gfilesloc(var gdriver,gmode:integer;gpath:string);

{Used to locate the graphics files.}

var
     error          :    integer;

begin
     clrscr;
     repeat
          gdriver:=detect;
          initgraph(gdriver,gmode,gpath);
          error:=graphresult;
          if(error<>grOK)then
               begin
                    writeln('Graphics error:  ',grapherrormsg(error));
                    if(error=grfilenotfound)then
                         begin
                              writeln;
                              writeln('     Cannot find graphics driver.');
                              write('     Please enter directory path for the driver:  ');
                              readln(gpath);
                              writeln;
                         end
                    else
                         halt(1);
               end;
     until(error=grOK);
end;
