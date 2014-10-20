
--[[ Inventory ]]--   

local inventory_selected = nil
local inventory_maxvisible = 15
local inventory_numitems = 0
local inventory_items = {}

local merchant_open = nil

local COPPER_PER_GOLD = 10000
local COPPER_PER_SILVER = 100
local error_color = "|cFFFF0000"

local echo = KarniCrap_Echo




function KarniCrap_InventoryList()
	inventory_items = {} -- reset table
	inventory_numitems = 0 -- reset numItems
	inventory_selected = nil 
	local containerItem = {}
	local crap_count = nil
	
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag,slot)
			if itemLink then
			
				local _, itemCount = GetContainerItemInfo(bag,slot)
				local itemName, _, itemQuality, _, _, itemType, _, itemStackCount, _, _, itemValue = GetItemInfo(itemLink)
				local _, _, itemID = string.find(itemLink, "item:(%d+):")
				containerItem = {}
				
				-- if itemValue is 0 and checkbox is set, skip entering info into table
				containerItem.name = itemName
				containerItem.link = itemLink
				containerItem.id = itemID
								
				-- do the crap check in here
				containerItem.crap = 0
				
				local tempcheck, tempreason = CheckLoot(itemID)
				if debug then echo(itemLink.."-"..tempreason) end
				if not tempcheck then 
					containerItem.crap = 1 
					crap_count = 1
				end 
				
				-- check for quest items pending turn-in 
				if itemQuality > 0 then
					for k, v in pairs(KarniQuestlist_Pending) do
						if ( v == itemName ) then 
							containerItem.crap = 0
							break
						end
					end
				end
				
				-- Values
				containerItem.itemvalue = itemValue
				containerItem.currentvalue = itemValue * itemCount
				containerItem.fullstackvalue = itemValue * itemStackCount
				
				containerItem.reason = tempreason
				containerItem.quantity = itemCount
				containerItem.quality = itemQuality
				containerItem.type = itemType
				containerItem.bag = bag
				containerItem.slot = slot
				
				if KarniCrapConfig.HideQuestItems == false or ( KarniCrapConfig.HideQuestItems == true and itemValue > 0 ) then
					table.insert(inventory_items, containerItem)
					inventory_numitems = inventory_numitems + 1
				end
			end
		end
	end

	--[[ disable Destroy All Crap when at a vendor ]]--
	if crap_count and not merchant_open then 
		KarniCrap_BtnDestroyAllCrap:Enable()
	else
		KarniCrap_BtnDestroyAllCrap:Disable()
	end
	KarniCrap_ShowInventory()
end
	

function KarniCrap_ShowInventory() --sorts
	inventory_selected = nil -- reset selection
	local temp_table = {}
	-- sort by price
	table.sort(inventory_items, function(a,b)
		return a.currentvalue < b.currentvalue
	end )
	for k, v in ipairs(inventory_items) do table.insert(temp_table, v) end
	inventory_items = temp_table
	KarniCrap_InventoryScrollbarUpdate()
end


function KarniCrap_InventoryScrollbarUpdate()
	local line, crap
	local crapcount = 0
	
	FauxScrollFrame_Update(KarniCrap_Inventory_ScrollBar,inventory_numitems,inventory_maxvisible,16)
	
	for line = 1, inventory_maxvisible do
		local lineplusoffset = line + FauxScrollFrame_GetOffset(KarniCrap_Inventory_ScrollBar)
		crap = ""	
		if lineplusoffset < inventory_numitems + 1 then
			
			_G["KarniInvEntry"..line.."_Quantity"]:SetText(inventory_items[lineplusoffset].quantity.." x")
			_G["KarniInvEntry"..line.."_Item"]:SetText(inventory_items[lineplusoffset].link)
			if KarniCrapConfig.InvSort == "Stack Value" then
				KarniCrap_GetMoneyCoins(inventory_items[lineplusoffset].fullstackvalue, "KarniInvEntry"..line)
			elseif KarniCrapConfig.InvSort == "Item Value" then
				KarniCrap_GetMoneyCoins(inventory_items[lineplusoffset].itemvalue, "KarniInvEntry"..line) 
			else		
				KarniCrap_GetMoneyCoins(inventory_items[lineplusoffset].currentvalue, "KarniInvEntry"..line) 
			end

			if merchant_open then
				_G["KarniInvEntry"..line.."_BtnCrap"]:Hide()
				if inventory_items[lineplusoffset].itemvalue > 0 then 
					_G["KarniInvEntry"..line.."_BtnSell"]:Show()
					_G["KarniInvEntry"..line.."_BtnCrap"]:Hide()
				else
					_G["KarniInvEntry"..line.."_BtnSell"]:Hide()
				end 
			else
				_G["KarniInvEntry"..line.."_BtnSell"]:Hide()
				if inventory_items[lineplusoffset].crap == 1 then
					crapcount = crapcount + 1 
					_G["KarniInvEntry"..line.."_BtnCrap"]:Show() 
				else
					_G["KarniInvEntry"..line.."_BtnCrap"]:Hide()
				end
				
			end
			_G["KarniInvEntry"..line]:SetID(lineplusoffset)
			_G["KarniInvEntry"..line]:Show()
		else
			_G["KarniInvEntry"..line]:Hide()
		end
	end


	-- disable the destroy buttons when a merchant window is open
	-- eventually change these to sell selected and sell all crap buttons
	-- want to have an open inventory tab/window when at vendor option eventually
	if merchant_open then
		KarniCrap_BtnDestroyAllCrap:Disable()
	else
		if crapcount > 0 then
			KarniCrap_BtnDestroyAllCrap:Enable()
		end
	end
	-- reset selection
	inventory_selected = nil
	KarniCrap_SelectInventoryItem()
end








--[[ Selection functions ]]--

function KarniCrap_SelectInventoryItem()
	local line

	-- When at a vendor disable destroy buttons
	if inventory_selected and not merchant_open then 
		KarniCrap_BtnDestroyItem:Enable() 
	else 
		KarniCrap_BtnDestroyItem:Disable() 
	end
	
	for line = 1, inventory_maxvisible do
		if _G["KarniInvEntry"..line]:GetID() == inventory_selected then
			_G["KarniInvEntry"..line]:LockHighlight();
		else 
			_G["KarniInvEntry"..line]:UnlockHighlight();
		end
	end
end

function KarniCrap_Set_InventorySelected(id)
	inventory_selected = id
	return
end 

function KarniCrap_Get_InventorySelected()
	return inventory_seleced
end

function KarniCrap_SellItem(id)
	local link = inventory_items[id].link
 	local bag = inventory_items[id].bag
	local slot = inventory_items[id].slot
	KarniCrap_Scripts:RegisterEvent("BAG_UPDATE")
	UseContainerItem(bag, slot)
	return
end

-- possibly just use quantity when deleting items, or
-- just check here to make sure the stack is large enough to perform
-- delete operations with x quantity 
function KarniCrap_FindBagSlot(looteditemid, lootedquantity)
	for bag = 0, 4 do			
		for slot = 0, GetContainerNumSlots(bag) do
			local _, bagquantity = GetContainerItemInfo(bag,slot)
			local bagitemlink = GetContainerItemLink(bag,slot)
			
			if bagitemlink then
				local _, _, bagitemid = string.find(bagitemlink, "item:(%d+):")
				if looteditemid == bagitemid then
					return bag, slot, bagquantity
				end
			end
		end
	end
	return nil
end
 










--[[ Dim KarniCrap window when confirmation box appears ]]--
function KarniCrap_ModalOn()
	KarniCrap_Tab3:SetAlpha(0.3)
end
--[[ Undim KarniCrap window when confirmation box disappears ]]--
function KarniCrap_ModalOff()
	KarniCrap_Tab3:SetAlpha(1)
end



local popup_justify
local popup_spacing



--[[ Create the confirmation dialog for destroying selected item ]]--
StaticPopupDialogs["KARNICRAP_CONFIRMDESTROYSELECTED"] = {
	text = "",
	button1 = "Destroy",
	button2 = "Cancel",
	OnShow = function(self)
		KarniCrap_ModalOn();
		popup_justify = self.text:GetJustifyH();
		popup_spacing = self.text:GetSpacing();
		self.text:SetJustifyH("LEFT");
		self.text:SetSpacing(5);
		self:ClearAllPoints();
		self:SetPoint("CENTER", "KarniCrap", "CENTER");
	end,
	OnAccept = function(self)
		KarniCrap_DestroySelectedItem(); 
		KarniCrap_ModalOff();
	end,
	OnCancel = function()
		KarniCrap_ModalOff();
	end,
	OnHide = function(self)
		self.text:SetJustifyH(popup_justify);
		self.text:SetSpacing(popup_spacing);
		KarniCrap_ModalOff();
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
	exclusive = true
}
--[[ Confirm Destroy Selected Item ]]--
function KarniCrap_ConfirmDestroySelected()
	StaticPopupDialogs["KARNICRAP_CONFIRMDESTROYSELECTED"].text = "|cffffd200Destroy the following item?|r|n|n"
		.."     |cffffd200"..inventory_items[inventory_selected].quantity.." x|r "..inventory_items[inventory_selected].link.."|n|n"
	StaticPopup_Show("KARNICRAP_CONFIRMDESTROYSELECTED") 
end
--[[ Destroy Selected Item ]]--
function KarniCrap_DestroySelectedItem()
	local link = inventory_items[inventory_selected].link
 	local bag = inventory_items[inventory_selected].bag
	local slot = inventory_items[inventory_selected].slot
	local quantity = inventory_items[inventory_selected].quantity
	
 	if not KarniCrap_DestroyItem( link, bag, slot, quantity ) then 
		echo("KarniCrap: Error attempting to destroy "..link.." x"..quantity)
		return nil	
 	end
	KarniCrap_InventoryScrollbarUpdate()
end




--[[ Initialize confirmation box for Destroy All Crap ]]--
StaticPopupDialogs["KARNICRAP_CONFIRMDESTROYALLCRAP"] = {
	text = "",
	button1 = "Destroy",
	button2 = "Cancel",
	OnShow = function(self)
		KarniCrap_ModalOn();
		popup_justify = self.text:GetJustifyH();
		popup_spacing = self.text:GetSpacing();
		self.text:SetJustifyH("LEFT");
		self.text:SetSpacing(5);
		self:ClearAllPoints();
		self:SetPoint("CENTER", "KarniCrap", "CENTER");
	end,
	OnAccept = function(self)
		KarniCrap_DestroyAllCrap(); 
		KarniCrap_ModalOff();
	end,
	OnCancel = function()
		KarniCrap_ModalOff();
	end,
	OnHide = function(self)
		self.text:SetJustifyH(popup_justify);
		self.text:SetSpacing(popup_spacing);
		KarniCrap_ModalOff();
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
	exclusive = true
}
--[[ Confirm Destroy All Crap ]]--
function KarniCrap_ConfirmDestroyAllCrap()
	local itemlist = ""

	for k, v in pairs(inventory_items) do 
		if v.crap == 1 then
			itemlist = itemlist.."     |cffffd200"..v.quantity.." x|r "..v.link.."|n"
		end	
	end
	StaticPopupDialogs["KARNICRAP_CONFIRMDESTROYALLCRAP"].text = "|cffffd200Destroy the following item(s)?|r|n|n"..itemlist.."|n"
	StaticPopup_Show("KARNICRAP_CONFIRMDESTROYALLCRAP") 
end
--[[ Destroy All Crap ]]--
function KarniCrap_DestroyAllCrap()
	local itemcount = 0
	for k, v in pairs(inventory_items) do 
		if v.crap == 1 then
			if KarniCrapConfig.DestroyEcho == true then 
				echo("Destroying "..v.link.." because it's crap!")
			end
			KarniCrap_DestroyItem(v.link, v.bag, v.slot, v.quantity)
			itemcount = itemcount + 1
		end	
	end
	if itemcount == 0 then 
		echo("KarniCrap: No crappy items found!")
	end
	KarniCrap_InventoryScrollbarUpdate()
	return
end







--[[ On merchant window open ]]--
function KarniCrap_MerchantOpen()
	merchant_open = 1
	--KarniCrap_Scripts:RegisterEvent("BAG_UPDATE")
	_G["KarniCrap_InvHeader4"]:SetText("Sell")
	KarniCrap_InventoryScrollbarUpdate()
	
	if KarniCrapConfig.OpenAtMerchant then
		-- testing open with merchant window code
		KarniCrap:SetAttribute("UIPanelLayout-defined", true)
		KarniCrap:SetAttribute("UIPanelLayout-enabled", true)
		KarniCrap:SetAttribute("UIPanelLayout-area", "left")
		KarniCrap:SetAttribute("UIPanelLayout-pushable", 5)
		KarniCrap_ShowTab3()
		ShowUIPanel(KarniCrap) 
	end

end

--[[ On merchant window close ]]--
function KarniCrap_MerchantClosed()
	merchant_open = nil
	-- testing 
	HideUIPanel(KarniCrap)
	-- should only close KarniCrap window when merchant closes if it was opened automatically
	-- can i tell by just getting the if UIPanelLayout-defined property?
	KarniCrap:SetAttribute("UIPanelLayout-defined", false)
	KarniCrap:SetAttribute("UIPanelLayout-enabled", false)

	_G["KarniCrap_InvHeader4"]:SetText("Crap")
	KarniCrap_InventoryScrollbarUpdate()



end


--[[ Get money coins ]]--
function KarniCrap_GetMoneyCoins(money, btntarget) 
	local gold = math.floor(money / COPPER_PER_GOLD)
	local silver = math.floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = math.floor(money - (gold * COPPER_PER_GOLD) - (silver * COPPER_PER_SILVER))

	_G[btntarget.."_Silver"]:Hide()
	_G[btntarget.."_Gold"]:Hide()

	_G[btntarget.."_Copper_Amt"]:SetText(copper)
	_G[btntarget.."_Silver_Amt"]:SetText(silver)
	_G[btntarget.."_Gold_Amt"]:SetText(gold)

	if money >= SILVER_PER_GOLD then _G[btntarget.."_Silver"]:Show() end
	if money >= COPPER_PER_GOLD then _G[btntarget.."_Gold"]:Show() end
	return
end


