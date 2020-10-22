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

--------------------------------------------------------------------------------
--<<                               Whitelist                                >>--   
--------------------------------------------------------------------------------

local whitelist_selected = nil		-- currently selected whitelist item
local whitelist_maxvisible = 15		-- max visible buttons on whitelist
local whitelist_numitems = 0		-- current number of items in the whitelist
local whitelist_items = {}			-- a table for alphabetizing the whitelist items

local echo = KarniCrap_Echo


function KarniCrap_InitializeWhitelist()
	local index = 0
	local t, temp_table, item_info = {}, {}, {}
	whitelist_selected = nil
	
	KarniCrap_BtnWhitelistRemove:Disable()
		
	-- Sort alphabetically
	for k,v in pairs(KarniWhitelist) do 
		t = { ["id"] = k, ["name"] = v }
		table.insert(temp_table, t)
	end
	table.sort(temp_table, function(a,b)
		return a.name < b.name
	end )	

    for k,v in ipairs(temp_table) do 
       	item_info = {}
    	local _, itemLink = GetItemInfo(v.id)

		if itemLink then item_info["link"] = itemLink
		else item_info["link"] = "|cFFFF0000["..v.name.."]|r" end
		
		index = index + 1
		item_info["id"] = v.id
		whitelist_items[index] = item_info
	end
	
	whitelist_numitems = index
	KarniCrap_WhitelistScrollBar_Update()
	_G["KarniCrap_Whitelist"]:SetFrameLevel(2)
	return
end


function KarniCrap_WhitelistScrollBar_Update()
	local line, lineplusoffset

	FauxScrollFrame_Update(KarniNotCrapScrollBar,whitelist_numitems,whitelist_maxvisible,16);
	for line = 1, whitelist_maxvisible do
		lineplusoffset = line + FauxScrollFrame_GetOffset(KarniNotCrapScrollBar)
		if lineplusoffset < whitelist_numitems + 1 then
			_G["KarniNotCrapEntry"..line.."_Item"]:SetText(whitelist_items[lineplusoffset].link)
			_G["KarniNotCrapEntry"..line]:SetID(whitelist_items[lineplusoffset].id)
			KarniCrap_SelectWhitelistItem("KarniNotCrapEntry"..line, whitelist_items[lineplusoffset].id)
			_G["KarniNotCrapEntry"..line]:Show()
		else
			_G["KarniNotCrapEntry"..line]:Hide()
		end
	end
	return
end


function KarniCrap_AddLootToWhitelist(itemLink)
	local itemName = GetItemInfo(itemLink) 
	local _, _, itemID = string.find(itemLink, "item:(%d+):")
	
	if itemName and itemID then
		if KarniBlacklist[itemID] then KarniCrap_RemoveFromBlacklist(itemID) end
		KarniWhitelist[itemID] = itemName;
		echo("KarniCrap: Added " ..itemLink.. " to the Always Loot list.")
	else
		echo("KarniCrap: /notcrap [itemlink] to add an item to the Always Loot list")
	end
	_G["KarniCrap_Blacklist"]:EnableMouse("false") -- disables the drag & drop so items can be clicked again
	KarniCrap_InitializeWhitelist()
	return
end


function KarniCrap_RemoveFromWhitelist(id)
	local itemName, itemLink, itemRarity = GetItemInfo(id)

	if itemLink then
		echo("KarniCrap: Removed " .. itemLink .. " from the Always Loot list.")
	else
		echo("KarniCrap: Removed ["..KarniWhitelist[tostring(id)].."] from the Always Loot list.")
	end
	
	KarniWhitelist[tostring(id)] = nil;
	KarniCrap_BtnWhitelistRemove:Disable();
	KarniCrap_InitializeWhitelist()
	
	return
end


function KarniCrap_SelectWhitelistItem()
	local line
	
	if whitelist_selected then KarniCrap_BtnWhitelistRemove:Enable() 
	else KarniCrap_BtnWhitelistRemove:Disable() end
	
	for line = 1, whitelist_maxvisible do
		if _G["KarniNotCrapEntry"..line]:GetID() == whitelist_selected then
			_G["KarniNotCrapEntry"..line]:LockHighlight();
		else 
			_G["KarniNotCrapEntry"..line]:UnlockHighlight();
		end
	end
	return
end


function KarniCrap_Set_WhitelistSelected(id)
	whitelist_selected = id
	return
end 


function KarniCrap_Get_WhitelistSelected()
	return whitelist_selected
end


function KarniCrap_DragOntoWhitelist()
	if CursorHasItem() then
		local infoType, id, link = GetCursorInfo()
		if infoType == "item" then
			KarniCrap_AddLootToWhitelist(link)
			ClearCursor()
		end
	end
	return
end


