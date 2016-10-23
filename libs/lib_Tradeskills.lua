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

tradeskillList	= {
-- Disenchant
	[13262]		= "Disenchant", 	-- No levels
-- Engineering
	[4036]		= "Engineering", 	-- Apprentice
	[4037]		= "Engineering", 	-- Journeyman
	[4038]		= "Engineering", 	-- Expert
	[12656]		= "Engineering", 	-- Artisan
	[30350]		= "Engineering", 	-- Master
	[51306]		= "Engineering", 	-- Grand Master
	[82774]		= "Engineering", 	-- Illustrious
	[110403]	= "Engineering",	-- Zen Master
	[158739]	= "Engineering",	-- Draenor Master
	[195112]	= "Engineering",	-- Legion Master
	[49383]		= "Engineering", 	-- Corpses
-- Herb Gathering
	[2366]		= "Herb Gathering",	-- Apprentice
	[2368]		= "Herb Gathering",	-- Journeyman
	[3570]		= "Herb Gathering",	-- Expert
	[11993]		= "Herb Gathering",	-- Artisan
	[28695]		= "Herb Gathering",	-- Master
	[50300]		= "Herb Gathering",	-- Grand Master
	[74519]		= "Herb Gathering",	-- Illustrious
	[110413]	= "Herb Gathering",	-- Zen Master
	[158745]	= "Herb Gathering",	-- Draenor Master
	[195114]	= "Herb Gathering",	-- Legion Herbalism
-- Mining
	[2575] 		= "Mining", 		-- Apprentice
	[2576] 		= "Mining", 		-- Journeyman
	[3564] 		= "Mining", 		-- Expert
	[10248]		= "Mining", 		-- Artisan
	[29354]		= "Mining", 		-- Master
	[50310]		= "Mining", 		-- Grand Master
	[74517]		= "Mining", 		-- Illustrious
	[102161]	= "Mining",		-- Zen Master
	[158754]	= "Mining",		-- Draenor Master
	[195122]	= "Mining",		-- Legion Master
-- Skinning
	[8613]		= "Skinning", 		-- Apprentice
	[8617]		= "Skinning", 		-- Journeyman
	[8618]		= "Skinning",		-- Expert
	[10768]		= "Skinning", 		-- Artisan
	[32678]		= "Skinning", 		-- Master
	[50305]		= "Skinning", 		-- Grand Master
	[74522]		= "Skinning", 		-- Illustrious
	[102216]	= "Skinning",		-- Zen Master
	[158756]	= "Skinning",		-- Draenor Master
	[195125]	= "Skinning",		-- Legion Skinning
-- Milling
	[51005]		= "Milling", 		-- No levels
-- Prospecting
	[31252]		= "Prospecting",	-- No levels
-- Fishing (Should this one count as a tradeskill?)
--	[7620] 		= "Fishing", 		-- Apprentice
--	[7731] 		= "Fishing", 		-- Journeyman
--	[7732] 		= "Fishing", 		-- Expert
--	[18248]		= "Fishing", 		-- Artisan
--	[33095]		= "Fishing", 		-- Master
--	[51294]		= "Fishing", 		-- Grand Master
--	[88868]		= "Fishing", 		-- Illustrious
--	[110410]	= "Fishing",		-- Zen Master
--	[158743]	= "Fishing",		-- Draenor Master
-- Archaeology (Not sure if this triggers a loot window)
--	[78670]		= "Archaeology", 	-- Apprentice
--	[88961]		= "Archaeology", 	-- Journeyman
--	[89718]		= "Archaeology", 	-- Expert
--	[89719]		= "Archaeology", 	-- Artisan
--	[89720]		= "Archaeology", 	-- Master
--	[89721]		= "Archaeology", 	-- Grand Master
--	[89722]		= "Archaeology", 	-- Illustrious
--	[110393]	= "Archaeology",	-- Zen Master
--	[158762]	= "Archaeology",	-- Draenor Master
-- Alchemy (No loot window)
--	[2259] 		= "Alchemy", 		-- Apprentice
--	[3101] 		= "Alchemy", 		-- Journeyman
--	[3464] 		= "Alchemy", 		-- Expert
--	[11611]		= "Alchemy", 		-- Artisan
--	[28596]		= "Alchemy", 		-- Master
--	[51304]		= "Alchemy", 		-- Grand Master
--	[80731]		= "Alchemy", 		-- Illustrious
--	[105206]	= "Alchemy",		-- Zen Master
--	[156606]	= "Alchemy",		-- Draenor Master
--	[195095]	= "Alchemy",		-- Legion Master
-- Blacksmithing (No loot window)
--	[2018]		= "Blacksmithing", 	-- Apprentice
--	[3100]		= "Blacksmithing", 	-- Journeyman
--	[3538]		= "Blacksmithing", 	-- Expert
--	[9785]		= "Blacksmithing", 	-- Artisan
--	[29844]		= "Blacksmithing", 	-- Master
--	[51300]		= "Blacksmithing", 	-- Grand Master
--	[76666]		= "Blacksmithing", 	-- Illustrious
--	[110396]	= "Blacksmithing",	-- Zen Master
--	[158737]	= "Blacksmithing",	-- Draenor Master
--	[195057]	= "Blacksmithing",	-- Legion Blacksmithing
-- Enchanting (No loot window)
--	[7411]		= "Enchanting", 	-- Apprentice
--	[7412]		= "Enchanting", 	-- Journeyman
--	[7413]		= "Enchanting", 	-- Expert
--	[13920]		= "Enchanting", 	-- Artisan
--	[28029]		= "Enchanting", 	-- Master
--	[51313]		= "Enchanting", 	-- Grand Master
--	[74258]		= "Enchanting", 	-- Illustrious
--	[110400]	= "Enchanting",		-- Zen Master
--	[158716]	= "Enchanting",		-- Draenor Master
--	[195096]	= "Enchanting",		-- Legion Enchanting
-- Inscription (Not sure if this triggers a loot window)
--	[45357]		= "Inscription", 	-- Apprentice
--	[45358]		= "Inscription", 	-- Journeyman
--	[45359]		= "Inscription", 	-- Expert
--	[45360]		= "Inscription", 	-- Artisan
--	[45361]		= "Inscription", 	-- Master
--	[45363]		= "Inscription", 	-- Grand Master
--	[86008]		= "Inscription", 	-- Illustrious
--	[110417]	= "Inscription",	-- Zen Master
--	[158748]	= "Inscription",	-- Draenor Master
--	[195115]	= "Inscription",	-- Legion Master
-- Jewelcrafting (Not sure if this triggers a loot window)
--	[25229]		= "Jewelcrafting", 	-- Apprentice
--	[25230]		= "Jewelcrafting", 	-- Journeyman
--	[28894]		= "Jewelcrafting", 	-- Expert
--	[28895]		= "Jewelcrafting", 	-- Artisan
--	[28897]		= "Jewelcrafting", 	-- Master
--	[51311]		= "Jewelcrafting", 	-- Grand Master
--	[73318]		= "Jewelcrafting", 	-- Illustrious
--	[110420]	= "Jewelcrafting",	-- Zen Master
--	[158750]	= "Jewelcrafting",	-- Draenor Master
--	[195116]	= "Jewelcrafting",	-- Legion Master
-- Leatherworking (No loot window)
--	[2108]		= "Leatherworking",	-- Apprentice
--	[3104]		= "Leatherworking",	-- Journeyman
--	[3811]		= "Leatherworking",	-- Expert
--	[10662]		= "Leatherworking",	-- Artisan
--	[32549]		= "Leatherworking",	-- Master
--	[51302]		= "Leatherworking",	-- Grand Master
--	[81199]		= "Leatherworking",	-- Illustrious
--	[110423]	= "Leatherworking",	-- Zen Master
--	[158752]	= "Leatherworking",	-- Draenor Master
--	[195119]	= "Leatherworking",	-- Legion Master
-- Tailoring (No loot window)
--	[3908] 		= "Tailoring", 		-- Apprentice
--	[3909] 		= "Tailoring", 		-- Journeyman
--	[3910] 		= "Tailoring", 		-- Expert
--	[12180]		= "Tailoring", 		-- Artisan
--	[26790]		= "Tailoring", 		-- Master
--	[51309]		= "Tailoring", 		-- Grand Master
--	[75156]		= "Tailoring", 		-- Illustrious
--	[110426]	= "Tailoring",		-- Zen Master
--	[158758]	= "Tailoring",		-- Draenor Master
--	[195126]	= "Tailoring",		-- Legion Master
-- Smelting (No loot window)
--	[2656] 		= "Smelting", 		-- No levels
}
