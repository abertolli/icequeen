{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,R-,S+,V+,X-}
{$M 16384,0,655360}

program BMPtoLN1;

{use this to record bmp files to ln1 files (line compression without
invis background support)

NOTE:  make sure the bmp file is in 16 colors
       use the "offset" constant to offset colors in case the palattes are
           different}

uses crt, graph, dos;

type
     TBitmapFileHeader = record
          bfType: Word;
          bfSize: Longint;
          bfReserved1: Word;
          bfReserved2: Word;
          bfOffBits: Longint;
     end;

     TBitmapInfoHeader = record
          biSize: Longint;
          biWidth: Longint;
          biHeight: Longint;
          biPlanes: Word;
          biBitCount: Word;
          biCompression: Longint;
          biSizeImage: Longint;
          biXPelsPerMeter: Longint;
          biYPelsPerMeter: Longint;
          biClrUsed: Longint;
          biClrImportant: Longint;
     end;

     TRGBQuad = record
          rgbblue: Byte;
          rgbgreen: Byte;
          rgbred: Byte;
          rgbReserved: Byte;
     end;

     TBitmapInfo = record
          bmiFileheader:TBitmapFileHeader;
          bmiHeader: TBitmapInfoHeader;
          bmiColors: array[0..15] of TRGBQuad;
     end;

var
     x,y       :     word;
     device    :     integer;
     mode      :     integer;
     q         :     byte;
     carry     :     integer;
     cas       :     integer;
     cas1      :     integer;
     b         :     byte;
     ch        :     char;
     loop      :     integer;
     bmpfile   :     string;
     lnfile    :     string;
     xsize     :     integer;
     ysize     :     integer;
     lineoftext:     string[80];

{---------------------------------------------------------------------------}
procedure graph_init(var gdriver,gmode:integer;gpath:string);

var
     error          :    integer;

begin
     writeln;
     DetectGraph(gdriver,gmode);

     gdriver:=vga;
     gmode:=vgahi;

     initgraph(gdriver,gmode,gpath);
     error:=graphresult;
     if not(error=grOK)then
          begin
               writeln('Graphics initialization error!');
               writeln('Program cannot continue.  Press enter.');
               readln;
               halt(1);
          end;
end;

{--------------------------------------------------------------------------}
procedure drawbmp(dosname:string;xpos,ypos:integer);

var
     f     :     file of byte;
     g     :     file of TbitmapInfo;
     data  :     TbitmapInfo;

begin

     assign(g,dosname);
     reset(g);
     read(g,data);
     close(g);

     assign(f,dosname);
     reset(f);
     seek(f,data.bmifileheader.bfoffbits);

     {CHANGE COLOR PALETTE}
{
     for loop:=0 to 15 do
          begin
               setrgbpalette(loop,(data.bmicolors[loop].rgbred shr 2),
                             (data.bmicolors[loop].rgbgreen shr 2),
                             (data.bmicolors[loop].rgbblue shr 2));
               setpalette(loop,loop);
          end;
}

     {DRAWING PICTURE}
     for y:=data.bmiheader.biheight downto 1 do
          for x:=1 to (data.bmiheader.biwidth div 2+3) and not 3  do
               begin
                    read(f,b);
                    putpixel((x*2)+xpos,y+ypos,b shr 4);
                    putpixel((x*2+1)+xpos,y+ypos,b and 15);
               end;
     close(f);

end;
{---------------------------------------------------------------------------}
procedure STOREPICTUREBYLINE(beginx,beginy,endx,endy:integer;dosname:string;
                       whiteout:boolean);

{dosname            =    name of the file, including extention
beginx, beginy      =    the coordinates of where the upper left hand corner
                         of the picture
endx, endy          =    lower right hand corner of the picture
whiteout            =    TRUE means that the picture area will become white
                         as it is stored}

var
     pasfile        :    text;
     row            :    integer;
     col            :    integer;
     color          :    integer;
     length         :    integer;
     nextcolor      :    integer;

begin
     assign(pasfile,dosname);
     rewrite(pasfile);
     writeln(pasfile,'FORMAT=LINE');
     for row:=beginy to endy do
          begin
               length:=0;
               for col:=beginx to endx do
                    begin
                         color:=getpixel(col,row);
                         length:=length + 1;
                         nextcolor:=getpixel(col+1,row);
                         if(color<>nextcolor)or(col=endx)then
                              begin

                                   {Change colors here}
                                   case color of
                                        blue:color:=lightred;
                                        red:color:=blue;
                                        lightblue:color:=red;
                                        yellow:color:=white;
                                        brown:color:=cyan;
                                        cyan:color:=brown;
                                        lightcyan:color:=yellow;

                                   end;{case}

                                   write(pasfile,color);
                                   write(pasfile,' ');
                                   write(pasfile,length);
                                   if(col<>endx)then
                                        write(pasfile,' ');
                                   if(whiteout)then
                                        begin
                                             setcolor(white);
                                             line(col,row,(col-length),row);
                                        end;
                                   length:=0;
                              end;
                    end;
               writeln(pasfile);
          end;
     close(pasfile);
end;
{--------------------------------------------------------------------------}
procedure DRAWPICTUREBYLINE(beginx,beginy:integer;dosname:string);

{dosname            =    name of the file, including extention
beginx, beginy      =    the coordinates of where the upper left hand corner
                         of where the picture will be.}

var
     pasfile        :    text;
     row            :    integer;
     col            :    integer;
     color          :    integer;
     length         :    integer;

begin

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

end;
{--------------------------------------------------------------------------}

begin
          clrscr;
          write('BMP file (input):  ');
          readln(bmpfile);
          write('x size:  ');

          readln(xsize);
          write('y size:  ');
          readln(ysize);
          writeln;
          write('LN1 file (output):  ');
          readln(lnfile);
          writeln;

          graph_init(device,mode,'c:\tp\bgi');

          drawbmp(bmpfile,0,0);
          ch:=readkey;

          STOREPICTUREBYLINE(1,1,xsize+1,ysize+1,lnfile,true);
          ch:=readkey;

          DRAWPICTUREBYLINE(100,100,lnfile);

          ch:=readkey;
          closegraph;
end.