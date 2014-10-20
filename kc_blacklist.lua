--------------------------------------------------------------------------------
--<<                               Blacklist                                >>--   
--------------------------------------------------------------------------------
local blacklist_selected = nil		-- currently selected blacklist item
local blacklist_maxvisible = 15		-- max visible buttons on blacklist
local blacklist_numitems = 0		-- current number of items in the blacklist
local blacklist_items = {}			-- a table for alphabetizing the blacklist items

local echo = KarniCrap_Echo


function KarniCrap_InitializeBlacklist()
	local index = 0
	local t, temp_table, item_info = {}, {}, {}
	blacklist_selected = nil
	
	KarniCrap_BtnBlacklistRemove:Disable()
	
	-- Sort alphabetically
	for k,v in pairs(KarniBlacklist) do 
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
		blacklist_items[index] = item_info
	end
	blacklist_numitems = index
	KarniCrap_BlacklistScrollBar_Update()
	return
end


function KarniCrap_BlacklistScrollBar_Update()
	local line, lineplusoffset
	
	FauxScrollFrame_Update(KarniCrapScrollBar,blacklist_numitems,blacklist_maxvisible,16)
	for line = 1, blacklist_maxvisible do
		lineplusoffset = line + FauxScrollFrame_GetOffset(KarniCrapScrollBar)
		if lineplusoffset < blacklist_numitems + 1 then
			_G["KarniCrapEntry"..line.."_Item"]:SetText(blacklist_items[lineplusoffset].link)
			_G["KarniCrapEntry"..line]:SetID(blacklist_items[lineplusoffset].id)
			KarniCrap_SelectBlacklistItem("KarniCrapEntry"..line, blacklist_items[lineplusoffset].id)
			_G["KarniCrapEntry"..line]:Show()
		else
			_G["KarniCrapEntry"..line]:Hide()
		end
	end
	return
end


function KarniCrap_AddLootToBlacklist(itemLink)
	local itemName = GetItemInfo(itemLink) 
	local _, _, itemID = string.find(itemLink, "item:(%d+):")
	
	if itemName and itemID then
		if (KarniWhitelist[itemID]) then KarniCrap_RemoveFromWhitelist(itemID) end
		KarniBlacklist[itemID] = itemName
		echo("KarniCrap: Added " ..itemLink.. " to the Never Loot list.")
	else
		echo("KarniCrap: /notcrap [itemlink] to add an item to the Never Loot list")
	end
	_G["KarniCrap_Blacklist"]:EnableMouse("false") -- disables the drag & drop so items can be clicked again
	KarniCrap_InitializeBlacklist()
	return
end


function KarniCrap_RemoveFromBlacklist(id)
	local itemName, itemLink, itemRarity = GetItemInfo(id); 
	
	if itemLink then
		echo("KarniCrap: Removed " .. itemLink .. " from the Never Loot list.")
	else
		echo("KarniCrap: Removed ["..KarniBlacklist[tostring(id)].."] from the Never Loot list.")
	end
	
	KarniBlacklist[tostring(id)] = nil
	KarniCrap_BtnBlacklistRemove:Disable()
	KarniCrap_InitializeBlacklist()
	return
end


function KarniCrap_SelectBlacklistItem()
	local line
		
	if blacklist_selected then KarniCrap_BtnBlacklistRemove:Enable() 
	else KarniCrap_BtnBlacklistRemove:Disable() end
	
	for line = 1, blacklist_maxvisible do
		if _G["KarniCrapEntry"..line]:GetID() == blacklist_selected then
			_G["KarniCrapEntry"..line]:LockHighlight();
		else 
			_G["KarniCrapEntry"..line]:UnlockHighlight();
		end
	end
	return
end


function KarniCrap_Set_BlacklistSelected(id)
	blacklist_selected = id
	return
end 


function KarniCrap_Get_BlacklistSelected() 
	return blacklist_selected
end


function KarniCrap_DragOntoBlacklist()
	if CursorHasItem() then
		local infoType, id, link = GetCursorInfo()
		if (infoType == "item") then
			KarniCrap_AddLootToBlacklist(link)
			ClearCursor()
		end
	end
	return
end
