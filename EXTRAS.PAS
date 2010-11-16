{$ifndef EXTRAS.PAS}
{
Supplementary Functions
Copyright (C) 1996-2005 Angelo Bertolli

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

Angelo Bertolli <angelo.bertoli@gmail.com>
}

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
function exist(dosname:string) : boolean;

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
function CAPITALIZE(capstring:string):string;

{CAPITALIZE is returned as capstring in all caps.}

var
   loop        : word;

begin
     for loop:=1 to length(capstring) do
          capstring[loop]:=upcase(capstring[loop]);
     capitalize:=capstring;
end;
{--------------------------------------------------------------------------}
{$define EXTRAS.PAS}
{$endif}
