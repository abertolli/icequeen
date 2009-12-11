{Drawing Functions and Procedures}
{-------------------------------------------------------------------------}
procedure DRAWPICTUREBYLINE(beginx,beginy:integer;dosname:stringtype);

{dosname            =    name of the file, including extention
beginx, beginy      =    the coordinates of where the upper left hand corner
                         of where the picture will be.}

var
     pasfile        :    text;
     row            :    integer;
     col            :    integer;
     color          :    integer;
     length         :    integer;
     lineoftext     :    string[100];
     savename       :    stringtype;

begin

     savename:='';
     if not(exist(dosname)) then
          begin
               savename:=dosname;
               dosname:='nophoto.ln1';
          end;
     assign(pasfile,dosname);
     reset(pasfile);
     readln(pasfile,lineoftext);
     if(lineoftext='FORMAT=LINE')then
          begin
               row:=beginy;
               col:=beginx;
               while not eof(pasfile) do
                    begin
                         while not eoln(pasfile) do
                              begin
                                   read(pasfile,color);
                                   read(pasfile,ch);
                                   read(pasfile,length);
                                   if not eoln(pasfile) then
                                        read(pasfile,ch);
                                   setcolor(color);
                                   line(col,row,(col+length),row);
                                   col:=col + length;
                              end;
                         readln(pasfile);
                         row:=row + 1;
                         col:=beginx;
                    end;
          end;
     close(pasfile);
     if (savename<>'') then
          begin
               setcolor(lightblue);
               settextstyle(default,horizontal,1);
               outtextxy(beginx+15,beginy+20,savename);
          end;

end;
{---------------------------------------------------------------------------}
procedure drawmaptile(xpos,ypos:integer;themap:matrix);

var
     xpix           :    integer;
     ypix           :    integer;
     tilenum        :    integer;
     filename       :    stringtype;

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
          filename:='blank.ln1';
     end;
     drawpicturebyline(xpix,ypix,filename);
end;
{---------------------------------------------------------------------------}
procedure drawitem(xpos,ypos:integer;theitem:item);

var
     filename       :    stringtype;

begin
     case theitem of
           sword:filename:='sword.ln1';
          shield:filename:='shield.ln1';
             axe:filename:='axe.ln1';
      bluepotion:filename:='potion1.ln1';
       redpotion:filename:='potion2.ln1';
     greenpotion:filename:='potion3.ln1';
       chainmail:filename:='chain.ln1';
       platemail:filename:='plate.ln1';
          dagger:filename:='dagger.ln1';
            club:filename:='club.ln1';
           staff:filename:='staff.ln1';
          hammer:filename:='hammer.ln1';
      magicsword:filename:='magicswd.ln1';
     magicshield:filename:='magicshl.ln1';
       flamewand:filename:='flamewnd.ln1';
     else
          filename:='blank.ln1';
     end;{case}
     drawpicturebyline(xpos,ypos,filename);
end;
