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

-- [item id] = required level, --name
Scrolllevel_List = { "I", "II", "III", "IV", "V", "VI", "VII" }

ScrollList_Agility = {
	["3012"] = 10, 	--Agility
	["1477"] = 25, 	--Agility II
	["4425"] = 40, 	--Agility III
	["10309"] = 55, --Agility IV
	["27498"] = 60,	--Agility V
	["33457"] = 70,	--Agility VI
	["43463"] = 80	--Agility VII
	--["43464"] = 80 --Agility VIII
	--["63303"] = 80 --Agility IX 
}
ScrollList_Intellect = {	
	["955"] 	= 5,	--Intellect
	["2290"] 	= 20, --Intellect II
	["4419"] 	= 35, --Intellect III
	["10308"] = 50, --Intellect IV
	["27499"] = 60,	--Intellect V
	["33458"] = 70,	--Intellect VI
	["37091"] = 80	--Intellect VII
	--["37092"] = 80 --Intellect VIII
	--["63305"] = 80 --Intellect IX

}
ScrollList_Protection = {
	["3013"] 	= 1, 	--Protection
	["1478"] 	= 15, 	--Protection II
	["4421"] 	= 30, 	--Protection III
	["10305"] = 45, --Protection IV
	["27500"] = 60,	--Protection V
	["33459"] = 70,	--Protection VI
	["43467"] = 80	--Protection VII
	--[""] = 80	--Protection VIII	(doesn't exist?)
	--["63308"] = 80 --Protection IX
}
ScrollList_Spirit = {
	["1181"] 	= 1, 	--Spirit
	["1712"] 	= 15, 	--Spirit II
	["4424"] 	= 30, 	--Spirit III
	["10306"] = 45, --Spirit IV
	["27501"] = 60,	--Spirit V
	["33460"] = 70,	--Spirit VI	
	["37097"] = 80	--Spirit VII
	--["37098"] = 80	--Spirit VIII
	--["63307"] = 80 --Spirit IX
}
ScrollList_Stamina = {
	["1180"] 	= 5,	--Stamina
	["1711"] 	= 20,	--Stamina II
	["4422"] 	= 35,	--Stamina III
	["10307"] = 50,	--Stamina IV
	["27502"] = 60,	--Stamina V
	["33461"] = 70,	--Stamina VI
	["37093"] = 80	--Stamina VII
	--["37094"] = 80	--Stamina VIII
	--["63306"] = 80,	--Stamina IX
}
ScrollList_Strength = {	
	["954"] 	= 10,	--Strength
	["2289"] 	= 25,	--Strength II
	["4426"] 	= 40,	--Strength III
	["10310"] = 55,	--Strength IV
	["27503"] = 60,	--Strength V
	["33462"] = 70,	--Strength VI
	["43465"] = 80 --Strength VII
	--["43466"] = 80 --Strength VIII
	--["63304"] = 80 --Strength IX
}
