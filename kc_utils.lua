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

-- Will print out multiple arguments passed to it, one per line
function KarniCrap_Echo(...)
	local text = ""
	
	-- Extract all arguments and call tostring and print for each:
	-- can be done using the function select(n, ...)
	-- Select returns all arguments contained in the vararg starting with 
	-- the nth
	
	for i = 1, select("#", ...) do
		local x = select(i, ...)
		if x == nil then x = "NIL" end
		ChatFrame1:AddMessage(x)
	end


end



-- InteractUnit
-- GetContainerItemID



-- GetInventoryItemsForSlot() 
--GetInventoryItemsForSlot. Returns a table (and populates one if passed as second parameter) of base item id's indexed by numerical locations.
-- table = GetInventoryItemsForSlot(slot[,table])
