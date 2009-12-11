{---------------------------------------------------------------------------}
procedure initgame(var surfacemap,surfacecode,cavemap,cavecode,castlemap,
castlecode:matrix;var printport:stringtype;var stages:intset);

var
     pasfile        :    text;
     thetile        :    integer;

begin
     randomize;
     settextstyle(default,horizontal,2);
     assign(pasfile,'surface.map');
     reset(pasfile);
     for row:=1 to rowmax do
          begin
               for col:=1 to colmax do
                    begin
                         read(pasfile,thetile);
                         surfacemap[col,row]:=thetile;
                         if not eoln(pasfile) then
                              read(pasfile,ch);
                    end;
               readln(pasfile);
          end;
     assign(pasfile,'surface.cod');
     reset(pasfile);
     for row:=1 to rowmax do
          begin
               for col:=1 to colmax do
                    begin
                         read(pasfile,thetile);
                         surfacecode[col,row]:=thetile;
                         if not eoln(pasfile) then
                              read(pasfile,ch);
                    end;
               readln(pasfile);
          end;
     assign(pasfile,'cave.map');
     reset(pasfile);
     for row:=1 to rowmax do
          begin
               for col:=1 to colmax do
                    begin
                         read(pasfile,thetile);
                         cavemap[col,row]:=thetile;
                         if not eoln(pasfile) then
                              read(pasfile,ch);
                    end;
               readln(pasfile);
          end;
     stages:=[];

     {* setup program (setup.dat) *}
     printport:='LPT1';
     {  LPT1
        LPT2
        LPT3
        LST
        PRN
        COM1
        COM2  }
     
end;
