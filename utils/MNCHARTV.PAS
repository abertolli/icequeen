program MonsterChartViewer;

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
     maxmon         :    integer;

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
     writeln('Ice Queen Monster Chart Viewer ',version);
     writeln;
     writeln;
     write('Enter Chart File Name:  ');
     readln(dosname);
     while not(exist(dosname)) do
          begin
               writeln('File does not exist.');
               write('Quit? (y/n)');
               repeat
                    ch:=readkey;
               until (ch in ['n','N','y','Y']);
               if (ch in ['y','Y']) then
                    halt;
               write('Enter Chart File Name:  ');
               readln(dosname);
          end;
     assign(pasfile,dosname);
     reset(pasfile);
     read(pasfile,chart);
     close(pasfile);
     writeln('Chart Loaded, press any key to continue.');
     ch:=readkey;

     clrscr;
     writeln;
     writeln;
     maxmon:=0;
     with chart do
          begin
               with diceroll do
                    writeln('Roll:  ':60,rollnum,'d',dicetype,'+',bonus);
               writeln('Result':8,'Filename':18,'No.':16);
               maxmon:=diceroll.rollnum*diceroll.dicetype+diceroll.bonus;
               for loop:=1 to maxmon do
                    begin
                         write(value[loop,1]:4,value[loop,2]:4,
                               filename[loop]:20);
                         with number[loop] do
                              writeln(rollnum:10,'d',dicetype,'+',bonus);
                    end;
          end;
     writeln('Done.':60);
     writeln('<Enter> to continue, <ESC> to quit.');
     repeat
          ch:=readkey;
     until (ch in [#13,#27]);

  until (ch in [#27]);
end. {main}
