PROGRAM NAME:  BLACKDAY.PAS

We no longer need to write messages by programing either.  We just store
different windows with different messages.


WINDOWS

Map ---------> (41,41,440,320)

Message -----> (41,361,600,440)

Stats -------> (481,41,600,320)

MAP TILES:  20 x 20                 NUMBER:  280


     {shield.pic}
     setcolor(darkgray);
     circle(23,23,20);
     setfillstyle(solidfill,darkgray);
     floodfill(23,23,darkgray);
     setcolor(black);
     circle(23,23,16);
     setfillstyle(solidfill,lightgray);
     setcolor(lightgray);
     floodfill(23,23,black);
     setcolor(black);
     arc(23,23,30,80,10);

     arc(23,23,0,5,18);
     arc(23,23,20,25,18);
     arc(23,23,40,45,18);
     arc(23,23,60,65,18);
     arc(23,23,80,85,18);
     arc(23,23,100,105,18);
     arc(23,23,120,125,18);
     arc(23,23,140,145,18);
     arc(23,23,160,165,18);
     arc(23,23,180,185,18);
     arc(23,23,200,205,18);
     arc(23,23,220,225,18);
     arc(23,23,240,245,18);
     arc(23,23,260,265,18);
     arc(23,23,280,285,18);
     arc(23,23,300,305,18);
     arc(23,23,320,325,18);
     arc(23,23,340,345,18);

     {axe.pic}
     setcolor(lightgray);
     arc(33,14,90,180,10);
     arc(33,14,270,360,10);
     ellipse(34,8,90,270,2,4);
     ellipse(39,13,180,360,4,2);
     ellipse(27,15,0,180,4,2);
     ellipse(33,19,270,90,2,4);

     setcolor(lightblue);
     line(43,3,40,7);
     setcolor(lightgray);
     line(43,3,39,6);
     line(39,7,18,28);
     line(17,28,7,38);
     line(7,39,6,39);
     line(6,39,6,40);

     line(43,3,41,8);
     line(40,8,19,29);
     line(19,30,9,40);
     line(8,40,8,41);
     line(8,41,7,41);

     setfillstyle(solidfill,darkgray);
     floodfill(28,8,lightgray);
     floodfill(38,18,lightgray);
     setfillstyle(solidfill,lightblue);
     floodfill(10,36,lightgray);
     putpixel(7,40,white);


     {sword.pic}
     setcolor(lightgray);
     line(3,43,6,37);
     line(6,37,29,14);

     line(3,43,9,40);
     line(9,40,32,17);

     line(27,11,35,19);

     setfillstyle(solidfill,darkgray);
     floodfill(20,25,lightgray);

     line(27,11,27,9);
     line(27,9,29,9);

     line(35,19,37,19);
     line(37,19,37,17);

     line(29,9,37,17);

     setfillstyle(solidfill,darkgray);
     floodfill(32,14,lightgray);

     line(32,12,38,6);
     line(34,14,40,8);

     circle(40,6,2);

     setfillstyle(solidfill,lightgray);
     floodfill(40,6,lightgray);
     floodfill(37,9,lightgray);

     circle(41,5,2);

     setcolor(red);

     circle(41,5,1);
     putpixel(41,5,red);
     putpixel(40,4,red);
     putpixel(42,6,red);

     putpixel(38,8,red);
     putpixel(36,10,red);
     putpixel(34,12,red);


     setcolor(black);

     line(27,11,35,19);

     setcolor(darkgray);
     line(27,11,27,9);
     line(27,9,29,9);

     line(35,19,37,19);
     line(37,19,37,17);

     setcolor(black);
     line(29,9,37,17);
     
     {potion.pic}
     setcolor(brown);
     line(22,12,24,12);
     line(22,12,20,8);
     line(24,12,26,8);
     line(20,8,26,8);

     setfillstyle(solidfill,brown);
     floodfill(23,10,brown);

     setcolor(white);
     line(18,13,28,13);
     line(18,13,18,16);
     line(28,13,28,16);
     line(18,16,21,16);
     line(28,16,25,16);
     line(21,16,21,21);
     line(25,16,25,21);

     circle(23,30,9);
     setcolor(black);
     line(22,21,24,21);

     setcolor(white);
     line(15,30,31,30);

     line(16,39,30,39);
     line(16,39,16,35);
     line(30,39,30,35);

     putpixel(18,37,black);
     putpixel(28,37,black);

     setfillstyle(solidfill,blue);
     floodfill(23,32,white);

     setcolor(lightblue);
     line(16,30,30,30);
     line(18,31,28,31);

     setcolor(blue);
     line(18,38,28,38);


     {potion2.pic}
     setcolor(brown);
     line(22,12,24,12);
     line(22,12,20,8);
     line(24,12,26,8);
     line(20,8,26,8);

     setfillstyle(solidfill,brown);
     floodfill(23,10,brown);

     setcolor(white);
     line(18,13,28,13);
     line(18,13,18,16);
     line(28,13,28,16);
     line(18,16,21,16);
     line(28,16,25,16);
     line(21,16,21,21);
     line(25,16,25,21);

     circle(23,30,9);
     setcolor(black);
     line(22,21,24,21);

     setcolor(white);
     line(15,30,31,30);

     line(16,39,30,39);
     line(16,39,16,35);
     line(30,39,30,35);

     putpixel(18,37,black);
     putpixel(28,37,black);

     setfillstyle(solidfill,red);
     floodfill(23,32,white);

     setcolor(lightred);
     line(16,30,30,30);
     line(18,31,28,31);

     setcolor(red);
     line(18,38,28,38);

     {potion2.pic}
     setcolor(brown);
     line(22,12,24,12);
     line(22,12,20,8);
     line(24,12,26,8);
     line(20,8,26,8);

     setfillstyle(solidfill,brown);
     floodfill(23,10,brown);

     setcolor(white);
     line(18,13,28,13);
     line(18,13,18,16);
     line(28,13,28,16);
     line(18,16,21,16);
     line(28,16,25,16);
     line(21,16,21,21);
     line(25,16,25,21);

     circle(23,30,9);
     setcolor(black);
     line(22,21,24,21);

     setcolor(white);
     line(15,30,31,30);

     line(16,39,30,39);
     line(16,39,16,35);
     line(30,39,30,35);

     putpixel(18,37,black);
     putpixel(28,37,black);

     setfillstyle(solidfill,green);
     floodfill(23,32,white);

     setcolor(lightgreen);
     line(16,30,30,30);
     line(18,31,28,31);

     setcolor(green);
     line(18,38,28,38);


     {tcastle.pic}
{---------------------------------------------------------------------------}
procedure brick(xpos,ypos,stop:integer;pendown:boolean);

var
     pixelcolor     :    integer;

begin
     for loop:=ypos to stop do
         begin
              if pendown then
                   putpixel(xpos,loop,black);
              pixelcolor:=getpixel(xpos,loop+1);
              if (pixelcolor=0) then
                   pendown:=not(pendown);
         end;
end;
{---------------------------------------------------------------------------}

     setcolor(white);    {base}
     line(16*5,45*5,16*5,61*5);
     line(80*5,48*5,80*5,59*5);
     line(16*5,45*5,38*5,30*5);
     line(80*5,48*5,38*5,30*5);
     line(16*5,61*5,38*5,70*5);
     line(80*5,59*5,38*5,70*5);

     setcolor(lightblue);
     setfillstyle(solidfill,lightblue);
     fillellipse(38*5,14*5,8*5,3*5);  {top}
     line(29*5+4,14*5,38*5,1*5);
     line(38*5,1*5,46*5+1,14*5);
     floodfill(38*5,4*5,lightblue);

     fillellipse(20*5,35*5,6*5,2*5);
     line(14*5,35*5,20*5,24*5);
     line(20*5,24*5,26*5,35*5);
     floodfill(20*5,26*5,lightblue);

     fillellipse(77*5,40*5,5*5,1*5);
     line(72*5,40*5,77*5,32*5);
     line(82*5,40*5,77*5,32*5);
     floodfill(77*5,34*5,lightblue);


     setcolor(white);
     line(33*5,33*5,33*5,14*5);  {tower}
     line(43*5,32*5,43*5,14*5);
     ellipse(38*5,14*5,0,180,5*5,3*5);
     putpixel(38*5,30*5,black);

     line(17*5,35*5,17*5,44*5);
     line(23*5,35*5,23*5,40*5);
     ellipse(20*5,35*5,0,180,3*5,2*5);
     putpixel(20*5,42*5+1,black);

     line(75*5,46*5,75*5,40*5);
     line(79*5,47*5+2,79*5,40*5);
     ellipse(77*5,40*5,0,180,2*5,1*5);
     putpixel(77*5,46*5+4,black);



     setfillstyle(solidfill,darkgray);
     floodfill(40*5,45*5,white);

     setcolor(black);
   
     ellipse(38*5,18*5,45,135,5*5-1,3*5);
     ellipse(38*5,23*5,45,135,5*5-1,3*5);
     ellipse(38*5,28*5,45,135,5*5-1,3*5);
     ellipse(38*5,33*5-2,45,135,5*5-1,3*5);
     ellipse(20*5,38*5,45,135,3*5-1,2*5);
     ellipse(20*5,42*5,45,135,3*5-1,2*5);
     ellipse(77*5,42*5,45,135,2*5-1,1*5);
     ellipse(77*5,45*5,45,135,2*5-1,1*5);

     line(38*5,35*5,80*5-1,50*5-1);
     line(38*5,40*5,80*5-1,52*5-3);
     line(38*5,45*5,80*5-1,53*5-2);
     line(38*5,50*5,80*5-1,54*5-1);
     line(38*5,55*5,80*5-1,55*5);
     line(38*5,60*5,80*5-1,57*5-3);
     line(38*5,65*5,80*5-1,58*5-1);
     line(38*5,35*5,16*5+1,47*5);
     line(38*5,40*5,16*5+1,49*5);
     line(38*5,45*5,16*5+1,50*5+3);
     line(38*5,50*5,16*5+1,52*5+4);
     line(38*5,55*5,16*5+1,55*5);
     line(38*5,60*5,16*5+1,56*5+4);
     line(38*5,65*5,16*5+1,58*5+4);


     brick(41*5,31*5,69*5,false);
     brick(45*5,33*5+1,68*5,true);
     brick(48*5,35*5,67*5,false);
     brick(52*5,36*5+1,66*5,true);
     brick(55*5,38*5,65*5,false);
     brick(58*5,39*5+1,63*5,true);
     brick(60*5,40*5,65*5,false);
     brick(63*5,41*5+1,63*5,true);
     brick(65*5,42*5,63*5-2,false);
     brick(67*5,43*5+1,62*5,true);
     brick(69*5,44*5,62*5-2,false);
     brick(71*5,44*5+2,61*5,true);
     brick(73*5,45*5,60*5+2,false);
     brick(75*5,46*5,60*5,true);
     brick(76*5,47*5,59*5+3,false);
     brick(77*5,48*5-4,59*5,true);
     brick(78*5,49*5,59*5,false);
     brick(78*5+4,48*5,59*5,true);
     brick(18*5,44*5,62*5-2,false);
     brick(20*5,42*5+3,63*5,true);
     brick(22*5,40*5,63*5+1,false);
     brick(24*5,39*5+4,64*5,true);
     brick(27*5,38*5,65*5,false);
     brick(30*5,36*5-1,66*5,true);
     brick(34*5,33*5,68*5,false);
     brick(38*5,30*5,70*5,true);

     {inn.pic}
     setcolor(lightgreen);
     line(9,8,13,6);
     line(9,8,13,12);
     line(13,6,17,10);
     line(13,12,17,10);
     setfillstyle(solidfill,lightgreen);
     floodfill(13,8,lightgreen);

     setcolor(green);
     line(9,8,13,12);
     line(9,8,5,12);
     line(13,12,5,12);
     setfillstyle(solidfill,green);
     floodfill(9,10,green);

     setcolor(yellow);
     line(6,13,6,17);
     line(6,17,12,17);
     line(12,13,6,13);
     line(12,13,16,11);
     line(12,17,16,15);
     line(16,11,16,15);
     setfillstyle(solidfill,yellow);
     floodfill(15,13,yellow);

     setcolor(black);
     line(13,13,13,16);

     setcolor(brown);
     line(8,15,8,17);
     line(9,15,9,17);

     {hammer.pic}
     setcolor(lightgray);
     arc(10,40,180,270,3);
     line(8,40,29,19);
     line(29,19,27,17);

     line(10,42,31,21);
     line(31,21,35,25);
     line(35,25,38,25);
     line(38,25,41,22);
     line(41,22,41,19);
     line(41,19,27,5);

     ellipse(26,11,270,90,2,6);
     
     setfillstyle(solidfill,darkgray);
     floodfill(35,20,lightgray);

     line(35,25,41,19);

     setcolor(lightblue);
     ellipse(25,11,270,90,2,6);
     arc(9,41,180,270,3);

     {flamewnd.pic}
     setcolor(red);
     setfillstyle(solidfill,red);
     fillellipse(23,8,3,3);
     setcolor(white);
     arc(23,8,15,85,3);
     setcolor(yellow);
     ellipse(20,8,270,360,3,4);
     ellipse(26,8,180,270,3,4);
     line(20,12,26,12);
     setfillstyle(solidfill,lightred);
     setcolor(lightred);
     fillellipse(23,14,5,1);
     line(21,15,25,15);
     line(21,15,22,37);
     line(25,15,24,37);
     fillellipse(23,38,3,1);
     setfillstyle(solidfill,red);
     floodfill(23,20,lightred);
     setcolor(red);
     fillellipse(23,41,2,2);
     setcolor(white);
     arc(23,41,15,85,2);

     {magicshl.pic}
     setcolor(brown);
     ellipse(19,8,270,360,4,2);
     ellipse(19,8,180,270,7,2);
     ellipse(27,8,180,270,4,2);
     ellipse(27,8,270,360,7,2);
     line(34,8,36,8);
     line(10,8,12,8);
     ellipse(23,8,180,360,13,33);
     setfillstyle(solidfill,yellow);
     floodfill(23,23,brown);
     setfillstyle(solidfill,brown);
     fillellipse(23,23,4,4);
     setcolor(brown);
     line(23,13,23,17);
     line(23,29,23,33);
     line(29,23,32,23);
     line(14,23,17,23);
     line(18,18,16,16);
     line(28,18,30,16);
     line(18,28,16,30);
     line(28,28,30,30);

     {magicswd.pic}
     setcolor(lightgreen);
     setfillstyle(solidfill,lightgreen);
     fillellipse(23,2,1,2);
     setcolor(lightblue);
     line(21,2,22,3);
     line(25,2,24,3);
     line(22,3,24,3);
     line(22,3,22,7);
     line(22,7,16,9);
     line(16,9,21,10);
     line(21,10,23,12);
     line(24,3,24,7);
     line(24,7,30,9);
     line(30,9,25,10);
     line(25,10,23,12);
     line(21,10,21,37);
     line(25,10,25,37);
     line(21,37,23,43);
     line(25,37,23,43);
     setfillstyle(solidfill,darkgray);
     floodfill(23,20,lightblue);
     setcolor(lightgray);
     line(21,2,22,3);
     line(25,2,24,3);
     line(22,3,24,3);
     line(22,3,22,7);
     line(22,7,16,9);
     line(16,9,21,10);
     line(21,10,23,12);
     line(24,3,24,7);
     line(24,7,30,9);
     line(30,9,25,10);
     line(25,10,23,12);
     setfillstyle(solidfill,lightgray);
     floodfill(23,10,lightgray);
     setcolor(black);
     setfillstyle(solidfill,lightgreen);
     fillellipse(23,9,1,2);
     putpixel(24,4,darkgray);
     putpixel(22,4,darkgray);
     putpixel(24,6,darkgray);
     putpixel(22,6,darkgray);
     setcolor(darkgray);
     line(22,3,24,3);

     {thetown.pic}
     setcolor(lightgray);
     line(90,70,90,130);
     line(90,130,80,130);
     line(80,130,80,120);
     line(80,120,60,110);
     line(60,110,60,120);
     line(60,120,40,112);
     line(40,112,40,102);
     line(40,102,15,92);
     line(15,92,15,102);
     line(15,102,0,95);
     line(0,95,0,400);

     line(130,130,140,130);
     line(130,130,130,70);
     line(90,70,130,70);
     line(140,130,140,120);
     line(140,120,160,120);
     line(160,120,160,130);
     line(160,130,180,130);
     line(180,130,180,120);
     line(180,120,200,120);
     line(200,120,200,130);
     line(200,130,220,130);
     line(220,130,220,120);
     line(220,120,240,120);
     line(240,120,240,130);
     line(240,130,260,130);
     line(260,130,260,120);
     line(260,120,280,120);
     line(280,120,280,130);
     line(280,130,300,130);
     line(300,130,300,120);
     line(300,120,320,120);
     line(320,120,320,130);
     line(320,130,340,130);
     line(340,130,340,120);
     line(340,120,360,120);
     line(360,120,360,130);
     line(360,130,380,130);
     line(380,130,380,120);
     line(380,120,400,120);
     line(400,120,400,130);
     line(400,130,410,130);
     line(410,130,410,70);
     line(410,70,450,70);
     line(450,70,450,130);
     line(450,130,460,130);
     line(460,130,530,90);
     line(530,90,530,80);
     line(530,80,550,60);
     line(550,60,550,400);
     line(550,400,0,400);
     setfillstyle(solidfill,darkgray);
     floodfill(275,195,lightgray);
     line(550,250,0,250);

     setfillstyle(solidfill,lightblue);
     floodfill(275,0,lightgray);

     setcolor(red);
     setfillstyle(solidfill,red);
     fillellipse(430,70,30,5);
     line(460,70,430,10);
     line(400,70,430,10);
     floodfill(430,50,red);

     fillellipse(110,70,30,5);
     line(140,70,110,10);
     line(80,70,110,10);
     floodfill(110,50,red);

     setcolor(black);
     setfillstyle(solidfill,brown);
     ellipse(275,190,0,180,25,20);
     line(250,190,250,250);
     line(300,190,300,250);
     line(250,250,300,250);
     floodfill(275,220,black);
     setlinestyle(solidln,0,thickwidth);
     line(275,170,275,250);
     setlinestyle(0,0,0);
     line(279,171,279,250);
     line(283,173,283,250);
     line(287,174,287,250);
     line(291,176,291,250);
     line(295,180,295,250);

     line(271,171,271,250);
     line(267,173,267,250);
     line(263,174,263,250);
     line(259,176,259,250);
     line(255,180,255,250);


     setlinestyle(solidln,0,0);
     line(550,400,0,400);
     line(550,0,550,400);
     line(0,0,0,400);
     line(330,250,350,250);
     line(330,250,330,260);
     line(330,260,442,400);
     line(330,250,480,400);
     line(350,250,543,400);
     line(350,250,350,170);
     line(350,170,400,156);
     line(400,140,400,289);
     line(400,140,470,100);
     line(470,100,470,343);
     line(470,100,550,100);
     line(470,160,550,150);

     setfillstyle(interleavefill,lightgray);
     floodfill(380,200,black);

     setfillstyle(solidfill,lightgray);
     floodfill(400,300,black);
     floodfill(400,330,black);

     setfillstyle(interleavefill,red);
     floodfill(450,200,black);
     setfillstyle(solidfill,red);
     floodfill(500,150,black);

     setfillstyle(interleavefill,brown);
     floodfill(500,250,black);

     line(350,250,200,250);

     line(200,250,220,250);
     line(220,250,220,260);
     line(220,260,100,400);
     line(220,250,70,400);
     line(200,250,4,400);

     setfillstyle(solidfill,lightgray);
     floodfill(150,310,black);
     floodfill(150,340,black);

     setfillstyle(interleavefill,darkgray);
     floodfill(300,300,black);

     line(200,250,200,150);
     line(200,150,150,120);
     line(150,120,70,120);
     line(70,120,70,137);
     line(150,120,150,288);
     line(150,165,80,150);
     line(80,140,80,342);
     line(80,140,0,115);

     setfillstyle(interleavefill,lightblue);
     floodfill(180,180,black);
     setfillstyle(solidfill,blue);
     floodfill(120,140,black);

     setfillstyle(interleavefill,brown);
     floodfill(120,200,black);

     setfillstyle(interleavefill,darkgray);
     floodfill(50,200,black);

     setcolor(darkgray);
     line(360,180,360,200);
     line(360,180,390,175);
     line(360,200,390,201);
     line(390,175,390,201);
     setfillstyle(solidfill,darkgray);
     floodfill(380,191,darkgray);
     
     setcolor(black);
     settextstyle(small,horizontal,3);
     outtextxy(367,179,'Eagle');
     outtextxy(367,186,'Talon');
     outtextxy(367,193,'I n n');

     setcolor(darkgray);
     ellipse(430,195,270,360,20,5);
     ellipse(430,205,0,90,20,5);
     line(450,195,450,205);
     setfillstyle(solidfill,black);
     floodfill(449,200,darkgray);
     setcolor(darkgray);
     bar(402,197,403,203);
     bar(403,199,410,201);

     setcolor(lightred);
     line(410,197,435,197);
     line(410,197,410,220);
     line(435,197,435,220);
     line(410,220,423,235);
     line(435,220,423,235);
     setfillstyle(interleavefill,brown);
     floodfill(420,210,lightred);
     setcolor(yellow);
     line(415,200,430,200);
     line(410,197,435,197);
     line(410,197,410,220);
     line(435,197,435,220);
     line(410,220,423,235);
     line(435,220,423,235);
     ellipse(423,209,0,360,5,4);
     ellipse(423,209,0,360,2,1);
     putpixel(422,213,lightred);
     putpixel(423,213,lightred);
     putpixel(424,213,lightred);
     line(421,213,421,224);
     line(424,213,424,218);
     line(424,218,426,218);
     line(426,218,426,220);
     line(426,220,424,220);
     line(424,220,424,222);
     line(424,222,426,222);
     line(426,222,426,224);
     line(426,224,421,224);
     setfillstyle(solidfill,yellow);
     floodfill(423,212,yellow);
     setcolor(black);
     line(415,200,430,200);
     line(410,197,435,197);
     line(410,197,410,220);
     line(435,197,435,220);
     line(410,220,423,235);
     line(435,220,423,235);
     ellipse(423,209,0,360,5,4);
     ellipse(423,209,0,360,2,1);
     line(421,213,421,224);
     line(424,213,424,218);
     line(424,218,426,218);
     line(426,218,426,220);
     line(426,220,424,220);
     line(424,220,424,222);
     line(424,222,426,222);
     line(426,222,426,224);
     line(426,224,421,224);
     putpixel(422,213,yellow);
     putpixel(423,213,yellow);
     putpixel(423,213,yellow);

     setcolor(darkgray);
     ellipse(510,190,270,360,30,10);
     ellipse(510,210,0,90,30,10);
     line(540,190,540,210);
     setfillstyle(solidfill,black);
     floodfill(535,200,darkgray);
     bar(479,196,481,204);
     bar(480,199,490,201);
     setcolor(lightgray);
     line(490,195,520,195);
     line(490,195,490,230);
     line(520,195,520,230);
     line(490,230,505,250);
     line(520,230,505,250);
     line(495,200,515,200);
     setfillstyle(interleavefill,lightgray);
     floodfill(510,210,lightgray);
     setcolor(white);
     ellipse(503,209,180,360,7,2);
     ellipse(503,227,180,360,7,2);
     line(496,209,496,227);
     line(510,209,510,211);
     line(511,212,514,212);
     line(515,213,515,222);
     line(514,223,511,223);
     line(510,224,510,227);
     putpixel(509,213,black);
     putpixel(509,222,black);
     line(510,215,510,220);
     line(510,215,512,215);
     line(510,220,512,220);
     line(513,216,513,219);
     setfillstyle(solidfill,darkgray);
     floodfill(503,220,white);
     setcolor(black);
     ellipse(503,209,180,360,7,2);
     ellipse(503,227,180,360,7,2);
     line(496,209,496,227);
     line(510,209,510,211);
     line(511,212,514,212);
     line(515,213,515,222);
     line(514,223,511,223);
     line(510,224,510,227);
     putpixel(509,213,black);
     putpixel(509,222,black);
     line(510,215,510,220);
     line(510,215,512,215);
     line(510,220,512,220);
     line(513,216,513,219);

     setcolor(darkgray);
     ellipse(180,175,180,270,20,5);
     ellipse(180,185,90,180,20,5);
     ellipse(160,180,90,270,2,5);
     setfillstyle(solidfill,black);
     floodfill(165,180,darkgray);
     bar(195,179,198,181);
     setcolor(black);
     line(198,177,198,183);
     setcolor(cyan);
     line(175,177,195,177);
     line(175,177,175,200);
     line(195,177,195,200);
     line(175,200,185,210);
     line(195,200,185,210);
     setfillstyle(solidfill,cyan);
     floodfill(185,190,cyan);
     setcolor(black);
     line(179,180,191,180);
     circle(186,190,4);
     arc(186,190,25,90,2);
     arc(186,190,215,325,7);
     line(191,195,189,193);
     line(181,195,183,193);
     setfillstyle(solidfill,lightcyan);
     floodfill(186,190,black);
     setfillstyle(solidfill,lightblue);
     floodfill(186,195,black);

     setcolor(white);
     line(90,172,140,180);
     line(90,172,90,230);
     line(140,180,140,220);
     line(90,230,140,220);
     setfillstyle(closedotfill,yellow);
     floodfill(120,200,white);
     setcolor(black);
     line(90,172,140,180);
     line(90,172,90,230);
     line(140,180,140,220);
     line(90,230,140,220);

     setcolor(white);
     ellipse(45,170,180,270,35,10);
     ellipse(45,190,90,180,35,10);
     ellipse(10,180,90,270,3,10);
     setfillstyle(solidfill,black);
     floodfill(20,180,white);
     bar(60,179,70,181);
     bar(69,175,71,185);
     setcolor(lightgray);
     line(30,175,60,175);
     line(30,175,30,210);
     line(60,175,60,210);
     line(30,210,45,230);
     line(60,210,45,230);
     setfillstyle(solidfill,lightgray);
     floodfill(45,200,lightgray);
     setcolor(black);
     line(35,180,55,180);
     line(45,186,46,186);
     putpixel(44,187,black);
     putpixel(47,187,black);
     line(45,188,45,194);
     line(46,188,46,194);
     line(41,195,50,195);
     line(44,196,44,213);
     line(47,196,47,213);
     line(45,214,46,214);
     line(45,215,46,215);

     setcolor(white);
     line(45,196,45,213);
     line(46,196,46,213);
     line(45,187,46,187);






     {doors}
     setcolor(white);
     line(360,230,360,257);
     line(360,230,378,238);
     line(378,238,378,272);
     line(360,257,378,272);
     setfillstyle(solidfill,darkgray);
     floodfill(370,250,white);
     setcolor(black);
     line(360,230,360,257);
     line(360,230,378,238);
     line(378,238,378,272);
     line(360,257,378,272);

     setcolor(white);
     line(415,255,415,300);
     line(415,255,440,265);
     line(440,265,440,320);
     line(415,300,440,320);
     setfillstyle(solidfill,red);
     floodfill(420,280,white);
     setcolor(black);
     line(415,255,415,300);
     line(415,255,440,265);
     line(440,265,440,320);
     line(415,300,440,320);

     setcolor(white);
     line(490,285,490,358);
     line(490,285,520,298);
     line(520,298,520,382);
     line(490,358,520,382);
     setfillstyle(solidfill,brown);
     floodfill(510,350,white);
     setcolor(black);
     line(490,285,490,358);
     line(490,285,520,298);
     line(520,298,520,382);
     line(490,358,520,382);

     setcolor(white);
     line(190,230,190,257);
     line(190,230,172,238);
     line(172,238,172,270);
     line(190,257,172,270);
     setfillstyle(solidfill,lightblue);
     floodfill(180,250,white);
     setcolor(black);
     line(190,230,190,257);
     line(190,230,172,238);
     line(172,238,172,270);
     line(190,257,172,270);

     setcolor(white);
     line(130,258,130,303);
     line(130,258,105,268);
     line(105,268,105,323);
     line(130,303,105,323);
     setfillstyle(solidfill,brown);
     floodfill(120,300,white);
     setcolor(black);
     line(130,258,130,303);
     line(130,258,105,268);
     line(105,268,105,323);
     line(130,303,105,323);

     setcolor(white);
     line(60,284,60,356);
     line(60,284,30,300);
     line(30,300,30,380);
     line(60,356,30,380);
     setfillstyle(interleavefill,lightgray);
     floodfill(50,350,white);
     setcolor(black);
     line(60,284,60,356);
     line(60,284,30,300);
     line(30,300,30,380);
     line(60,356,30,380);

     setcolor(white);
     settextstyle(sanseri,horizontal,2);
     outtextxy(40,310,'1');
     outtextxy(500,310,'4');
     settextstyle(sanseri,horizontal,1);
     settextstyle(default,horizontal,1);
     outtextxy(179,245,'2');
     outtextxy(365,245,'3');

     setfillstyle(solidfill,black);
     floodfill(600,20,black);

     setcolor(white);
     settextstyle(default,horizontal,1);
     outtextxy(80,405,'Choose a place to visit, press 5 for town options');

     {skulldie.pic}
     setfillstyle(solidfill,white);
     setcolor(white);
     bar(1,1,40,40);
     setcolor(darkgray);
     circle(20,20,23);
     setfillstyle(solidfill,black);
     floodfill(600,400,darkgray);
     floodfill(0,0,darkgray);
     floodfill(600,400,white);
     floodfill(0,0,white);
     setcolor(black);
     setlinestyle(solidln,0,thickwidth);
     ellipse(20,15,0,360,12,10);
     ellipse(20,30,125,60,7,6);
     fillellipse(25,15,3,3);
     fillellipse(15,15,3,3);
     setlinestyle(solidln,0,normwidth);
     line(15,31,25,31);
     line(16,25,16,35);
     line(19,25,19,35);
     line(22,25,22,35);
     setcolor(lightgray);
     settextstyle(default,horizontal,1);
     outtextxy(2,45,'skull');

      {blackdie.pic}
     setfillstyle(solidfill,white);
     setcolor(white);
     bar(1,1,40,40);
     setcolor(darkgray);
     circle(20,20,23);
     setfillstyle(solidfill,black);
     floodfill(600,400,darkgray);
     floodfill(0,0,darkgray);
     floodfill(600,400,white);
     floodfill(0,0,white);
     setcolor(black);
     fillellipse(20,20,12,15);
     setcolor(lightgray);
     ellipse(20,20,20,80,8,10);
     putpixel(15,15,darkgray);
     putpixel(18,23,darkgray);
     putpixel(12,18,darkgray);
     putpixel(24,24,darkgray);
     putpixel(26,12,darkgray);
     putpixel(19,28,darkgray);
     setlinestyle(solidln,0,normwidth);
     setcolor(darkgray);
     settextstyle(default,horizontal,1);
     outtextxy(2,45,'black');

     {whitedie.pic}
     setfillstyle(solidfill,white);
     setcolor(white);
     bar(1,1,40,40);
     setcolor(darkgray);
     circle(20,20,23);
     setfillstyle(solidfill,black);
     floodfill(600,400,darkgray);
     floodfill(0,0,darkgray);
     floodfill(600,400,white);
     floodfill(0,0,white);
     setcolor(black);
     setlinestyle(solidln,0,thickwidth);
     ellipse(21,11,180,360,10,22);
     ellipse(21,11,0,180,10,5);
     line(21,11,21,26);
     line(16,16,26,16);
     setlinestyle(solidln,0,normwidth);
     setcolor(white);
     settextstyle(default,horizontal,1);
     outtextxy(2,45,'white');


     {inn.ln1}
     setfillstyle(solidfill,lightgray);
     setcolor(yellow);
     bar(5,11,16,19);

     setcolor(red);
     line(2,12,10,4);
     line(11,4,19,12);
     line(4,12,10,6);
     line(11,6,17,12);
     line(6,12,10,8);
     line(11,8,15,12);
     line(8,12,10,10);
     line(11,10,13,12);
     line(10,12,10,12);
     line(11,12,11,12);

     setfillstyle(solidfill,brown);
     setcolor(brown);
     bar(10,14,14,19);
