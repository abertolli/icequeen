{---------------------------------------------------------------------------}
procedure mainmenu;

begin
     repeat
          menuscreen;
          drawpicturebyline(460,240,'landon.pic');
          drawpicturebyline(60,225,'soldier.pic');
          ans:='C';
          repeat
               setcolor(lightblue);
               outtextxy(160,150,'Introduction');
               outtextxy(240,200,'Rules');
               outtextxy(220,250,'Credits');
               outtextxy(240,300,'Start');
               outtextxy(250,350,'Load');
               outtextxy(250,400,'Quit');
               setcolor(white);
               case ans of
                    'I':outtextxy(160,150,'Introduction');
                    'R':outtextxy(240,200,'Rules');
                    'C':outtextxy(220,250,'Credits');
                    'S':outtextxy(240,300,'Start');
                    'L':outtextxy(250,350,'Load');
                    'Q':outtextxy(250,400,'Quit');
               end;
               ch:=readarrowkey;
               case ch of
                    '8':case ans of
                             'I':ans:='Q';
                             'R':ans:='I';
                             'C':ans:='R';
                             'S':ans:='C';
                             'L':ans:='S';
                             'Q':ans:='L';
                        end;
                    '2':case ans of
                             'I':ans:='R';
                             'R':ans:='C';
                             'C':ans:='S';
                             'S':ans:='L';
                             'L':ans:='Q';
                             'Q':ans:='I';
                        end;
               end;
               if (ch=#13) and (ans in ['I','R','C']) then
                    begin
                         case ans of
                              'I':introduction;
                              'R':rules;
                              'C':credits;
                         end;
                         menuscreen;
                    end;
          until (ch=#13) and (ans in ['S','L','Q']);
          case ans of
               'S':startgame(player);
               'L':loadgame(stages,player);
               'Q':begin
                        closegraph;
                        halt;
                   end;
          end;
          settextstyle(default,horizontal,2);
          town;
          surface(surfacecode);
     until FALSE;
end;
