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

-- List of materials usable for cooking
-- Might also need list of foods created?

cookingList = {
	-- Classic --
	["12808"]	= "Essence of Undeath",
	["5051"]	= "Dig Rat",
	["17196"]	= "Holiday Spirits",
	["17194"]	= "Holiday Spices",
	["12223"]	= "Meaty Bat Wing",
	["6889"]	= "Small Egg",
	["6303"]	= "Raw Slitherskin Mackerel",
	["6291"]	= "Raw Brilliant Smallfish",
	["5465"]	= "Small Spider Leg",
	["2886"]	= "Crag Boar Rib",
	["2678"]	= "Mild Spices",
	["2672"]	= "Stringy Wolf Meat",
	["769"]		= "Chunk of Boar Meat",
	["159"]		= "Refreshing Spring Water",
	["5466"]	= "Scorpid Stinger",
	["5469"]	= "Strider Meat",
	["5467"]	= "Kodo Meat",
	["2673"]	= "Coyote Meat",
	["785"]		= "Mageroyal",
	["3173"]	= "Bear Meat",
	["723"]		= "Goretusk Liver",
	["2675"]	= "Crawler Claw",
	["2674"]	= "Crawler Meat",
	["5503"]	= "Clam Meat",
	["2924"]	= "Crocolisk Meat",
	["2677"]	= "Boar Ribs",
	["6522"]	= "Deviate Fish",
	["6361"]	= "Raw Rainbow Fin Albacore",
	["6317"]	= "Raw Loch Frenzy",
	["6289"]	= "Raw Longjaw Mud Snapper",
	["5468"]	= "Soft Frenzy Flesh",
	["2596"]	= "Skin of Dwarven Stout",
	["2593"]	= "Flask of Port",
	["2452"]	= "Swiftthistle",
	["1179"]	= "Ice Cold Milk",
	["1080"]	= "Tough Condor Meat",
	["1468"]	= "Murloc Fin",
	["1015"]	= "Lean Wolf Flank",
	["21071"]	= "Raw Sagefish",
	["3730"]	= "Big Bear Meat",
	["5470"]	= "Thunder Lizard Tail",
	["3685"]	= "Raptor Egg",
	["5504"]	= "Tangy Clam Meat",
	["5471"]	= "Stag Meat",
	["3731"]	= "Lion Meat",
	["3667"]	= "Tender Crocolisk Meat",
	["6308"]	= "Raw Bristle Whisker Catfish",
	["4402"]	= "Small Flame Sac",
	["2594"]	= "Flagon of Mead",
	["2251"]	= "Gooey Spider Leg",
	["12203"]	= "Red Wolf Meat",
	["12202"]	= "Tiger Meat",
	["12184"]	= "Raptor Flesh",
	["12037"]	= "Mystery Meat",
	["3712"]	= "Turtle Meat",
	["3821"]	= "Goldthorn",
	["12204"]	= "Heavy Kodo Meat",
	["8365"]	= "Raw Mithril Head Trout",
	["6362"]	= "Raw Rockscale Cod",
	["4655"]	= "Giant Clam Meat",
	["3404"]	= "Buzzard Wing",
	["21153"]	= "Raw Greater Sagefish",
	["12208"]	= "Tender Wolf Meat",
	["12206"]	= "Tender Crab Meat",
	["12205"]	= "White Spider Meat",
	["8150"]	= "Deeprock Salt",
	["9061"]	= "Goblin Rocket Fuel",
	["13760"]	= "Raw Sunscale Salmon",
	["13759"]	= "Raw Nightfin Snapper",
	["13758"]	= "Raw Redgill",
	["13757"]	= "Lightning Eel",
	["13756"]	= "Raw Summer Bass",
	["13755"]	= "Winter Squid",
	["13754"]	= "Raw Glossy Mightfish",
	["12207"]	= "Giant Egg",
	["7974"]	= "Zesty Clam Meat",
	["4603"]	= "Raw Spotted Yellowtail",
	["20424"]	= "Sandworm Meat",
	["18255"]	= "Runn Tum Tuber",
	["13893"]	= "Large Raw Mightfish",
	["13889"]	= "Raw Whitescale Salmon",
	["13888"]	= "Darkclaw Lobster",
	["21024"]	= "Chimaerok Tenderloin",

	-- Burning Crusade --
	["23676"]	= "Moongraze Stag Tenderloin",
	["30817"]	= "Simple Flour",
	["30816"]	= "Spice Bread",
	["27669"]	= "Bat Flesh",
	["27668"]	= "Lynx Meat",
	["22644"]	= "Crunchy Spider Leg",
	["34412"]	= "Sparkling Apple Cider",
	["35562"]	= "Bear Flank",
	["31671"]	= "Serpent Flesh",
	["31670"]	= "Raptor Ribs",
	["27682"]	= "Talbuk Venison",
	["27681"]	= "Warped Flesh",
	["27678"]	= "Clefthoof Meat",
	["27677"]	= "Chunk o' Basilisk",
	["27676"]	= "Strange Spores",
	["27674"]	= "Ravager Flesh",
	["27671"]	= "Buzzard Meat",
	["27516"]	= "Enormous Barbed Gill Trout",
	["27515"]	= "Huge Spotted Feltail",
	["27439"]	= "Furious Crawdad",
	["27438"]	= "Golden Darter",
	["27437"]	= "Icefin Bluefish",
	["27435"]	= "Figluster's Mudfish",
	["27429"]	= "Zangarian Sporefish",
	["27425"]	= "Spotted Feltail",
	["27422"]	= "Barbed Gill Trout",
	["33824"]	= "Crescent-Tail Skullfish",
	["33823"]	= "Bloodfin Catfish",
	["24477"]	= "Jaggal Clam Meat",
	["22577"]	= "Mote of Shadow",

	-- Wrath of the Lich King --
	["44853"]	= "Honey",
	["44834"]	= "Wild Turkey",
	["46797"]	= "Mulgore Sweet Potato",
	["46796"]	= "Ripe Tirisfal Pumpkin",
	["46793"]	= "Tangy Southfury Cranberries",
	["46784"]	= "Ripe Elwynn Pumpkin",
	["44855"]	= "Teldrassil Sweet Potato",
	["44854"]	= "Tangy Wetland Cranberries",
	["44835"]	= "Autumnal Herbs",
	["43501"]	= "Northern Egg",
	["43013"]	= "Chilled Meat",
	["43012"]	= "Rhino Meat",
	["43011"]	= "Worg Haunch",
	["43010"]	= "Worm Meat",
	["43009"]	= "Shoveltusk Flank",
	["41813"]	= "Nettlefish",
	["41812"]	= "Barrelhead Goby",
	["41810"]	= "Fangtooth Herring",
	["41809"]	= "Glacial Salmon",
	["41808"]	= "Bonescale Snapper",
	["41807"]	= "Dragonfin Angelfish",
	["41806"]	= "Musselback Sculpin",
	["41805"]	= "Borean Man O' War",
	["41803"]	= "Rockfin Grouper",
	["41802"]	= "Imperial Manta Ray",
	["41801"]	= "Moonglow Cuttlefish",
	["41800"]	= "Deep Sea Monsterbelly",
	["34736"]	= "Chunk o' Mammoth",
	["36782"]	= "Succulent Clam Meat",
	["35949"]	= "Tundra Berries",
	["43007"]	= "Northern Spices",
	["35948"]	= "Savory Snowplum",

	-- Cataclysm --
	["67229"]	= "Stag Flank",
	["58278"]	= "Tropical Sunfruit",
	["58274"]	= "Fresh Water",
	["62791"]	= "Blood Shrimp",
	["62788"]	= "Dry Yeast",
	["62787"]	= "Noble Hops",
	["62786"]	= "Cocoa Beans",
	["62785"]	= "Delicate Wing",
	["62784"]	= "Crocolisk Tail",
	["62783"]	= "Basilisk \"Liver\"",
	["62782"]	= "Dragon Flank",
	["62781"]	= "Giant Turtle Tongue",
	["62780"]	= "Snake Eye",
	["62779"]	= "Monstrous Claw",
	["62778"]	= "Toughened Flesh",
	["60838"]	= "Mysterious Fortune Card",
	["58265"]	= "Highland Pomegranate",

	-- Mists of Pandaria --
	["85506"]	= "Viseclaw Meat",
	["74833"]	= "Raw Tiger Steak",
	["74834"]	= "Mushan Ribs",
	["74837"]	= "Raw Turtle Meat",
	["74838"]	= "Raw Crab Meat",
	["74839"]	= "Wildfowl Breast",
	["74840"]	= "Green Cabbage",
	["74841"]	= "Juicycrunch Carrot",
	["74842"]	= "Mogu Pumpkin",
	["74843"]	= "Scallions",
	["74844"]	= "Red Blossom Leek",
	["74846"]	= "Witchberries",
	["74847"]	= "Jade Squash",
	["74848"]	= "Striped Melon",
	["74849"]	= "Pink Turnip",
	["74850"]	= "White Turnip",
	["75014"]	= "Raw Crocolisk Belly",

	-- Warlords of Draenor --
	["109131"]	= "Raw Clefthoof Meat",
	["109132"]	= "Raw Talbuk Meat",
	["109133"]	= "Rylak Egg",
	["109134"]	= "Raw Elekk Meat",
	["109135"]	= "Raw Riverbeast Meat",
	["109136"]	= "Raw Boar Meat",
	["109137"]	= "Crescent Saberfish Flesh",
	["109138"]	= "Jawless Skulker Flesh",
	["109139"]	= "Fat Sleeper Flesh",
	["109140"]	= "Blind Lake Sturgeon Flesh",
	["109141"]	= "Fire Ammonite Tentacle",
	["109142"]	= "Sea Scorpion Segment",
	["109143"]	= "Abyssal Gulper Eel Flesh",
	["109144"]	= "Blackwater Whiptail Flesh",
	["111436"]	= "Braised Riverbeast",

	-- Legion - http://www.wowhead.com/trade-goods?filter=166:87;7:3;0:0 --
	["124101"]	= "Aethril",
	["124102"]	= "Dreamleaf",
	["124103"]	= "Foxflower",
	["124104"]	= "Fjarnskaggl",
	["124105"]	= "Starlight Rose",
	["124107"]	= "Cursed Queenfish",
	["124108"]	= "Mossgill Perch",
	["124109"]	= "Highmountain Salmon",
	["124110"]	= "Stormray",
	["124111"]	= "Runescale Koi",
	["124112"]	= "Black Barracuda",
	["124117"]	= "Lean Shank",
	["124118"]	= "Fatty Bearsteak",
	["124119"]	= "Big Gamy Ribs",
	["124120"]	= "Leyblood",
	["124121"]	= "Wildfowl Egg",
	["128304"]	= "Yseralline Seed",
	["133607"]	= "Silver Mackerel",
	["133680"]	= "Slice of Bacon",
	["133588"]	= "Flaked Sea Salt",
	["133589"]	= "Dalapeño Pepper",
	["133590"]	= "Muskenbutter",
	["133591"]	= "River Onion",
	["133592"]	= "Stonedark Snail",
	["133593"]	= "Royal Olive",
	["129100"]	= "Gem Chip",
}
