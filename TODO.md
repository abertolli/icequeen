Improvements
------------
* Create save.dat for all save games and limit number available
* Migrate to SDL2
* Move files to isolate Ice Queen and make room for similar games
* standardize maps and images (esp. dungeons)
* Create a bmp image to use for portraits in battle; update code to intelligently handle bmp vs ln1 if needed; remove restriction of 4-bit color
* Intelligently handle word wrapping and no longer rely on preformatted text.  Write out "word by word" and calculate the end of line.

Bugs
----
* After fighting Baltar (esi), the text is too big, and subsquent text in ESI doesn't seem right.
* fakebattle generates a red bar when the demon kills you

Game Mechanics
--------------
* Accumulate number of drinks/drunkenness at the bar to increase chances of a special occurance (limited)
* Ring charges are so valuable, either update the usefulness of spells that are "wasted" or provide more charges when initially buying the ring.
	* Increase chances that 'power' does something useful in battle or make it do something at least a little bit useful every time.
	* Divide the things power does into 'fizzles' and actual actions that do something.  If it fizzles, dont' take a charge.
	* Don't worry about this if adding support for classes.
* Increase chances of encountering weak/less monsters on the surface.  Encounters can be at a similar frequency, but there needs to be an ability to actually gain some levels in the beginning.
* Look again at monster life, reduce randomness
* Reduce randomness of powerful attacks and spells
* Add spell/attack effects
* Reduce number of screen switches, esp in battle -- fewer keypresses.
* Look at experience received, levels, etc.

New Additions
---------
* Add a card game?  Blackjack is easy.


Add Support for Classes
-----------------------
* Certain classes can use the ring, or else certain classes can cast spells innately without the ring.
* The problem is the ring is a core component of game play and designed as a goal.  Maybe keep it and allow to cast 'power' which will do what you need to do at any event ('call wild' at the castle, 'shatter' at the lock).  Then anyone can finish the game, but spellcasters can bypass getting the ring.

Generalizing Special Events
---------------------------
Although you start in town, the default format of the game is map-based with encounters with monsters.  Stepping on certain squares provides entry into other areas of the game.  Sometimes this is another map (e.g. the dungeon), or sometimes it is a special sequence of events (e.g. the castle before you gain entry), or an entirely custom location (elf skull inn or Gilantry).

Special events usual take the format of a sequence of one or more of the following elements:
(1) Displaying graphics and/or text on the screen
(2) Prompting the player for input, e.g (y)es/(n)o or (a)ttack/(r)un, etc. with valid responses leading either ending the event or leading to another element
(3) Combat
(4) Finding treasure
(5) Restarting this event, or initiating another special event
(6) Entering a map/location

Adding Quests
-------------
Quests can require one or more of the following:
(1) Killing a certain type of monster
(2) Obtaining an item
(3) Returning to the quest giver

Quests are like stages--maybe it would be best to combine the two concepts.

Add concept of encounters where combat is just one part.
* Add ability to include treasure


Things to do:

* Make graphics for the monsters
* Allow players to choose their picture
* $ picks pockets in the Elf Skull Inn
* Add new items: Magical Armor, Two-Handed Sword
* ! in Equip Shop and response to shopkeeper "JD3" gives special items
* # in Eagle Talon Inn and response to Tantala "JP4" gives full hp
* use bmp files
* split into directories
* convert graphics to OpenGL
* add bmp support
* add mouse support

Remember:

--
Pascal RPG is an attempt to turn a game I wrote using Turbo Pascal 6.0 into a more usable RPG.  The reason I would like to use SourceForge is so that people who would also be interested in the project may put some time into it since it has been very slow going.  Particularly, I think there are very few Pascal projects out there, and I think this one may attract a certain niche.  I will contact the pascal-l mailing list (Yahoo!) about working on this if the project gets accepted by SourceForge.

The most difficult goal of the project will be rewriting the graphics of the game in order to support OpenGL instead of Borland's traditional Graph Unit syntax.  Since this is a difficult task, I have been working on a couple of other areas:  improving item, monster, and character statistics.  Further goals will be to add classes/races, create a different magic system, and provide modifiable "events" that can occur during the game.  One of the most glaring issues with the game is the lack of graphic art.  I hope that someone will draw pictures for the game after the OpenGL is implemented.

-

This is an RPG game written in Pascal (using Free Pascal).  It is based on the source code of a GPL'ed game called Ice Queen, another RPG written in Pascal.  The goal of this project is to expand Ice Queen to include new features, and most of all to improve the graphics.  Futhermore, the game will be geared somewhat towards a game engine--making it a tool to create multiple games.  Right now, Ice Queen runs primarily under DOS, but Pascal RPG's target OS is going to be primarily Linux, and then ported from Linux to other OS's.
