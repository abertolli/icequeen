http://code.google.com/p/icequeen/

Please note:
- Ice Queen is protected under the terms of the GPL (located in LICENSE-GPL.txt).
- GraphIO library is protected under the terms of the LGPL (located in LICENSE-LGPL.txt).

If you need a free compiler, look for the Free Pascal Compiler at
http://www.freepascal.org/

Things to think about when compiling:

* Different compilers have different sized data types.  This program opens files of record types and reads/writes them.  If you get a disk reading error, try compiling and running the "default" utility which recreates all of those files.

* global.pas is the global variables, which have been put in a separate file so that when you change some data in the main program, the utility programs are updated also (just by changing global.pas)

--Angelo

----------------------------------------------------------
Ice Queen version 2.1
Copyright (C) 2001 Angelo Bertolli

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

Angelo Bertolli
angelo.bertolli@gmail.com

----------------------------------------------------------
GraphIO Library
Copyright (C) 2001 Angelo Bertolli

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

Angelo Bertolli
angelo.bertolli@gmail.com
