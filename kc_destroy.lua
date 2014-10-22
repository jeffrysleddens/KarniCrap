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

--[[ Destroy ]]--   

local autodestroy_queue = {}
local debug = nil
local echo = KarniCrap_Echo


-- Get number of free bag slots
function KarniCrap_GetFreeSlots()
	local totalFreeSlots = 0
	for bag = 0,4 
		do freeSlots, bagType = GetContainerNumFreeSlots(bag)
		if bagType then 
			totalFreeSlots = totalFreeSlots + freeSlots
		end
	end
	if debug then echo("GetFreeSlots() = "..totalFreeSlots) end
	return totalFreeSlots
end


--[[ Check to see if conditions are good for destruction. i.e. slots free and checkboxes checked ]]--
function KarniCrap_CheckDestroyConditions(using_tradeskill)
	if debug then echo("CheckDestroyConditions()") end
	
	if KarniCrapConfig.Destroy == false then
		return nil 
	else
		-- using tradeskill
		if KarniCrapConfig.NoDestroyTradeskill == true and using_tradeskill then 
			if debug then echo("using tradeskill - don't destroy") end
			return nil 
		end
		-- free bag slots
		if KarniCrapConfig.DestroySlots == true then
			-- more free slots than autodestroyslotsnum, skip autodestroy looting
			if KarniCrap_GetFreeSlots() > KarniCrapConfig.DestroySlotsNum then 
				if debug then echo("slot count failed wcheck "..KarniCrapConfig.DestroySlotsNum) end
				return nil
			end
		end
		if KarniCrapConfig.DestroyGroup == true and KarniCrapConfig.NumberInParty > 0 then 
			if debug then echo("group setting failed check") end
			return nil 
		end
		if KarniCrapConfig.DestroyRaid == true and KarniCrapConfig.NumberInRaid > 0 then 
			if debug then echo("raid setting failed check") end
			return nil 
		end
	end
	-- if auto-destroy is on and all other settings conditions are met, return 1
	if debug then echo("all destroy conditions met, destroy any looted crap") end
	return 1
end 


-- Add item to destroy queue
function KarniCrap_AddToDestroyQueue(id, link, quantity, details)
	local autodestroy_iteminfo = {}
	if debug then echo("Adding "..link.." to destroy_queue") end
	
	autodestroy_iteminfo["id"] = id
	autodestroy_iteminfo["link"] = link
	autodestroy_iteminfo["quantity"] = quantity
	autodestroy_iteminfo["details"] = details
	table.insert(autodestroy_queue, autodestroy_iteminfo)

	return 1
end


-- destroy items in queue
function KarniCrap_DestroyQueue()
	if debug then echo("Running DestroyQueue()") end
	if #autodestroy_queue > 0 then
		for k, v in pairs(autodestroy_queue) do
			local bag, slot, count = KarniCrap_FindBagSlot(v.id, v.quantity )
			if bag and slot then 
				KarniCrap_DestroyItem(v.link, bag, slot, v.quantity)
			end
			autodestroy_queue[k] = nil
		end
	end
	return 1
end


-- destroy item
function KarniCrap_DestroyItem(itemlink, bag, slot, quantity)
	if debug then echo("DestroyItem()") end
	local _, stackcount, locked = GetContainerItemInfo( bag, slot )
	if quantity == stackcount then
		PickupContainerItem( bag, slot )
		if CursorHasItem() then
			DeleteCursorItem()
			if KarniCrapConfig.Echo == true then 
				echo("Destroying "..itemlink.." x"..quantity.." because it's crap!")
			end
		else
			return nil
		end
	elseif quantity < stackcount then
		SplitContainerItem( bag, slot, quantity )
		if CursorHasItem() then
			DeleteCursorItem()
			if KarniCrapConfig.Echo == true then 
				echo("Destroying "..itemlink.." x"..quantity.." because it's crap!")
			end
		else
			return nil
		end
	end		
	return 1
end



function KarniCrapConfig_SetDestroySlotsNum()
	local slots = KarniCrap_EBDestroySlotsNum:GetNumber()

	-- reads the number from the editbox and validates it (minimum of 1 slot must be free)
	if not slots or slots < 1 then slots = 1 end
	KarniCrap_EBDestroySlotsNum:SetNumber(slots)
	KarniCrapConfig.DestroySlotsNum = slots
	return 1
end

-- Destroy functions specific to the inventory tab are in kc_inventory.lua at the moment
