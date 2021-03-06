Ice Queen
=========

Originally developed for Turbo Pascal, Freepascal is now the compiler of choice.
http://www.freepascal.org/

Copyright (C) 1995-2018 Angelo Bertolli
Ice Queen comes with ABSOLUTELY NO WARRANTY.
This is free software and you are welcome to redistribute it under certain
terms and conditions.  Please see the file named LICENSE.

Introduction
------------

A chilling breeze comes from the north, reminding you of the recent course of events. You remember when the cold came about one month after spring started. At first no one did more than complain about the inconvenient weather. But soon it became evident that there was something wrong. A dry cold had set over the City of Gilantry. 

It seems that only the City was affected and farmers were still able to grow their crops. However, it didn't take long for disease and depression to set in among the people. Later it was realized that a great Winter was approaching from the north. You know the cause of these happenings all too well... 

You are summoned by the Council of Wizards. Most of them are stricken with disease and unable to meet you. The young Gandalf still looks well and he greets you. "As you know," he begins, "we have been experiencing an extended cold spell. We believe it to be a work of magic." And then he confirms your suspicions, "We suspect this to be the work of the Ice Queen." The term brings back memories of your triumph over the Ice Queen so many years ago. "Since you have battled her before, we now ask for your help in defeating the Ice Queen and saving this noble city from her raging blizzard that now approaches from the north." 

Of course, being the great person you are, you accept the mission and the reward. What reward? Why fame and glory of course! Not to mention the reward that comes with it.

	
Character Creation
------------------

**Saved Games**

The default file for loading or saving a game is "game.sav" (without any input, the computer defaults to this file). This saved game is set by Icequeen defaults when you get the game. It contains a rather good character named "Landon" on level 2 with more equipment and money than you get get starting your own. You might want to play Landon for a while to get used to the game. Starting with your own character, you will start at level 1 and have to buy your own equipment.

Equipment and Magic
-------------------

**Weapons and Armor**

When you have weapons and armor in your possession, you automatically weild the best of what you have. In general, the more it costs, the better it is. So take note of your damage, THAC0, and AC when you get new items, they will change automatically. 

**Potions**

Potions are sold at the Magic Shop in town. You can use these during battle or in the wilderness. However, effects other than healing do not last very long, so certain potions should be saved for combat.

- Blue: Increases Strength and Dexterity for a short period of time.

- Red: Offers a few points of healing (best for low levels).

- Green: A complete heal, and super charges Strength and Dexterity. 

**Spells**

There might be ways to gain knowledge of other spells than just those you can learn at the shop, however these are the most common.

- Power: This unusual spell is random, doing weird and chaotic things.

- Call Wild: This spell calls the aid of the wildlife around you. Obviously it works in outdoor settings the best, though it's usefulness is questionable.

- Courage: This spell makes the caster more courageous, giving him a greater ability to hit and do damage.

- Web: This spell sticks to a creature, making it almost impossible for it to make attacks normally.

- Heal: This spell heals the caster somewhat.

- Fire Blast: This spell hits a single creature with a blast of fire. The power of this spell increases as the caster increases in level. 

**The Ring of Power**

The ring is sold at the magic shop (the second door on the left in town). When you buy a ring, it will come with the spell Power and one charge. Whenever you are taught a new spell, it is put into your ring and you gain another charge. This is the usual way to gain charges. Any spell you use, takes one charge from your ring. When all your charges are gone, you will need to give the ring one day to recharge itself (sleep at an inn).

Experience and Levels
---------------------

When you have enough experience you will gain a level automatically. You will not be warned, but your stats will change. You gain endurance, the ability to hit creatures, the ability to dodge special attacks, etc. As a rule, if there's a monster in the game you can't beat, it's because you're not on high enough level. At higher levels, this game begins to become extremely easy (that's why you start at level 1). However, as your level increases, it is increasingly harder to get to the next one. You should be able to beat the game around levels 5 to 7.

In Town
-------

The game starts in the City of Gilantry. You can visit different places while in Gilantry by selecting the number on the door, or you can press space and look at the Options Menu. The various places to visit include the Weapon Shop, the Magic Shop, the Inn, and the Pub. But more importantly, in town is the only place where you can save the game. Saving the game often is important, because if you die you will have to start from the last point you saved.

**OOPS!! I hit the wrong key!**

"I accidently selected (s)ell an item, but there isn't an item I want to sell!" That's okay, just go through the prompts. Before it does anything, you'll be asked if you're sure if you want to sell it. Just say no. This is also for accidently selecting an item you don't want to buy, etc. 

Exploring the Wilderness
------------------------

The wilderness is a dangerous place with wandering monsters everywhere. Some are weak and some are strong, so you need to choose your battles wisely. In the wilderness you have a similar set of options as in town, however you cannot save the game here.

Towards the south is Gilantry City; towards the north is the Ice Castle where the Ice Queen resides. It is cold and desolate. Towards the west is a mysterious cave, and just northeast of Gilantry City is a lonely inn, the Elf Skull Inn. Build up strength and money before trying to venture into the cave, and especially before entering the Ice Castle.

Troubleshooting
---------------

This is a DOS program. Sometimes you need to tweak with Windows to get it to run properly. This would include going into the program properties and changing them if they are not already set. If all else fails, you can try running it in MSDOS mode. 

Changelog
---------

- 1.0: The original project. The code and program itself is lost as far as I know. Basically it had an old version of the menu screens, and was created using my own system of attack scores vs defense scores. Other than older menu screens, the original title of the game was "The Castle of the Winds," but was changed when I found out another game took the name. 

- 1.1: The demo version that is available. The code to this is also gone. It has improved menu screens for town and wilderness options. There seems to be a bug when encountering monsters. It crashes sometimes, probably on a particular monster. Version 1.0 and 1.1 do not allow access to the Castle or the Cave. 

- 2.0: Changed over to D&D numbers and stats. Improved the "view stats" screen. And most of all, you can actually go up levels starting in 2.0. Not only that but your character has more stats such as experience, levels, THAC0, etc. some to replace Combat Skill and Luck from the older versions. There is a "Character Converter" program to convert the characters from one to the other. Unfortunately, no one is able to keep the "Obliterate" spell if they obtained it. No more unlimited spells. The player must buy the Ring of Power that already contains the spell Power and one charge. Each time the player recieves a new spell, it is enchanted into the ring, and another charge is added. Changed the look of the swamp tile, cave tile, and inn tile. New combat system with new monster stats. The wandering monsters are rolled against a chart which is now contained in a file. And this file points to where the monster file is. Configuration settings are kept in config.dat and tell the system which files to use for maps, special encounters, and random monster encounters.

- 2.1: Put Ice Queen under GNU Public License.  Put all source code for the main game into one file.

Credits
-------

* Programming: Angelo Bertolli, Philip Gutierrez
* Graphics: Angelo Bertolli, Philip Gutierrez
* Story: Angelo Bertolli
* Play Testing: Joe Doran III, Jake Parker IV, Joshua C. Matthews
* Special Thanks: Joyce Galiette, Oscar Lopez

Created by Angelo Bertolli

