program MonsterChartCreator;

uses crt;

const
     version        =    'v1.1';
     spellmax       =    8;
     itemmax        =    9;

type
     stringtype     =    string[20];
     dicerecord     =    record
                              rollnum        :    word;
                              dicetype       :    word;
                              bonus          :    integer;
                         end;
     chartrecord    =    record
                              value     :    array[1..20,1..2] of byte;
                              filename  :    array[1..20] of stringtype;
                              number    :    array[1..20] of dicerecord;
                              diceroll  :    dicerecord;
                         end;


var
     ch             :    char;
     int            :    integer;
     loop           :    integer;
     chart          :    chartrecord;
     dosname        :    stringtype;
     pasfile        :    file of chartrecord;
     goahead        :    boolean;
     monstermax     :    word;

{--------------------------------------------------------------------------}
function exist(dosname:stringtype) : boolean;

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


begin {main}
  repeat
     clrscr;
     writeln('Ice Queen Monster Chart Creator ',version);
     writeln;
     writeln;
     with chart do
          begin
               with diceroll do
                    begin
                         writeln('Dice Roll = <rollnum>d<dicetype>+<bonus>');
                         writeln('(max 20 monsters)');
                         write('     rollnum:  ');
                         readln(rollnum);
                         write('     dicetype:  ');
                         readln(dicetype);
                         write('     bonus:  ');
                         readln(bonus);
                         monstermax:=rollnum*dicetype+bonus;
                    end;
               if (monstermax>20) then
                    monstermax:=20;
               for loop:=1 to monstermax do
                    begin
                         writeln;
                         writeln('MONSTER ',loop,' of ',monstermax);
                         write('Enter monster file (eg. kobold.dat):  ');
                         readln(filename[loop]);
                         with number[loop] do
                              begin
                                   writeln('No. Appearing = <rollnum>d<dicetype>+<bonus>');
                                   write('     rollnum:  ');
                                   readln(rollnum);
                                   write('     dicetype:  ');
                                   readln(dicetype);
                                   write('     bonus:  ');
                                   readln(bonus);
                              end;
                         writeln('Enter value range (inclusive)');
                         write('Starting Value (from):  ');
                         readln(value[loop,1]);
                         write('Ending Value (to):  ');
                         readln(value[loop,2]);

                    end;
          end;
     writeln;
     writeln;

     write('Enter Save File Name:  ');
     readln(dosname);
     goahead:=false;
     if exist(dosname) then
          begin
               writeln('File exists.');
               writeln('Overwrite? (y/n)');
               repeat
                    ch:=readkey;
               until (ch in ['n','N','y','Y']);
               if (ch in ['y','Y']) then
                    goahead:=true;
          end
     else
          goahead:=true;
     if goahead then
          begin
               assign(pasfile,dosname);
               rewrite(pasfile);
               write(pasfile,chart);
               close(pasfile);
               writeln('Saved.');
          end;
     writeln('<Enter> to continue, <ESC> to quit.');
     repeat
           ch:=readkey;
     until (ch in [#13,#27]);
  until (ch in [#27]);

end. {main}
