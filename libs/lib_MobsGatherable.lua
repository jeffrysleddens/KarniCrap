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

mobsGatherableList = {
	-- Classic --
	["12219"]	= "Barbed Lasher",
	["6509"]	= "Bloodpetal Lasher",
	["6512"]	= "Bloodpetal Trapper",
	["12220"]	= "Constrictor Vine",
	["3834"]	= "Crazed Ancient",
	["13141"]	= "Deeprot Stomper",
	["13142"]	= "Deeprot Tangler",
	["2030"]	= "Elder Timberling",
	["7139"]	= "Irontree Stomper",
	["2166"]	= "Oakenscowl",
	["2022"]	= "Timberling",
	["2029"]	= "Timberling Mire Beast",
	["2027"]	= "Timberling Trampler",
	["7100"]	= "Warpwood Moss Flayer",
	["3919"]	= "Withered Ancient",
	["4382"]	= "Withervine Creeper",
	["4385"]	= "Withervine Rager",
	-- Burning Crusade --
	["17770"]	= "Hungarfen",
	["17977"]	= "Warp Splinter",
	["17723"]	= "Bog Giant",
	["18127"]	= "Bog Lord",
	["21694"]	= "Bog Overlord",
	["20774"]	= "Farahlon Lasher",
	["19734"]	= "Fungal Giant",
	["22095"]	= "Infested Root-Walker",
	["21040"]	= "Outraged Raven's Wood Sapling",
	["21326"]	= "Raven's Wood Leafbeard",
	["21325"]	= "Raven's Wood Stonebark",
	["22307"]	= "Rotting Forest-Rager",
	["19519"]	= "Starving Bog Lord",
	["18125"]	= "Starving Fungal Giant",
	["21023"]	= "Stronglimb Deeproot",
	["23029"]	= "Talonsworn Forest-Rager",
	["21251"]	= "Underbog Colossus",
	["17734"]	= "Underbog Lord",
	["17725"]	= "Underbog Lurker",
	["17871"]	= "Underbog Shambler",
	["19402"]	= "Withered Bog Lord",
	["18124"]	= "Withered Giant",
	-- Wrath of the Lich King --
	["30258"]	= "Amanitar",
	["31229"]	= "Ancient Watcher",
	["26333"]	= "Corrupted Lothalor Ancient",
	["33354"]	= "Corrupted Servitor",
	["26782"]	= "Crystalline Keeper",
	["26792"]	= "Crystalline Protector",
	["32915"]	= "Elder Brightleaf",
	["32913"]	= "Elder Ironbranch",
	["32914"]	= "Elder Stonebark",
	["27254"]	= "Emerald Lasher",
	["33431"]	= "Forest Swarmer",
	["25709"]	= "Glacial Ancient",
	["33430"]	= "Guardian Lasher",
	["30845"]	= "Living Lasher",
	["25707"]	= "Magic-bound Ancient",
	["33525"]	= "Mangrove Ent",
	["34300"]	= "Mature Lasher",
	["28323"]	= "Mossy Rampager",
	["32357"]	= "Old Crystalbark",
	["26417"]	= "Runed Giant",
	["30329"]	= "Savage Cave Beast",
	["29036"]	= "Servant of Freya",
	["23874"]	= "Thornvine Creeper",
	["30861"]	= "Unbound Ancient",
	["26421"]	= "Woodlands Walker",
	-- Cataclysm --
	["44489"]	= "Corn Stalker",
	["43732"]	= "Corpseweed",
	["45119"]	= "Corrupted Darkwood Treant",
	["45118"]	= "Darkwood Treant",
	["44598"]	= "Desert Bloom",
	["45125"]	= "Felspore Bog Lord",
	["48952"]	= "Frostleaf Treant",
	["37093"]	= "Lashvine",
	["41496"]	= "Marsh Lasher",
	["41424"]	= "Mouldering Mirebeast",
	["37092"]	= "Outgrowth",
	["33688"]	= "Raging Ancient",
	["44569"]	= "Sand Lasher",
	["44487"]	= "Thrashing Pumpkin",
	["36062"]	= "Uprooted Lasher",
	["40066"]	= "Wailing Weed",
	-- Mists of Pandaria --
	["61183"]	= "Belligerent Blossom",
	["61414"]	= "Doom Bloom",
	["63467"]	= "Enraged Treant",
	["59766"]	= "Hollow Bloom",
	["66602"]	= "Petulant Pumpkin",
	["55640"]	= "Thornbranch Scamp",
	-- Warlords of Draenor --
	["72785"]	= "Twisted Ancient",
	["74175"]	= "Gloomshade Fungi",
	["75492"]	= "Venomshade",
	["79333"]	= "Encroaching Giant",
	["79335"]	= "Invasive Shambler",
	["80699"]	= "Mandragora Lifedrinker",
	["80752"]	= "Blooming Mandragora",
	["81864"]	= "Dreadpetal",
	["81983"]	= "Verdant Mandragora",
	["81984"]	= "Gnarlroot",
	["82243"]	= "Fungal Hulk",
	["82265"]	= "Spore Shambler",
	["82318"]	= "Umbraspore Giant",
	["82326"]	= "Ba'ruun",
	["82378"]	= "Moonbark Ancient",
	["82722"]	= "Putrid Mandragora",
	["82800"]	= "Ignited Ancient",
	["82805"]	= "Smoldering Ancient",
	["83530"]	= "Hyacinth Mandragora",
	["84391"]	= "Crimson Mandragora",
	["84654"]	= "Spiteleaf Spitter",
	["84656"]	= "Spiteleaf Stabber",
	["84657"]	= "Spiteleaf Mender",
	["84706"]	= "Spore Giant",
	["84726"]	= "Spore Giant",
	["85760"]	= "Blooming Mandragora",
	["86260"]	= "Wild Mandragora",
	["88521"]	= "Bloodroot Ancient",
	["88678"]	= "Gnarlwood Ancient"
}
