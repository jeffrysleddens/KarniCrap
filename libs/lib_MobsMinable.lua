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

mobsMinableList	= {
	-- Classic --
	["2754"]	= "Anathemus",
	["11746"]	= "Desert Rumbler",
	["2611"]	= "Fozruk",
	["1731"]	= "Goblin Craftsman",
	["7032"]	= "Greater Obsidian Elemental",
	["5854"]	= "Heavy War Golem",
	["5855"]	= "Magma Elemental",
	["7031"]	= "Obsidian Elemental",
	["8400"]	= "Obsidion",
	["92"]		= "Rock Elemental",
	["2592"]	= "Rumbling Exile",
	["2723"]	= "Stone Golem",
	["6560"]	= "Stone Guardian",
	["5853"]	= "Tempered War Golem",
	["2763"]	= "Thenan",
	["11783"]	= "Theradrim Shardling",
	["7039"]	= "War Reaver",

	-- Burning Crusade --
	["18343"]	= "Tavarok",
	["19940"]	= "Apex",
	["22275"]	= "Apexis Guardian",
	["20202"]	= "Cragskaar",
	["19823"]	= "Crazed Colossus",
	["21181"]	= "Cyrukh the Firelord",
	["18062"]	= "Enraged Crusher",
	["21050"]	= "Enraged Earth Spirit",
	["18886"]	= "Farahlon Breaker",
	["18885"]	= "Farahlon Giant",
	["18182"]	= "Gurok the Usurper",
	["23165"]	= "Karrog",
	["18690"]	= "Morcrush",
	["21844"]	= "Mountain Colossus", --Not categorized on Wowhead as Minable
	["20772"]	= "Netherock",
	["19188"]	= "Raging Colossus",
	["22313"]	= "Rumbling Earth-Heart",
	["17157"]	= "Shattered Rumbler",
	["19824"]	= "Son of Corok",
	["18881"]	= "Sundered Rumbler",
	["20498"]	= "Sundered Shard",
	["18882"]	= "Sundered Thunderer",
	["17156"]	= "Tortured Earth Spirit",

	-- Wrath of the Lich King --
	["29307"]	= "Drakkari Colossus",
	["27977"]	= "Krystallus",
	["26794"]	= "Ormorok the Tree-Shaper",
	["30160"]	= "Brittle Revenant",
	["34197"]	= "Chamber Overseer",
	["26316"]	= "Crystalline Ice Elemental",
	["26291"]	= "Crystalline Ice Giant",
	["29832"]	= "Drakkari Golem",
	["30876"]	= "Earthbound Revenant",
	["30040"]	= "Eternal Watcher",
	["34085"]	= "Forge Construct",
	["28411"]	= "Frozen Earth",
	["28597"]	= "Guardian of Zim'Rhuk",
	["34190"]	= "Hardened Iron Golem",
	["26283"]	= "Ice Revenant",
	["29844"]	= "Icebound Revenant",
	["30053"]	= "Icebound Revenant",
	["29436"]	= "Icetouched Earthrager",
	["24271"]	= "Iron Rune Golem",
	["24316"]	= "Iron Rune Sentinel",
	["26290"]	= "Jotun",
	["29124"]	= "Lifeblood Elemental",
	["34086"]	= "Magma Rager",
	["34069"]	= "Molten Colossus",
	["28840"]	= "Overlook Sentry",
	["29013"]	= "Perch Guardian",
	["34196"]	= "Rune Etched Sentry",
	["26417"]	= "Runed Giant",
	["24329"]	= "Runed Stone Giant",
	["26284"]	= "Runic Battle Golem",
	["26347"]	= "Runic War Golem",
	["28069"]	= "Sholazar Guardian",
	["23725"]	= "Stone Giant",
	["33722"]	= "Storm Tempered Keeper",
	["33699"]	= "Storm Tempered Keeper",
	["28877"]	= "Stormwatcher",
	["26406"]	= "The Anvil",
	["34134"]	= "Winter Revenant",
	["34135"]	= "Winter Rumbler",
	["32447"]	= "Zul'drak Sentinel",

	-- Cataclysm --
	["36845"]	= "Agitated Earth Spirit",
	["35759"]	= "Balboa",
	["40972"]	= "Corrupted Cliff Giant",
	["37553"]	= "Disturbed Earth Elemental",
	["33083"]	= "Enraged Earth Elemental",
	["50258"]	= "Frostmaul Tumbler",
	["48960"]	= "Frostshard Rumbler",
	["39595"]	= "Furious Earthguard",
	["42766"]	= "Gorged Gyreworm",
	["44259"]	= "Gorged Gyreworm",
	["44257"]	= "Gyreworm",
	["43258"]	= "Lodestone Elemental",
	["41389"]	= "Paleolithic Elemental",
	["41993"]	= "Raging Earth Elemental",
	["38916"]	= "Sandstone Earthen",
	["38914"]	= "Sandstone Golem",

	-- Mists of Pandaria --
	["65450"]	= "Ancient Guardian",
	["61174"]	= "Cursed Jade",
	["65496"]	= "Dread Fearbringer",
	["59157"]	= "Granite Quilen",
	["56404"]	= "Greenstone Gorger",
	["61159"]	= "Greenstone Terror",
	["65169"]	= "Jade Colossus",
	["55236"]	= "Jade Guardian",
	["65229"]	= "Kypa'rak",
	["65231"]	= "Kypari Crawler",
	["63007"]	= "Kyparite",
	["65432"]	= "Kyparite Pulverizer",
	["59156"]	= "Mogu Effigy",
	["63447"]	= "Mogu Statue",
	["63674"]	= "Mogu Statue",
	["62324"]	= "Norvakess",
	["61565"]	= "Quilen Statue",
	["62254"]	= "Quilen Watcher",
	["65824"]	= "Shao-Tien Behemoth",
	["63155"]	= "Stone Guardian",
	["63605"]	= "Stonebound Watcher",
	["60573"]	= "Terracotta Defender",
	["63510"]	= "Wulon",

	-- Warlords of Draenor --
	["74475"]	= "Magmolatus",
	["75209"]	= "Molten Earth Elemental",
	["77504"]	= "Slag Behemoth",
	["78327"]	= "Crystal Rager",
	["78372"]	= "An'dure the Awakened",
	["79924"]	= "Living Apexis Shard",
	["79926"]	= "Glowing Draenite Crystal",
	["80072"]	= "Iridium Geode",
	["80144"]	= "Raging Crusher",
	["80374"]	= "Unstable Earth Guardian",
	["80382"]	= "Unstable Earth Spirit",
	["86071"]	= "Rokkaa",
	["86072"]	= "Oro",
	["86073"]	= "Lokk",
	["86439"]	= "Earthen Fury",

	-- Legion - http://www.wowhead.com/npcs?filter=39:16;7:1;0:0 --
	["108856"]	= "Agitated Stonewarden",
	["106630"]	= "Burrowing Leyworm",
	["98957"]	= "Coldscale Deatheye",
	["94507"]	= "Enraged Ambershard",
	["102468"]	= "Enraged Umbralshard",
	["101868"]	= "Felfire Basilisk",
	["114113"]	= "Felslate Basilisk",
	["104895"]	= "Felslate Basilisk",
	["99764"]	= "Felsoul Crusher",
	["93619"]	= "Infernal Brutalizer",
	["90803"]	= "Infernal Lord",
	["91128"]	= "Lagoon Basilisk",
	["99793"]	= "Leyscale Manalisk",
	["103514"]	= "Leystone Basilisk",
	["104877"]	= "Leystone Basilisk",
	["98653"]	= "Manaspine Basilisk",
	["107328"]	= "Netherflame Infernal",
	["93344"]	= "Runebound Stonewarden",
	["109338"]	= "Sorcerite",
	["101581"]	= "Tanzanite Borer",
	["101577"]	= "Tanzanite Shatterer",
	["106665"]	= "Ualair",
	["93110"]	= "Vault Keeper",
	["101438"]	= "Vileshard Chunk",
	["91000"]	= "Vileshard Hulk",
	["95916"]	= "Violent Crageater",
	["97266"]	= "Wrath of Dargrul",
	["94509"]	= "Wrathshard",
}
