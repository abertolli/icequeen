program getmaptext;

uses crt;

const
     rowmax         =    14;       {number of rows on a map}
     colmax         =    20;       {number of columns on a map}
     indent         =    '     ';

type
     stringtype     =    string[20];
     matrix         =    array[1..colmax,1..rowmax] of integer;

var
     ch             :    char;
     ans            :    char;
     loop           :    integer;
     themap         :    matrix;
     mapfile        :    file of matrix;
     outfile        :    text;
     outname        :    stringtype;
     mapname        :    stringtype;
     maptext        :    stringtype;  {eg. "surface" creates surface[#,#]..}
     col            :    integer;
     row            :    integer;


begin
     clrscr;
     write('Enter map file name:  ');
     readln(mapname);
     write('Enter out file name:  ');
     readln(outname);
     write('Enter map name (mapname[#,#]:=#) :  ');
     readln(maptext);

     assign(mapfile,mapname);
     reset(mapfile);
     read(mapfile,themap);
     close(mapfile);

     assign(outfile,outname);
     rewrite(outfile);
     for col:=1 to colmax do
          begin
               for row:=1 to rowmax do
                    begin
                         write(outfile,indent);
                         write(outfile,maptext);
                         write(outfile,'[',col,',',row,']:=',themap[col,row],';');
                         writeln(outfile);
                         write('.');
                    end;
          end;
     close(outfile);
     writeln;
     writeln('Done.');
     ch:=readkey;

end.