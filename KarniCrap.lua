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



	--[[ Local Variables ]]--
	local KARNICRAP_VERSION = GetAddOnMetadata( "KarniCrap", "Version" );

	local debug = nil			-- debug mode default setting (nil or 1)

	local loot_all = nil			-- variable to set next loot opened to loot all items
	local justlooking = nil			-- alt key will temporarily disable autolooting
	local lasttab = 1			-- which tab the user was showing last
	local unit_level = nil			-- level of the	corpse being skinned/engineered/mined/gathered
	local using_tradeskill = nil		-- player using tradeskill (used for preventing autodestroy)

	local amount_poor = 0			-- totalled amount for poor filter
	local amount_common = 0			-- totalled amount for common filter
	local loot_threshold = 5		-- loot under threshold rarity will be autolooted (default is legendary
	local playerlevel = nil			-- tracks current player level

	local questlist_items = {}		-- a list that has all quest item names
	local questlist_delay = 3		-- amount of delay before quest objectives are checked

	--COLORS (Returns |cXXXXXX )
	local _,_,_,poor_color = GetItemQualityColor(0)		-- 0 Poor #9d9d9d
	local _,_,_,common_color = GetItemQualityColor(1)	-- 1 Common #ffffff
	local _,_,_,uncommon_color = GetItemQualityColor(2)	-- 2 Uncommon #1eff00
	local _,_,_,rare_color = GetItemQualityColor(3)		-- 3 Rare #0070dd
	local _,_,_,epic_color = GetItemQualityColor(4)		-- 4 Epic #a335ee
	local _,_,_,legendary_color = GetItemQualityColor(5)	-- 5 Legendary #ff8000
								-- 6 Artifact
								-- 7 Heirloom

	local error_hex = "|cffff0000"		-- red text for errors

	local echo = KarniCrap_Echo		-- localize the text output function



--[[ OnLoad Handler ]]--

function KarniCrap_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("LOOT_OPENED")
	self:RegisterEvent("LOOT_CLOSED")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("QUEST_FINISHED")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("MERCHANT_CLOSED")

	-- Register slash commands
	SLASH_KARNICRAP1 = "/karnicrap"
	SLASH_KARNICRAP2 = "/crap"
	SlashCmdList["KARNICRAP"] = function(msg, editBox)
		KarniCrap_CommandHandler(msg)
	end
	SLASH_KARNINOTCRAP1 = "/notcrap"
	SlashCmdList["KARNINOTCRAP"] = function(msg)
		KarniCrap_CommandHandlerNotCrap(msg)
	end
end



--[[ Databroker ]]--

LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("KarniCrap", {
	type = "launcher",
	icon = "Interface\\Icons\\Spell_Frost_Stun",
	OnClick = function(clickedframe, button)
		KarniCrap_ToggleFrame()
	end,
	label = "Karni's Crap Filter" })



--[[ Inventory Update delay ]]--

local bagTimer = CreateFrame("Frame")
local total_time = 0

bagTimer:Hide()
-- used to prevent multiple executions of inventory updates on BAG_UPDATE
local function KarniCrap_BagUpdateDelay(self,elapsed)
	total_time = total_time + elapsed
	if total_time >= .1 then
		KarniCrap_InventoryList()
		KarniCrap_Scripts:RegisterEvent("BAG_UPDATE")
		total_time = 0
		self:Hide()
	end
end
bagTimer:SetScript("OnUpdate", KarniCrap_BagUpdateDelay) -- set script after function exists



--[[ Slash Command Handler ]]--

function KarniCrap_CommandHandler(text)
	link = text
	text = text:lower()
	if text == "help" then
		echo(" ---[[ |cffffffffKarni's Crap Filter Help|r ]]---")
		echo(" /crap or /karnicrap will open the options menu")
		echo(" /crap [item] will add an item to the Never Loot list")
		echo(" /notcrap [item] will add an item to the Always Loot list")
		echo(" /crap off will disable the mod, /crap on will enable it")
	-- debug settings
	elseif text == "debug" then	KarniCrap_ToggleDebug()
	elseif text == "on" or text == "enable" then KarniCrap_Enable()
	elseif text == "off" or text == "disable" then KarniCrap_Disable()
	elseif text ~= "" then KarniCrap_AddLootToBlacklist(link)
	else KarniCrap_ToggleFrame()
	end
end


--[[ Toggle user debug mode ]]--

function KarniCrap_ToggleDebug()
	if debug then
		debug = nil
		echo("KarniCrap: Debug mode off")
	else
		debug = 1
		echo("KarniCrap: Debug mode on")
	end
end



--[[ Toggle main window ]]--

function KarniCrap_ToggleFrame()
	local frame = _G["KarniCrap"]
	if frame then
		-- if frame is visible, hide it and unregister BAG_UPDATE event
		if frame:IsVisible() then
			frame:Hide()
			if KarniCrapConfig.Enabled == true then
				KarniCrap_Scripts:UnregisterEvent("BAG_UPDATE")
			end
		-- if frame is hidden, show it and regist BAG_UPDATE event
		else
			if lasttab == 1 then KarniCrap_ShowTab1()
			elseif lasttab == 2 then KarniCrap_ShowTab2()
			else KarniCrap_ShowTab3() end
			frame:Show()
			if KarniCrapConfig.Enabled == true then
				KarniCrap_Scripts:RegisterEvent("BAG_UPDATE")
			end
		end
	end
end




--[[ Handles whitelist command "/notcrap" ]]--

function KarniCrap_CommandHandlerNotCrap(text)
	if ( text ~= "" ) then
		KarniCrap_AddLootToWhitelist(text)
	else
		echo("KarniCrap: /notcrap [itemlink] to add an item to the Always Loot list")
	end
end


--[[ Get UnitID ]]--

function KarniCrap_GetUnitID()
	local unitString = UnitGUID("mouseover")
	local id = nil
	local unitType = nil

	if unitString then -- not a chest/object
		if debug then echo("UnitGUID="..unitString) end
		unitType, _, _, _, _, id, _ = strsplit("-", unitString);

		if unitType == "Creature" then  -- npc
			-- if user has SkilledEnough option checked, get the target's level. Boss or unknown (too high) will return -1
			if KarniCrapConfig.SkilledEnough then
				unit_level = UnitLevel("mouseover") or nil
				if unit_level == -1 then unit_level = nil end --boss or too high level. Attempt to use on Ony? or mineable boss in mana tombs?
			end
			if id then
				if debug and unit_level then echo("Unit ID is "..id..", level is "..unit_level) end
				return id
			else
				return nil
			end
		end
	end
end



--[[ Get info of item in loot window slot ]]--

function KarniCrap_GetLootSlotInfo(i)
	if GetLootSlotType(i) == LOOT_SLOT_CURRENCY then return nil end
	local link = GetLootSlotLink(i)
	local _, _, quantity = GetLootSlotInfo(i)

	if link then
		local _, _, id = string.find(link, "item:(%d+):")
		local notcrap, details = CheckLoot(id)
		-- notcrap will be true if item passed filters
		local x = 'Item does not pass filters'
		if notcrap then
			x = 'Item passes filters'
		end

		x = "Lootslot("..i..")="..id..","..link..","..quantity..","..x.." ("..details..")"
		if debug then echo(x) end

		return notcrap, id, link, quantity, details
	end
	return nil
end



--[[ Function to loot everything in loot window when certain conditions are met ]]--

function KarniCrap_LootEverything(why)
	why = why or "Looting everything" -- sets the reason to not be null if not passed (test!)
	local destroy = KarniCrap_CheckDestroyConditions(using_tradeskill)
	for i = 1, GetNumLootItems() do
		-- to do: if inventory full then abort loot attempts with a warning	(need to check for UI errors?)
		local passed, id, link, quantity, details = KarniCrap_GetLootSlotInfo(i)

		LootSlot(i)
		-- check autodestroy settings
		if destroy and not passed then
			if debug then echo("destroy and not passed") end
			KarniCrap_Scripts:RegisterEvent("BAG_UPDATE")
			KarniCrap_AddToDestroyQueue(id, link, quantity, details)
		end
	end
	if debug then echo("Looting everything ("..why..")") end
	loot_all = nil
	return 1, why
end


-- Attempt to figure out the player's skill level for x skill

function KarniCrap_GetSkillLevel(skill)
	local skill_level = nil
	for i = 1, 6 do
		profession = GetProfessions()[i]+
		print("profession",profession or "nil")
		if profession then
			skillName, _, skillRank, maxRank, numSpells, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionsInfo(profession)
			if skillName == skill then
				skill_level = skillRank + skillModifier
				return skill_level
			end
		end
	end
	return skill_level
end


-- Compare mob level to skill level

function KarniCrap_HasEnoughSkill(skill)
	skill_level = KarniCrap_GetSkillLevel(skill)
	if not skill_level then skill_level = 0 end
	if debug then echo("skill_level for "..skill.." is "..skill_level) end

	if skill_level > 0 then
		if skill_level < 100 then
			max_unit_level = floor(skill_level/10) + 10
		else
			max_unit_level = floor(skill_level/5)
		end

		--if debug then echo("max unit "..skill.." level is "..max_unit_level) end
		if max_unit_level >= unit_level then return 1 end
	end
	return nil
end





--[[ Event Handler ]]--

function KarniCrap_OnEvent(self, event, ...)
	  local arg1, arg2, arg3, arg4, arg5 = ...
	  local addon = ...

	-- Delay scanning quest items until the PLAYER_LOGIN event fires and all addons are loaded
	if event == "PLAYER_LOGIN" then
		KarniCrap_InitializeUI()
		KarniCrap_GetQuestItems()

	elseif event == "ADDON_LOADED" then
		if addon ~= "KarniCrap" then return end
		self:UnregisterEvent("ADDON_LOADED")
		echo("Karni's Crap Filter v"..KARNICRAP_VERSION.." loaded (/crap for options)");
		KarniCrap_Loaded()
	
	elseif event == "VARIABLES_LOADED" then
		-- Show warning if Blizzard autoloot is enabled
		local autolooting = GetCVar("autoLootDefault");
		if GetCVar("autoLootDefault") == "1" then
			echo(error_hex.."KarniCrap: Autolooting set to ON in Interface Settings, KarniCrap will not function!");
		end

	elseif event == "BAG_UPDATE" then
		KarniCrap_Scripts:UnregisterEvent("BAG_UPDATE")
		KarniCrap_InventoryScrollbarUpdate()
		-- When an item goes to or leaves inventory, check to see if there is anything pending in the destroy queue
		if KarniCrapConfig.Destroy == true then KarniCrap_DestroyQueue() end
		-- only Re-register BAG_UPDATE if KarniCrap window is visible (i.e. updating inventory lists...)
		if _G["KarniCrap"]:IsVisible() then
			bagTimer:Show()
		end

	elseif event == "PLAYER_LEVEL_UP" then
		playerlevel = tonumber(arg1)

	elseif event == "PARTY_MEMBERS_CHANGED" then
		KarniCrapConfig.NumberInParty = GetNumPartyMembers()
		KarniCrap_GetLootThreshold()

	elseif event == "RAID_ROSTER_UPDATE" then
		KarniCrapConfig.NumberInRaid = GetNumRaidMembers()
		KarniCrap_GetLootThreshold()

	elseif event == "QUEST_FINISHED" then
		KarniCrap_TimerFrame:Show()

	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then
		-- arg1 = Unit casting spell
		-- arg2 = Spell name
		-- arg3 = Spell rank (deprecated)
		-- arg4 = Spell lineID counter (?)
		-- arg5 = Spell ID

		-- Spellcast detection is used to determine if a tradeskill has been used
		-- what happens when tradeskill doesn't trigger a loot window?

	  --[[ Tradeskills ]]--
		-- Disenchanting, Inscription, Milling & Prospecting all "lock"
	-- an item in your bag automatically forcing a "loot all" situation
	-- The tradeskillList[] check should catch them anyway though.
		using_tradeskill = nil
	if tradeskillList[arg5] then -- check if the spell cast is a tradeskill
			using_tradeskill = true
			loot_all = 1
		else
			loot_all = nil -- not in tradeskill list, don't loot everything
		end

	elseif event == "MERCHANT_SHOW" then
		KarniCrap_MerchantOpen()

	elseif event == "MERCHANT_CLOSED" then
		KarniCrap_MerchantClosed()

	elseif event == "LOOT_CLOSED" then
		loot_all = nil

	elseif event == "LOOT_OPENED" then
		local link, itemID, quantity, looted = nil
		if debug then echo("----- Looting ------") end

		autodestroy_iteminfo = {} --should contain itemID, itemLink and itemQuantity

		--[[ Just Looking (ALT modifier) ]]--
		if IsAltKeyDown() then justlooking = true else justlooking = nil end

		if arg1 == 0 and KarniCrapConfig.Enabled and not justlooking then
			if loot_all then
				looted = KarniCrap_LootEverything(arg2)
			else
				if KarniCrap_IsLocked()then looted = KarniCrap_LootEverything("Container") end
				if IsStealthed() and KarniCrapConfig.Pickpocketing == true then looted = KarniCrap_LootEverything("Pick Pocket") end
			end

			--[[ Fishing ]]--
			if not looted and KarniCrapConfig.Fishing and IsFishingLoot() then
				looted = KarniCrap_LootEverything("Fishing")
			end

			-- Get the source unit ID
			local unitID = KarniCrap_GetUnitID();

			-- if one of the gathering items is checked, check the mob type
			if not looted and ( KarniCrapConfig.Skinnable or KarniCrapConfig.Gatherable or KarniCrapConfig.Minable or KarniCrapConfig.Engineerable ) then
				local skill_level = ""

				-- If cursor is over a corpse, check corpse settings and loot all if appropriate
				if unitID then
					if debug then echo("unit id="..unitID) end
					local max_unit_level = 0

					-- skinnable corpse
					if KarniCrapConfig.Skinnable and mobsSkinnableList[unitID] then
						if KarniCrapConfig.SkilledEnough then
							if KarniCrap_HasEnoughSkill("Skinning") then looted = KarniCrap_LootEverything("Skinnable corpse") end
						else
							looted = KarniCrap_LootEverything("Skinnable corpse")
						end
					-- minable corpse
					elseif KarniCrapConfig.Minable and mobsMinableList[unitID] then
						if KarniCrapConfig.SkilledEnough then
							if KarniCrap_HasEnoughSkill("Mining") then looted = KarniCrap_LootEverything("Minable corpse") end
						else
							looted = KarniCrap_LootEverything("Minable corpse")
						end
					-- gatherable corpse
					elseif KarniCrapConfig.Gatherable and mobsGatherableList[unitID] then
						if KarniCrapConfig.SkilledEnough then
							if KarniCrap_HasEnoughSkill("Herb Gathering") then looted = KarniCrap_LootEverything("Gatherable corpse") end
						else
							looted = KarniCrap_LootEverything("Gatherable corpse")
						end
					-- engineerable corpse
					elseif KarniCrapConfig.Engineerable and mobsEngineerableList[unitID] then
						if KarniCrapConfig.SkilledEnough then
							if KarniCrap_HasEnoughSkill("Engineering") then looted = KarniCrap_LootEverything("Engineerable corpse") end
						else
							looted = KarniCrap_LootEverything("Engineerable corpse")
						end
					end
				end
			end

			-- Close loot window if nothing left
			if GetNumLootItems() == 0 then
				looted = true
				CloseLoot()
			end


			-- If an attempt to loot everything hasn't been made, then do checks
			if not looted then
				local destroy = KarniCrap_CheckDestroyConditions()

				for i = 1, GetNumLootItems() do
					--[[ Money or Currency ]]--
					if debug then echo("Loot slot "..i.." type = "..GetLootSlotType(i)) end
					if (GetLootSlotType(i) == LOOT_SLOT_MONEY) or (GetLootSlotType(i) == LOOT_SLOT_CURRENCY) then
						LootSlot(i)

-- TO DO --
-- if getnumlootitmes is 1 and the 1 is coins
-- Might need to do an items remaining check here to see if we can avoid lootslot taint errors
-- possible they will happen anyway if there is only coin and it gets looted


					--[[ Item ]]--
					else
						local passed, id, link, quantity, details = KarniCrap_GetLootSlotInfo(i)

						if passed == 1 then LootSlot(i)
							if debug then echo("Looting "..link.."("..details..")") end
						elseif not passed then
							if destroy then
								if debug then echo("Looting "..link.." to destroy ("..details..")") end
								LootSlot(i)

								-- TO DO: NEED TO MAKE SURE ITEM IS NOT ADDED TO DESTROY QUEUE IF USER COULD NOT LOOT IT (BAGS FULL)
								KarniCrap_AddToDestroyQueue(id, link, quantity, details)
								KarniCrap_Scripts:RegisterEvent("BAG_UPDATE")
							else
								if KarniCrapConfig.Echo then
									echo("Not looting "..link.." because it's crap!");
								end
							end
						end
					end
				end
				if GetNumLootItems() == 0 then CloseLoot() end
			end
		end
	end
end



function KarniCrap_GetLootThreshold()
	if GetLootMethod() == "freeforall" then
		loot_threshold = 5
	else
		loot_threshold = GetLootThreshold()
	end
end






--[[ Check Loot ]]--
-- Loot = 1
-- Crap = nil
-- Ignore item = -1 (not marked as crap so auto-destroy won't catch it)

function CheckLoot(itemID)
	if itemID == nil then return nil, "Blacklist" end
	local lootName, lootLink, lootRarity, lootLevel, _, lootType, lootSubType, lootStackCount, _, _, lootValue = GetItemInfo(itemID)
	local temp

	--[[ Blacklist ]]--
	if KarniBlacklist[itemID] then return nil, "Blacklist" end

	--[[ Whitelist, Currency & Quest type items ]]--
	if KarniWhitelist[itemID] or lootType == "Quest" or lootType == "Currency" then
		return 1, "Whitelist, Currency or Quest item"
	end

	--[[ Quest Items ]]--
	if ( lootRarity > 0 ) then
		for key, value in pairs(questlist_items) do
			if value == lootName then return 1, "Quest Item" end
		end
	end

	--[[ Quality ]]--
	if ( ( KarniCrapConfig.Quality_Grouped == true and ( KarniCrapConfig.NumberInParty + KarniCrapConfig.NumberInRaid ) > 0 ) or KarniCrapConfig.Quality_Grouped == false ) then
		if lootRarity == 0 and KarniCrapConfig.Quality_Poor then return -1, "Ignoring: Quality settings"
		elseif lootRarity == 1 and KarniCrapConfig.Quality_Common then return -1, "Ignoring: Quality settings"
		elseif lootRarity == 2 and KarniCrapConfig.Quality_Uncommon then return -1, "Ignoring: Quality settings"
		elseif lootRarity == 3 and KarniCrapConfig.Quality_Rare then return -1, "Ignoring: Quality settings"
		elseif lootRarity == 4 and KarniCrapConfig.Quality_Epic then return -1, "Ignoring: Quality settings" end
	end

	--[[ Loot Threshold ]]--
	if ( lootRarity >= loot_threshold ) then return -1, "Ignoring: Over group loot threshold" end

	--[[ Cooking ]]--
	if ( KarniCrapConfig.Cooking and cookingList[itemID] ) then	return 1, "Cooking" end

	--[[ Cloth ]]--
	if itemID == "2589" then
		if KarniCrapConfig.Cloth_Linen then return 1, "Linen"
		elseif KarniCrapConfig.Cloth_Linen_Never then return nil, "Linen"	end
	elseif itemID == "2592" then
		if KarniCrapConfig.Cloth_Wool then return 1, "Wool"
		elseif KarniCrapConfig.Cloth_Wool_Never then return nil, "Wool"	end
	elseif itemID == "4306" then
		if KarniCrapConfig.Cloth_Silk then return 1, "Silk"
		elseif KarniCrapConfig.Cloth_Silk_Never then return nil, "Silk" end
	elseif itemID == "4338" then
		if KarniCrapConfig.Cloth_Mageweave then return 1, "Mageweave"
		elseif KarniCrapConfig.Cloth_Mageweave_Never then return nil, "Mageweave" end
	elseif itemID == "14047" then
		if KarniCrapConfig.Cloth_Runecloth then return 1, "Runecloth"
		elseif KarniCrapConfig.Cloth_Runecloth_Never then return nil, "Runecloth" end
	elseif itemID == "21877" then
		if KarniCrapConfig.Cloth_Netherweave then return 1, "Netherweave"
		elseif KarniCrapConfig.Cloth_Netherweave_Never then return nil, "Netherweave" end
	elseif itemID == "33470" then
		if KarniCrapConfig.Cloth_Frostweave then return 1, "Frostweave"
		elseif KarniCrapConfig.Cloth_Frostweave_Never then return nil, "Frostweave" end
	elseif itemID == "53010" then
		if KarniCrapConfig.Cloth_Embersilk then return 1, "Embersilk"
		elseif KarniCrapConfig.Cloth_Embersilk_Never then return nil, "Embersilk" end
	elseif itemID == "72988" then
		if KarniCrapConfig.Cloth_Windwool then return 1, "Windwool"
		elseif KarniCrapConfig.Cloth_Windwool_Never then return nil, "Windwool" end
	elseif itemID == "111557" then
		if KarniCrapConfig.Cloth_SumptuousFur then return 1, "Sumptuous Fur"
		elseif KarniCrapConfig.Cloth_SumptuousFur_Never then return nil, "Sumptuous Fur" end
	elseif itemID == "124437" then
		if KarniCrapConfig.Cloth_ShaldoreiSilk then return 1, "Shal'dorei Silk"
		elseif KarniCrapConfig.Cloth_ShaldoreiSilk_Never then return nil, "Shal'dorei Silk" end
	end

	--[[ Scrolls ]]--
	-- needs to loot all max level scroll types if only the max button is checked
	if lootSubType == "Scroll" then
		if KarniCrapConfig.Scroll_Agility and ScrollList_Agility[itemID] then
			if KarniCrapConfig.ScrollMax then
				if KarniCrap_CheckScroll(itemID, ScrollList_Agility) then return 1
				else return nil, "Scroll level too low" end
			else return 1, "Scroll type" end
		elseif KarniCrapConfig.Scroll_Intellect and ScrollList_Intellect[itemID] then
			if KarniCrapConfig.ScrollMax then
				if KarniCrap_CheckScroll(itemID, ScrollList_Intellect) then return 1
				else return nil, "Scroll level too low" end
			else return 1, "Scroll type" end
		elseif KarniCrapConfig.Scroll_Protection and ScrollList_Protection[itemID] then
			if KarniCrapConfig.ScrollMax then
				if KarniCrap_CheckScroll(itemID, ScrollList_Protection) then return 1
				else return nil, "Scroll level too low" end
			else return 1, "Scroll type" end
		elseif KarniCrapConfig.Scroll_Spirit and ScrollList_Spirit[itemID] then
			if KarniCrapConfig.ScrollMax then
				if KarniCrap_CheckScroll(itemID, ScrollList_Spirit) then return 1
				else return nil, "Scroll level too low" end
			else return 1, "Scroll type" end
		elseif KarniCrapConfig.Scroll_Stamina and ScrollList_Stamina[itemID] then
			if KarniCrapConfig.ScrollMax then
				if KarniCrap_CheckScroll(itemID, ScrollList_Stamina) then return 1
				else return nil, "Scroll level too low" end
			else return 1, "Scroll type" end
		elseif KarniCrapConfig.Scroll_Strength and ScrollList_Strength[itemID] then
			if KarniCrapConfig.ScrollMax then
				if KarniCrap_CheckScroll(itemID, ScrollList_Strength) then return 1
				else return nil, "Scroll level too low" end
			else return 1, "Scroll type" end
		end
	end

	--[[ Food ]]--
	if KarniCrapConfig.AlwaysFood or KarniCrapConfig.NeverFood then
		if foodList[itemID] then
			if KarniCrapConfig.NeverFood then
				return nil, "Food"
			elseif KarniCrapConfig.AlwaysFood then
				if KarniCrapConfig.FoodMax then
					if foodList[itemID] > playerlevel - 10 then return 1, "Food"
					else return nil, "Food level too low"	end
				else
					return 1, "Food"
				end
			end
		end
	end

	--[[ Water ]]--
	if KarniCrapConfig.AlwaysWater or KarniCrapConfig.NeverWater then
		if waterList[itemID] then
			if KarniCrapConfig.NeverWater then
				return nil, "Water"
			elseif KarniCrapConfig.AlwaysWater then
				if KarniCrapConfig.WaterMax then
					if waterList[itemID] > playerlevel - 10 then return 1, "Water"
					else return nil, "Water level too low" end
				else
					return 1, "Water"
				end
			end
		end
	end

	--[[ Health Potions ]]--
	if ( KarniCrapConfig.AlwaysHealth or KarniCrapConfig.NeverHealth ) and HealingPotionList[itemID] then
		if KarniCrapConfig.NeverHealth then
		 	details = "Health Potion" return nil
		elseif KarniCrapConfig.AlwaysHealth then
			if KarniCrapConfig.HealthMax then
				if KarniCrap_CheckMaxPotion(itemID, HealingPotionList) then return 1
				else return nil, "Health Potion too low" end
			else
				return 1, "Health Potion"
			end
		end
	end

	--[[ Mana Potions ]]--
	if ( KarniCrapConfig.AlwaysMana or KarniCrapConfig.NeverMana ) and ManaPotionList[itemID] then
		if KarniCrapConfig.NeverMana then
			return nil, "Mana Potion"
		elseif KarniCrapConfig.AlwaysMana then
			if KarniCrapConfig.ManaMax then
				if KarniCrap_CheckMaxPotion(itemID, ManaPotionList) then return 1
				else return nil, "Mana Potion too low" end
			else
				return 1, "Mana Potion"
			end
		end
	end

	--[[ Price ]]--
	if lootValue then
		if lootValue == 0 then return 1, "Unvendorable item" end
		if KarniCrapConfig.UseStackValue then lootValue = lootValue * lootStackCount end
		--[[ Poor Items ]]--
		if lootRarity == 0 and KarniCrapConfig.Poor and amount_poor > 0 then
			if lootValue then
				if lootValue >= amount_poor then return 1, "Price above threshold"
				else return nil, "Price below threshold" end
			end
		--[[ Common Items ]]--
		elseif ( lootRarity == 1 and KarniCrapConfig.Common and amount_common > 0 ) then
			if lootValue then
				--if debug then echo("Common price filter, item value "..lootValue.." vs threshold "..amount_common) end
				if lootValue >= amount_common then return 1, "Price above threshold"
				else return nil, "Price below threshold" end
			end
		end
	end

	-- passed or didn't qualify for filters
	return 1, "Looting: No filters apply"

end -- CheckLoot()











-- Dims echo the input boxes if poor isn't checked
function KarniCrap_CheckButtonPoor()
	if KarniCrap_CBPoor:GetChecked() then
		KarniCrapConfig.Poor = true;
		KarniCrap_Poor_GoldInputBox:Show();
		KarniCrap_Poor_GoldTexture:SetAlpha(1);
		KarniCrap_Poor_SilverInputBox:Show();
		KarniCrap_Poor_SilverTexture:SetAlpha(1);
		KarniCrap_Poor_CopperInputBox:Show();
		KarniCrap_Poor_CopperTexture:SetAlpha(1);
	else
		KarniCrapConfig.Poor = false;
		KarniCrap_Poor_GoldInputBox:Hide();
		KarniCrap_Poor_GoldTexture:SetAlpha(0.3);
		KarniCrap_Poor_SilverInputBox:Hide();
		KarniCrap_Poor_SilverTexture:SetAlpha(0.3);
		KarniCrap_Poor_CopperInputBox:Hide();
		KarniCrap_Poor_CopperTexture:SetAlpha(0.3);
	end
end


-- Dims echo the input boxes if common isn't checked
function KarniCrap_CheckButtonCommon()
	if KarniCrap_Tab1_CBCommon:GetChecked() then
		KarniCrapConfig.Common = true;
		KarniCrap_Tab1_CBCommonDesc_GoldInputBox:Show();
		KarniCrap_Tab1_CBCommonDesc_GoldTexture:SetAlpha(1);
		KarniCrap_Tab1_CBCommonDesc_SilverInputBox:Show();
		KarniCrap_Tab1_CBCommonDesc_SilverTexture:SetAlpha(1);
		KarniCrap_Tab1_CBCommonDesc_CopperInputBox:Show();
		KarniCrap_Tab1_CBCommonDesc_CopperTexture:SetAlpha(1);
	else
		KarniCrapConfig.Common = false;
		KarniCrap_Tab1_CBCommonDesc_GoldInputBox:Hide();
		KarniCrap_Tab1_CBCommonDesc_GoldTexture:SetAlpha(0.3);
		KarniCrap_Tab1_CBCommonDesc_SilverInputBox:Hide();
		KarniCrap_Tab1_CBCommonDesc_SilverTexture:SetAlpha(0.3);
		KarniCrap_Tab1_CBCommonDesc_CopperInputBox:Hide();
		KarniCrap_Tab1_CBCommonDesc_CopperTexture:SetAlpha(0.3);
	end
end


function KarniCrap_CheckMaxPotion(itemID, potion_list)
	local next_potion_level, previous_value = nil
	local unsorted_list = {}
	local sorted_list = {}
	local potion_level = potion_list[itemID]
	local temp_list = {}

	-- gets the unique levels from the potion list and sorts it
	for k, v in pairs(potion_list) do
		unsorted_list[v] = true
	end
	for k, v in pairs(unsorted_list) do
		table.insert(sorted_list,k)
	end
	--
	table.insert(sorted_list, 100) -- add a high max level to the end of the array so it won't crash when doing index + 1
	table.sort(sorted_list)
	-- just get the next highest level of potion
	for i = 1, # sorted_list do
		if potion_level == sorted_list[i] then
			next_potion_level = sorted_list[i + 1]
			break
		end
	end
	if potion_level >= playerlevel or ( playerlevel > potion_level and playerlevel <= next_potion_level ) then
		return true
	else
		return nil
	end
end


function KarniCrap_CheckScroll(itemID, scroll_list)
	local next_scroll_level
	local sorted_list = {}
	local scroll_level = scroll_list[itemID]

	for id, value in pairs(scroll_list) do table.insert(sorted_list, value) end
	table.insert(sorted_list, 100) -- add a high value to the end of the array so it won't crash when doing index+1
	table.sort(sorted_list)
	-- get the level of the next highest scroll of that type
	for i = 1, 6 do
		if scroll_level == sorted_list[i] then
			next_scroll_level = sorted_list[i + 1]
			break
		end
	end
	if scroll_level >= playerlevel or ( playerlevel > scroll_level and playerlevel <= next_scroll_level ) then
		return true
	else
		return nil
	end
end


function KarniCrap_ScrollLevels(list)
	local level_string = ""
	local last_index = 1
	local i = 1
	local sorted_list = {}

	for id, value in pairs(list) do table.insert(sorted_list, value) end
	table.insert(sorted_list, 100) -- add a high value to the end of the array so it won't crash when doing index+1
	table.sort(sorted_list)
	for index = 1, # Scrolllevel_List do
		-- this will leave 1 level of overlap when looting scrolls, so when a character hits 70 you can still loot the level 5 scrolls
		-- this was done since there are no level VI scrolls in BC checking 'max' would cause you not to loot any scrolls
		if sorted_list[index] >= playerlevel or ( playerlevel > sorted_list[index] and playerlevel <= sorted_list[index + 1] ) then
			if level_string == "" then
				level_string = Scrolllevel_List[index]
			else
				level_string = level_string..","..Scrolllevel_List[index]
			end
		end
		last_index = index
	end
	return level_string
end


function KarniCrap_CBMaxScrolls()
	if (KarniCrap_Scrolls_CBMaxScrolls:GetChecked()) then
		-- scrollmax should set the scrolls to be character level usable and above
		-- if character is lvl 60, scrolls included should be IV-VI
		KarniCrapConfig.ScrollMax = true
		KarniCrap_Scrolls_CBScrollAgility_Text:SetText("Loot |cffffffff[Agility "..KarniCrap_ScrollLevels(ScrollList_Agility).."]|r")
		KarniCrap_Scrolls_CBScrollIntellect_Text:SetText("Loot |cffffffff[Intellect "..KarniCrap_ScrollLevels(ScrollList_Intellect).."]|r")
		KarniCrap_Scrolls_CBScrollProtection_Text:SetText("Loot |cffffffff[Protection "..KarniCrap_ScrollLevels(ScrollList_Protection).."]|r")
		KarniCrap_Scrolls_CBScrollSpirit_Text:SetText("Loot |cffffffff[Spirit "..KarniCrap_ScrollLevels(ScrollList_Spirit).."]|r")
		KarniCrap_Scrolls_CBScrollStamina_Text:SetText("Loot |cffffffff[Stamina "..KarniCrap_ScrollLevels(ScrollList_Stamina).."]|r")
		KarniCrap_Scrolls_CBScrollStrength_Text:SetText("Loot |cffffffff[Strength "..KarniCrap_ScrollLevels(ScrollList_Strength).."]|r")
	else
		KarniCrapConfig.ScrollMax = false
		KarniCrap_Scrolls_CBScrollAgility_Text:SetText("Loot |cffffffff[Agility I - VII]")
		KarniCrap_Scrolls_CBScrollIntellect_Text:SetText("Loot |cffffffff[Intellect I - VII]")
		KarniCrap_Scrolls_CBScrollProtection_Text:SetText("Loot |cffffffff[Protection I - VII]")
		KarniCrap_Scrolls_CBScrollSpirit_Text:SetText("Loot |cffffffff[Spirit I - VII]")
		KarniCrap_Scrolls_CBScrollStamina_Text:SetText("Loot |cffffffff[Stamina I - VII]")
		KarniCrap_Scrolls_CBScrollStrength_Text:SetText("Loot |cffffffff[Strength I - VII]")
	end
end


function KarniCrap_RBHealth()
	if (KarniCrap_Potions_RBHealth1:GetChecked()) then
		KarniCrapConfig.NeverHealth = true;
		KarniCrapConfig.AlwaysHealth = false;
		KarniCrap_Potions_RBHealth2:SetChecked(nil);
		KarniCrap_Potions_CBHealthMax:SetAlpha(0.3);
		KarniCrap_Potions_CBHealthMax:Disable();
		KarniCrap_Potions_RBHealth1_Text:SetText("|cffffffffNever|r loot health potions (crap)");
		KarniCrap_Potions_RBHealth2_Text:SetText("Always loot health potions");
	elseif (KarniCrap_Potions_RBHealth2:GetChecked()) then
		KarniCrapConfig.NeverHealth = false;
		KarniCrapConfig.AlwaysHealth = true;
		KarniCrap_Potions_RBHealth1:SetChecked(nil);
		KarniCrap_Potions_CBHealthMax:SetAlpha(1);
		KarniCrap_Potions_CBHealthMax:Enable();
		KarniCrap_Potions_RBHealth1_Text:SetText("Never loot health potions (crap)");
		KarniCrap_Potions_RBHealth2_Text:SetText("|cffffffffAlways|r loot health potions");
	else
		KarniCrapConfig.NeverHealth = false;
		KarniCrapConfig.AlwaysHealth = false;
		KarniCrap_Potions_CBHealthMax:SetAlpha(0.3);
		KarniCrap_Potions_CBHealthMax:Disable();
		KarniCrap_Potions_RBHealth1_Text:SetText("Never loot health potions (crap)");
		KarniCrap_Potions_RBHealth2_Text:SetText("Always loot health potions");
	end
end


function KarniCrap_RBMana()
	if KarniCrap_Potions_RBMana1:GetChecked() then
		KarniCrapConfig.NeverMana = true;
		KarniCrapConfig.AlwaysMana = false;
		KarniCrap_Potions_CBManaMax:SetAlpha(0.3);
		KarniCrap_Potions_CBManaMax:Disable();
		KarniCrap_Potions_RBMana1_Text:SetText("|cffffffffNever|r loot mana potions (crap)");
		KarniCrap_Potions_RBMana2_Text:SetText("Always loot mana potions");
	elseif KarniCrap_Potions_RBMana2:GetChecked() then
		KarniCrapConfig.NeverMana = false;
		KarniCrapConfig.AlwaysMana = true;
		KarniCrap_Potions_CBManaMax:SetAlpha(1);
		KarniCrap_Potions_CBManaMax:Enable();
		KarniCrap_Potions_RBMana1_Text:SetText("Never loot mana potions (crap)");
		KarniCrap_Potions_RBMana2_Text:SetText("|cffffffffAlways|r loot mana potions");
	else
		KarniCrapConfig.NeverMana = false;
		KarniCrapConfig.AlwaysMana = false;
		KarniCrap_Potions_CBManaMax:SetAlpha(0.3);
		KarniCrap_Potions_CBManaMax:Disable();
		KarniCrap_Potions_RBMana1_Text:SetText("Never loot mana potions (crap)");
		KarniCrap_Potions_RBMana2_Text:SetText("Always loot mana potions");
	end
end


-- Dims echo the food subselections if the checkbox isn't checked
function KarniCrap_RBFood()
	if KarniCrap_Consumables_RBFood1:GetChecked() then
		KarniCrapConfig.AlwaysFood = false;
		KarniCrapConfig.NeverFood = true;
		KarniCrap_Consumables_CBFoodMax:SetAlpha(0.3);
		KarniCrap_Consumables_CBFoodMax:Disable();
		KarniCrap_Consumables_RBFood1_Text:SetText("|cffffffffNever|r loot food (crap)");
		KarniCrap_Consumables_RBFood2_Text:SetText("Always loot food");
	elseif KarniCrap_Consumables_RBFood2:GetChecked()  then
		KarniCrapConfig.AlwaysFood = true;
		KarniCrapConfig.NeverFood = false;
		KarniCrap_Consumables_CBFoodMax:SetAlpha(1);
		KarniCrap_Consumables_CBFoodMax:Enable();
		KarniCrap_Consumables_RBFood1_Text:SetText("Never loot food (crap)");
		KarniCrap_Consumables_RBFood2_Text:SetText("|cffffffffAlways|r loot food");
	else
		KarniCrapConfig.AlwaysFood = false;
		KarniCrapConfig.NeverFood = false;
		KarniCrap_Consumables_CBFoodMax:SetAlpha(0.3);
		KarniCrap_Consumables_CBFoodMax:Disable();
		KarniCrap_Consumables_RBFood1_Text:SetText("Never loot food (crap)");
		KarniCrap_Consumables_RBFood2_Text:SetText("Always loot food");
	end
end


-- Dims echo the water subselections if the checkbox isn't checked
function KarniCrap_RBWater()
	if KarniCrap_Consumables_RBWater1:GetChecked() then
		KarniCrapConfig.NeverWater = true;
		KarniCrapConfig.AlwaysWater = false;
		KarniCrap_Consumables_CBWaterMax:SetAlpha(0.3);
		KarniCrap_Consumables_CBWaterMax:Disable();
		KarniCrap_Consumables_RBWater1_Text:SetText("|cffffffffNever|r loot water (crap)");
		KarniCrap_Consumables_RBWater2_Text:SetText("Always loot water");
	elseif KarniCrap_Consumables_RBWater2:GetChecked() then
		KarniCrapConfig.NeverWater = false;
		KarniCrapConfig.AlwaysWater = true;
		KarniCrap_Consumables_CBWaterMax:SetAlpha(1);
		KarniCrap_Consumables_CBWaterMax:Enable();
		KarniCrap_Consumables_RBWater1_Text:SetText("Never loot water (crap)");
		KarniCrap_Consumables_RBWater2_Text:SetText("|cffffffffAlways|r loot water");
	else
		KarniCrapConfig.NeverWater = false;
		KarniCrapConfig.AlwaysWater = false;
		KarniCrap_Consumables_CBWaterMax:SetAlpha(0.3);
		KarniCrap_Consumables_CBWaterMax:Disable();
		KarniCrap_Consumables_RBWater1_Text:SetText("Never loot water (crap)");
		KarniCrap_Consumables_RBWater2_Text:SetText("Always loot water");
	end
end


function KarniCrap_CalcPoorThreshold()
	amount_poor =
		KarniCrapConfig.PoorThreshold_Gold * 10000 +
		KarniCrapConfig.PoorThreshold_Silver * 100 +
		KarniCrapConfig.PoorThreshold_Copper;
end


function KarniCrap_CalcCommonThreshold()
	amount_common =
		KarniCrapConfig.CommonThreshold_Gold * 10000 +
		KarniCrapConfig.CommonThreshold_Silver * 100 +
		KarniCrapConfig.CommonThreshold_Copper;
end



function KarniCrap_DestroyUI()
	if KarniCrap_CBDestroy:GetChecked() then
		KarniCrapConfig.Destroy = true
		KarniCrap_CBDestroySlots:Enable()
		KarniCrap_CBDestroySlots:SetAlpha(1)
		KarniCrap_CBDestroyGroup:Enable();
		KarniCrap_CBDestroyGroup:SetAlpha(1)
		KarniCrap_CBDestroyRaid:Enable()
		KarniCrap_CBDestroyRaid:SetAlpha(1)
		KarniCrap_CBNoDestroyTradeskill:Enable()
		KarniCrap_CBNoDestroyTradeskill:SetAlpha(1)
	else
		KarniCrapConfig.Destroy = false
		KarniCrap_CBDestroySlots:Disable()
		KarniCrap_CBDestroySlots:SetAlpha(0.3)
		KarniCrap_CBDestroyGroup:Disable()
		KarniCrap_CBDestroyGroup:SetAlpha(0.3)
		KarniCrap_CBDestroyRaid:Disable()
		KarniCrap_CBDestroyRaid:SetAlpha(0.3)
		KarniCrap_CBNoDestroyTradeskill:Disable()
		KarniCrap_CBNoDestroyTradeskill:SetAlpha(0.3)
	end
end





--[[ Load variables / set defaults ]]--

function KarniCrap_Loaded()

	-- load each option, set default if not there
	KarniCrapConfig = KarniCrapConfig or {}
	KarniBlacklist = KarniBlacklist or {}
	KarniWhitelist = KarniWhitelist or {}
	KarniQuestlist = KarniQuestlist or {}
	KarniQuestlist_Pending = KarniQuestlist_Pending or {}

	KarniCrapConfig.Version = KARNICRAP_VERSION

	-- loading the external files
	foodList = foodList or {}
	waterList = waterList or {}
	clothList = clothList or {}
	cookingList = cookingList or {}
	tradeskillList = tradeskillList or {}

	mobsEngineerableList = mobsEngineerableList or {}
	mobsMinableList = mobsMinableList or {}
	mobsGatherableList = mobsGatherableList or {}
	mobsSkinnableList = mobsSkinnableList or {}
	HealingPotionList = HealingPotionList or {}
	ManaPotionList = ManaPotionList or {}

	ScrollList_Agility = ScrollList_Agility or {}
	ScrollList_Intellect = ScrollList_Intellect or {}
	ScrollList_Protection = ScrollList_Protection or {}
	ScrollList_Spirit = ScrollList_Spirit or {}
	ScrollList_Stamina = ScrollList_Stamina or {}
	ScrollList_Strength = ScrollList_Strength or {}

	if KarniCrapConfig.NumberInParty == nil then KarniCrapConfig.NumberInParty = 0 end
	if KarniCrapConfig.NumberInRaid == nil then KarniCrapConfig.NumberInRaid = 0 end

	-- enabled/disabled
	if KarniCrapConfig.Enabled == nil then KarniCrapConfig.Enabled = true end

	-- poor thresholds
	if KarniCrapConfig.PoorThreshold_Gold == nil then KarniCrapConfig.PoorThreshold_Gold = 0 end
	if KarniCrapConfig.PoorThreshold_Silver == nil then KarniCrapConfig.PoorThreshold_Silver = 50 end
	if KarniCrapConfig.PoorThreshold_Copper == nil then KarniCrapConfig.PoorThreshold_Copper = 0 end

	-- common thresholds
	if KarniCrapConfig.CommonThreshold_Gold == nil then KarniCrapConfig.CommonThreshold_Gold = 0 end
	if KarniCrapConfig.CommonThreshold_Silver == nil then KarniCrapConfig.CommonThreshold_Silver = 10 end
	if KarniCrapConfig.CommonThreshold_Copper == nil then KarniCrapConfig.CommonThreshold_Copper = 0 end

	-- poor settings
	if KarniCrapConfig.Poor == nil then KarniCrapConfig.Poor = true end
	if KarniCrapConfig.Common == nil then KarniCrapConfig.Common = true end
	if KarniCrapConfig.UseStackValue == nil then KarniCrapConfig.UseStackValue = true end
	if KarniCrapConfig.Echo == nil then KarniCrapConfig.Echo = true end

	-- corpse settings
	if KarniCrapConfig.Skinnable == nil then KarniCrapConfig.Skinnable = false end
	if KarniCrapConfig.Gatherable == nil then KarniCrapConfig.Gatherable = false end
	if KarniCrapConfig.Minable == nil then KarniCrapConfig.Minable = false end
	if KarniCrapConfig.Engineerable == nil then KarniCrapConfig.Engineerable = false end

	-- tradeskill settings
	if KarniCrapConfig.Cooking == nil then KarniCrapConfig.Cooking = false end
	if KarniCrapConfig.Fishing == nil then KarniCrapConfig.Fishing = false end
	if KarniCrapConfig.Pickpocketing == nil then KarniCrapConfig.Pickpocketing = false end
	if KarniCrapConfig.SkilledEnough == nil then KarniCrapConfig.SkilledEnough = false end

	-- cloth always
	if KarniCrapConfig.Cloth_Linen == nil then KarniCrapConfig.Cloth_Linen = false end
	if KarniCrapConfig.Cloth_Wool == nil then KarniCrapConfig.Cloth_Wool = false end
	if KarniCrapConfig.Cloth_Silk == nil then KarniCrapConfig.Cloth_Silk = false end
	if KarniCrapConfig.Cloth_Mageweave == nil then KarniCrapConfig.Cloth_Mageweave = false end
	if KarniCrapConfig.Cloth_Runecloth == nil then KarniCrapConfig.Cloth_Runecloth = false end
	if KarniCrapConfig.Cloth_Netherweave == nil then KarniCrapConfig.Cloth_Netherweave = false end
	if KarniCrapConfig.Cloth_Frostweave == nil then KarniCrapConfig.Cloth_Frostweave = false end
	if KarniCrapConfig.Cloth_Embersilk == nil then KarniCrapConfig.Cloth_Embersilk = false end
	if KarniCrapConfig.Cloth_Windwool == nil then KarniCrapConfig.Cloth_Windwool = false end
	if KarniCrapConfig.Cloth_SumptuousFur == nil then KarniCrapConfig.Cloth_SumptuousFur = false end
	if KarniCrapConfig.Cloth_ShaldoreiSilk == nil then KarniCrapConfig.Cloth_ShaldoreiSilk = false end

	-- cloth never
	if KarniCrapConfig.Cloth_Linen_Never == nil then KarniCrapConfig.Cloth_Linen_Never = false end
	if KarniCrapConfig.Cloth_Wool_Never == nil then KarniCrapConfig.Cloth_Wool_Never = false end
	if KarniCrapConfig.Cloth_Silk_Never == nil then KarniCrapConfig.Cloth_Silk_Never = false end
	if KarniCrapConfig.Cloth_Mageweave_Never == nil then KarniCrapConfig.Cloth_Mageweave_Never = false end
	if KarniCrapConfig.Cloth_Runecloth_Never == nil then KarniCrapConfig.Cloth_Runecloth_Never = false end
	if KarniCrapConfig.Cloth_Netherweave_Never == nil then KarniCrapConfig.Cloth_Netherweave_Never = false end
	if KarniCrapConfig.Cloth_Frostweave_Never == nil then KarniCrapConfig.Cloth_Frostweave_Never = false end
	if KarniCrapConfig.Cloth_Embersilk_Never == nil then KarniCrapConfig.Cloth_Embersilk_Never = false end
	if KarniCrapConfig.Cloth_Windwool_Never == nil then KarniCrapConfig.Cloth_Windwool_Never = false end
	if KarniCrapConfig.Cloth_SumptuousFur_Never == nil then KarniCrapConfig.Cloth_SumptuousFur_Never = false end
	if KarniCrapConfig.Cloth_ShaldoreiSilk_Never == nil then KarniCrapConfig.Cloth_ShaldoreiSilk_Never = false end

	-- scroll settings
	if KarniCrapConfig.ScrollMax == nil then KarniCrapConfig.ScrollMax = true end
	if KarniCrapConfig.Scroll_Agility == nil then KarniCrapConfig.Scroll_Agility = false end
	if KarniCrapConfig.Scroll_Intellect == nil then KarniCrapConfig.Scroll_Intellect = false end
	if KarniCrapConfig.Scroll_Protection == nil then KarniCrapConfig.Scroll_Protection = false end
	if KarniCrapConfig.Scroll_Spirit == nil then KarniCrapConfig.Scroll_Spirit = false end
	if KarniCrapConfig.Scroll_Stamina == nil then KarniCrapConfig.Scroll_Stamina = false end
	if KarniCrapConfig.Scroll_Strength == nil then KarniCrapConfig.Scroll_Strength = false end

	-- food settings
	if KarniCrapConfig.NeverFood == nil then KarniCrapConfig.NeverFood = false end
	if KarniCrapConfig.AlwaysFood == nil then KarniCrapConfig.AlwaysFood = false end
	if KarniCrapConfig.FoodMax == nil then KarniCrapConfig.FoodMax = false end
	-- water settings
	if KarniCrapConfig.NeverWater == nil then KarniCrapConfig.NeverWater = false end
	if KarniCrapConfig.AlwaysWater == nil then KarniCrapConfig.AlwaysWater = false end
	if KarniCrapConfig.WaterMax == nil then KarniCrapConfig.WaterMax = false end
	-- health potion settings
	if KarniCrapConfig.NeverHealth == nil then KarniCrapConfig.NeverHealth = false end
	if KarniCrapConfig.AlwaysHealth == nil then KarniCrapConfig.AlwaysHealth = false end
	if KarniCrapConfig.HealthMax == nil then KarniCrapConfig.HealthMax = false end
	-- mana potion settings
	if KarniCrapConfig.NeverMana == nil then KarniCrapConfig.NeverMana = false end
	if KarniCrapConfig.AlwaysMana == nil then KarniCrapConfig.AlwaysMana = false end
	if KarniCrapConfig.ManaMax == nil then KarniCrapConfig.ManaMax = false end

	-- auto-destroy
	if KarniCrapConfig.Destroy == nil then KarniCrapConfig.Destroy = false end
	if KarniCrapConfig.DestroyGroup == nil then KarniCrapConfig.DestroyGroup = false end
	if KarniCrapConfig.DestroyRaid == nil then KarniCrapConfig.DestroyRaid = false end
	if KarniCrapConfig.DestroySlots == nil then KarniCrapConfig.DestroySlots = false end
	if KarniCrapConfig.DestroySlotsNum == nil then KarniCrapConfig.DestroySlotsNum = 1 end -- (minimum 1)
	if KarniCrapConfig.NoDestroyTradeskill == nil then KarniCrapConfig.NoDestroyTradeskill = true end

	-- quality settings
	if KarniCrapConfig.Quality_Poor == nil then KarniCrapConfig.Quality_Poor = false end
	if KarniCrapConfig.Quality_Common == nil then KarniCrapConfig.Quality_Common = false end
	if KarniCrapConfig.Quality_Uncommon == nil then KarniCrapConfig.Quality_Uncommon = false end
	if KarniCrapConfig.Quality_Rare == nil then KarniCrapConfig.Quality_Rare = true end
	if KarniCrapConfig.Quality_Epic == nil then KarniCrapConfig.Quality_Epic = true end
	if KarniCrapConfig.Quality_Grouped == nil then KarniCrapConfig.Quality_Grouped = true end

	-- inventory settings
	if KarniCrapConfig.HideQuestItems == nil then KarniCrapConfig.HideQuestItems = true end
	if KarniCrapConfig.InvSort == nil then KarniCrapConfig.InvSort = "Current Value" end
	if KarniCrapConfig.OpenAtMerchant == nil then KarniCrapConfig.OpenAtMerchant = false end

	KarniCrap_CalcPoorThreshold()
	KarniCrap_CalcCommonThreshold()

	-- get the player's class and level
	playerlevel = tonumber(UnitLevel(PLAYER))

end





--[[ Quests ]]--

-- pulls items from quest log
function KarniCrap_GetQuestItemInfo(index)
	local leaderboardTxt, itemType, isDone = GetQuestLogLeaderBoard(index)
	local i, j, itemName, numItems, numNeeded = string.find(tostring(leaderboardTxt), "(.*):%s*([%d]+)%s*/%s*([%d]+)");
	return itemType, itemName, numItems, numNeeded, isDone
end

function KarniCrap_Timer(self, elapsed)
	-- Timer to delay quest item grabbing till its really in the quest list
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
	if self.TimeSinceLastUpdate > questlist_delay then
		self.TimeSinceLastUpdate = 0;
		KarniCrap_TimerFrame:Hide()
		KarniCrap_GetQuestItems()
	end
end

-- quest item checking currently isn't very robust
-- if quest needs two items and 1 part is fulfilled, it will keep looting those until both parts are complete
-- and the user has visited a questgiver to update the list
-- also with the addition of the inventory manager "completed" quest items will show up as crap for the Delete Crap button
-- may need another function to check to see if the number of quest items in bag match what the user is carrying (pending turn-in list?)
-- possibly do a quantity check in here and then update quest item list whenever a quest item is looted
function KarniCrap_GetQuestItems()
	local i;
	local numEntries, numQuests = GetNumQuestLogEntries()
	questlist_items = {}

	if numEntries > 0 then
		for i=1, numEntries do
			SelectQuestLogEntry(i)
			local _, _, _, _, isHeader, _, isComplete, _ = GetQuestLogTitle(i)
			if not isHeader then
				local numObjects=GetNumQuestLeaderBoards()
				for i=1, numObjects do
					local itemType, itemName, numItems, numNeeded, isDone = KarniCrap_GetQuestItemInfo(i)
					if itemName and itemType == "item" then
						-- If the quest isn't complete keep trying to loot the item
						if (itemName == nil) or (itemName == "") or (itemName == " ") then KarniCrap_TimerFrame:Show() end
						if not isComplete then
							table.insert(questlist_items,itemName)
						-- For completed quests add items to a list so the inventory manager won't try to destroy them
						else
							table.insert(KarniQuestlist_Pending, itemName)
						end
					end
				end
			end
		end
	end
end






-- Check to see if any items are locked in inventory
function KarniCrap_IsLocked()
	for bag = 0, 4 do
		for slot = 0, GetContainerNumSlots(bag) do
			local _, _, locked = GetContainerItemInfo(bag, slot);
			if locked then return 1, "Locked" end
		end
	end
	return nil
end









-- show tab 1
function KarniCrap_ShowTab1()
	--KarniCrapPortrait:SetPortraitToTexture("Interface\\MERCHANTFRAME\\UI-BuyBack-Icon");
	SetPortraitToTexture(KarniCrapPortrait, "Interface\\MERCHANTFRAME\\UI-BuyBack-Icon")
	PanelTemplates_SetTab(KarniCrap, 1);
	KarniCrap_CategoryFrame:Show()
	KarniCrap_CategoryScrollBar:Show()
	KarniCrap_OptionsFrame:Show()
	KarniCrap_Tab1:Show();
	KarniCrap_Tab2:Hide();
	KarniCrap_Tab3:Hide();
	lasttab = 1
end


-- show tab 2
function KarniCrap_ShowTab2()
	PanelTemplates_SetTab(KarniCrap, 2)
	KarniCrap_CategoryFrame:Hide()
	KarniCrap_CategoryScrollBar:Hide()
	KarniCrap_OptionsFrame:Hide()
	-- force reload of blacklist and whitelist to try and prevent
	-- items showing in red
	KarniCrap_InitializeBlacklist()
	KarniCrap_InitializeWhitelist()
	KarniCrap_Tab1:Hide()
	KarniCrap_Tab2:Show()
	KarniCrap_Tab3:Hide()
	lasttab = 2
end


-- show tab 3
function KarniCrap_ShowTab3()
	PanelTemplates_SetTab(KarniCrap, 3)
	KarniCrap_CategoryFrame:Hide()
	KarniCrap_CategoryScrollBar:Hide()
	KarniCrap_OptionsFrame:Hide()
	KarniCrap_InventoryList()
	KarniCrap_Tab1:Hide()
	KarniCrap_Tab2:Hide()
	KarniCrap_Tab3:Show()
	lasttab = 3
end


function KarniCrap_Enable()
	KarniCrapConfig.Enabled = true
	KarniCrap_Scripts:RegisterEvent("LOOT_OPENED")
	KarniCrap_Scripts:RegisterEvent("LOOT_CLOSED")
	KarniCrap_Scripts:RegisterEvent("PARTY_MEMBERS_CHANGED")
	KarniCrap_Scripts:RegisterEvent("PLAYER_LEVEL_UP")
	KarniCrap_Scripts:RegisterEvent("QUEST_FINISHED")
	KarniCrap_Scripts:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	KarniCrap_Scripts:RegisterEvent("PLAYER_LOGIN")

	KarniCrap_Tab1:SetAlpha(1)
	KarniCrap_CategoryFrame:SetAlpha(1)
	KarniCrap_OptionsFrame:SetAlpha(1)
	KarniCrap_Tab2:SetAlpha(1)
	KarniCrap_Title:SetFontObject(GameFontHighlight)
	KarniCrap_CBEnabled:SetChecked(KarniCrapConfig.Enabled)
	KarniCrap_Tab3:SetAlpha(1)
end


function KarniCrap_Disable()
	KarniCrapConfig.Enabled = false
	KarniCrap_Scripts:UnregisterEvent("LOOT_OPENED")
	KarniCrap_Scripts:UnregisterEvent("LOOT_CLOSED")
	KarniCrap_Scripts:UnregisterEvent("PARTY_MEMBERS_CHANGED")
	KarniCrap_Scripts:UnregisterEvent("PLAYER_LEVEL_UP")
	KarniCrap_Scripts:UnregisterEvent("QUEST_FINISHED")
	KarniCrap_Scripts:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	KarniCrap_Scripts:UnregisterEvent("PLAYER_LOGIN")

	KarniCrap_Tab1:SetAlpha(0.3)
	KarniCrap_CategoryFrame:SetAlpha(0.3)
	KarniCrap_OptionsFrame:SetAlpha(0.3)
	KarniCrap_Tab2:SetAlpha(0.3)
	KarniCrap_Title:SetFontObject(GameFontDisable)
	KarniCrap_CBEnabled:SetChecked(KarniCrapConfig.Enabled)
	KarniCrap_Tab3:SetAlpha(0.3)
end


