--[[ Karni's Crap Filter ]]--

---------------------------------------------------------------------------------
--
--	Karni's Crap Filter - A World of Warcraft addon
--
--	Copyright (C) 2008-2014  Karnifex
--
--	This file is part of Karni's Crap Filter.
--
--	Karni's Crap Filter is free software: you can redistribute it and/or
--	modify it under the terms of the GNU General Public License as
--	published by the Free Software Foundation, either version 3 of the
--	License, or (at your option) any later version.
--
--	Karni's Crap Filter is distributed in the hope that it will be useful,
--	but WITHOUT ANY WARRANTY; without even the implied warranty of
--	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--	GNU General Public License for more details.
--
--	You should have received a copy of the GNU General Public License
--	along with this program. If not, see <http://www.gnu.org/licenses/>.
--
-------------------------------------------------------------------------------

-- table has the ID and the min required level to use

foodList	= {
	-- Classic --
	["17344"]	= 0,	-- Candy Cane
	["2070"]	= 0,	-- Darnassian Bleu
	["4604"]	= 0,	-- Forest Mushroom Cap
	["7097"]	= 0,	-- Leg Meat
	["4536"]	= 0,	-- Shiny Red Apple
	["6299"]	= 0,	-- Sickly Looking Fish (Fished)
	["787"]		= 0,	-- Slitherskin Mackerel
	["4656"]	= 0,	-- Small Pumpkin
	["4540"]	= 0,	-- Tough Hunk of Bread
	["117"]		= 0,	-- Tough Jerky
	["414"]		= 5,	-- Dalaran Sharp
	["12238"]	= 5,	-- Darkshore Grouper
	["4541"]	= 5,	-- Freshly Baked Bread
	["2287"]	= 5,	-- Haunch of Meat
	["17406"]	= 5,	-- Holiday Cheesewheel
	["4592"]	= 5,	-- Longjaw Mud Snapper
	["4605"]	= 5,	-- Red-speckled Mushroom
	["4537"]	= 5,	-- Tel'Abim Banana
	["4593"]	= 15,	-- Bristle Whisker Catfish
	["422"]		= 15,	-- Dwarven Mild
	["4542"]	= 15,	-- Moist Cornbread
	["3770"]	= 15,	-- Mutton Chop
	["4538"]	= 15,	-- Snapvine Watermelon
	["4606"]	= 15,	-- Spongy Morel
	["4607"]	= 25,	-- Delicious Cave Mold
	["4539"]	= 25,	-- Goldenbark Apple
	["17407"]	= 25,	-- Graccu's Homemade Meat Pie
	["8364"]	= 25,	-- Mithril Head Trout
	["4544"]	= 25,	-- Mulgore Spice Bread
	["4594"]	= 25,	-- Rockscale Cod
	["1707"]	= 25,	-- Stormwind Brie
	["3771"]	= 25,	-- Wild Hog Shank
	["4599"]	= 35,	-- Cured Ham Steak
	["3927"]	= 35,	-- Fine Aged Cheddar
	["4602"]	= 35,	-- Moon Harvest Pumpkin
	["4608"]	= 35,	-- Raw Black Truffle
	["4601"]	= 35,	-- Soft Banana Bread
	["6887"]	= 35,	-- Spotted Yellowtail
	["13755"]	= 35,	-- Winter Squid (Fished)
	["21215"]	= 40,	-- Graccu's Mince Meat Fruitcake
	["8932"]	= 45,	-- Alterac Swiss
	["8953"]	= 45,	-- Deep Fried Plantains
	["8948"]	= 45,	-- Dried King Bolete
	["11444"]	= 45,	-- Grim Guzzler Boar
	["8950"]	= 45,	-- Homemade Cherry Pie
	["13893"]	= 45,	-- Large Raw Mightfish (Fishing)
	["11415"]	= 45,	-- Mixed Berries
	["8952"]	= 45,	-- Roasted Quail
	["18255"]	= 45,	-- Runn Tum Tuber

	-- Burning Crusade --
	["20857"]	= 0,	-- Honey Bread
	["27857"]	= 55,	-- Garadar Sharp
	["27855"]	= 55,	-- Mag'har Grainbread
	["27856"]	= 55,	-- Skethyl Berries
	["30610"]	= 55,	-- Smoked Black Bear Meat
	["27854"]	= 55,	-- Smoked Talbuk Venison
	["30458"]	= 55,	-- Stromgarde Muenster
	["27858"]	= 55,	-- Sunspring Carp
	["27859"]	= 55,	-- Zangar Caps
	["29448"]	= 65,	-- Mag'har Mild Cheese (Pickpocketed)
	["29453"]	= 65,	-- Sporeggar Mushroom
	["29450"]	= 65,	-- Telaaari Grapes (Pickpocketed)

	-- Wrath of the Lich King --
	["33449"]	= 65,	-- Crusty Flatbread
	["37452"]	= 65,	-- Fatty Bluefin (Pickpocketed)
	["33451"]	= 65,	-- Fillet of Icefin
	["37252"]	= 65,	-- Frostberries
	["33452"]	= 65,	-- Honey Spiced Lichen
	["33454"]	= 65,	-- Salted Venison
	["33443"]	= 65,	-- Sour Goat Cheese
	["35952"]	= 75,	-- Briny Hardcheese (Pickpocketed)
	["35953"]	= 75,	-- Mead Basted Caribou (Pickpocketed)
	["35951"]	= 75,	-- Poached Emperor Salmon
	["35948"]	= 75,	-- Savory Snowplum
	["40202"]	= 75,	-- Sizzling Grizzly Flank
	["35947"]	= 75,	-- Sparkling Frostcap

	-- Cataclysm --
	["58260"]	= 80,	-- Pine Nut Bread
	["58268"]	= 80,	-- Roasted Beef
	["58262"]	= 80,	-- Sliced Raw Billfish
	["58258"]	= 80,	-- Smoked String Cheese
	["58266"]	= 80,	-- Violet Morel
	["58261"]	= 85,	-- Buttery Wheat Roll
	["58259"]	= 85,	-- Highland Sheep Cheese

	-- Mists of Pandaria --
	["81400"]	= 85,	-- Pounded Rice Cake
	["81401"]	= 85,	-- Yak Cheese Curds
	["81402"]	= 85,	-- Toasted Fish Jerky
	["81403"]	= 85,	-- Dried Peaches
	["81404"]	= 85,	-- Dried Needle Mushrooms
	["81405"]	= 85,	-- Boiled Silkworm Pupa
	["81406"]	= 85,	-- Roasted Barley Tea
	["81407"]	= 85,	-- Four Wind Soju
	["81408"]	= 90,	-- Red Bean Bun
	["81409"]	= 90,	-- Tangy Yogurt
	["81411"]	= 90,	-- Peach Pie
	["81412"]	= 90,	-- Blanched Needle Mushrooms
	["81413"]	= 90,	-- Skewered Peanut Chicken
	["81414"]	= 90,	-- Pearl Milk Tea

	-- Warlords of Draenor - http://www.wowhead.com/items?filter=166:86;6:3;0:0 --
	["111431"]	= 91,	-- Hearty Elekk Steak
	["111433"]	= 91,	-- Blackrock Ham
	["111434"]	= 91,	-- Pan-Seared Talbuk
	["111436"]	= 91,	-- Braised Riverbeast
	["111437"]	= 91,	-- Rylak Crepes
	["111438"]	= 91,	-- Clefthoof Sausages
	["111439"]	= 91,	-- Steamed Scorpion
	["111441"]	= 91,	-- Grilled Gulper
	["111442"]	= 91,	-- Sturgeon Stew
	["111444"]	= 91,	-- Fat Sleeper Cakes
	["111445"]	= 91,	-- Fiery Calamari
	["111446"]	= 91,	-- Skulker Chowder
	["111447"]	= 91,	-- Talador Surf and Turf
	["111449"]	= 91,	-- Blackrock Barbecue
	["111450"]	= 91,	-- Frosty Stew
	["111452"]	= 91,	-- Sleeper Surprise
	["111453"]	= 91,	-- Calamari Crepes
	["111454"]	= 91,	-- Gorgrond Chowder
	["111455"]	= 90,	-- Saberfish Broth
	["111456"]	= 90,	-- Grilled Saberfish
	["111457"]	= 91,	-- Feast of Blood
	["111458"]	= 91,	-- Feast of the Waters
	["122343"]	= 91,	-- Sleeper Sushi
	["122344"]	= 91,	-- Salty Squid Roll
	["122345"]	= 91,	-- Pickled Eel
	["122346"]	= 91,	-- Jumbo Sea Dog
	["122347"]	= 91,	-- Whiptail Fillet
	["122348"]	= 91,	-- Buttered Sturgeon
	["128498"]	= 90,	-- Fel Eggs and Ham
	["126934"]	= 1,	-- Lemon Herb Filet
	["126935"]	= 1,	-- Fancy Darkmoon Feast
	["126936"]	= 1,	-- Sugar-Crusted Fish Feast

	-- Legion - http://www.wowhead.com/items?filter=166:86;7:3;0:0 --
	["133565"]	= 101,	-- Leybeque Ribs
	["133566"]	= 101,	-- Suramar Surf and Turf
	["133567"]	= 101,	-- Barracuda Mrglgagh
	["133568"]	= 101,	-- Koi-Scented Stormray
	["133569"]	= 101,	-- Drogbar-Style Salmon
	["133570"]	= 101,	-- The Hungry Magister
	["133571"]	= 101,	-- Azshari Salad
	["133572"]	= 101,	-- Nightborne Delicacy Platter
	["133573"]	= 101,	-- Seed-Battered Fish Plate
	["133574"]	= 101,	-- Fishbrul Special
	["133575"]	= 101,	-- Dried Mackerel Strips
	["133576"]	= 101,	-- Bear Tartare
	["133577"]	= 101,	-- Fighter Chow
	["133578"]	= 101,	-- Hearty Feast
	["133579"]	= 101,	-- Lavish Suramar Feast
	["133681"]	= 101,	-- Crispy Bacon
	["133557"]	= 101,	-- Salt & Pepper Shank
	["133561"]	= 101,	-- Deep-Fried Mossgill
	["133562"]	= 101,	-- Pickled Stormray
	["133563"]	= 101,	-- Faronaar Fizz
	["133564"]	= 101,	-- Spiced Rib Roast
}
