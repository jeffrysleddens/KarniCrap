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


-- initialize (some of) the UI
local echo = KarniCrap_Echo



--[[
function initializeCloth()
	local previousCB 
	local cloth_list = {
		{ ["name"] = "Linen Cloth",
			["type"] = "Linen",
			["always"] = KarniCrapConfig.Cloth_Linen,
			["never"] = KarniCrapConfig.Cloth_Linen_Never	},
		{ ["name"] = "Wool Cloth",
			["type"] = "Wool",
			["always"] = KarniCrapConfig.Cloth_Wool,
			["never"] = KarniCrapConfig.Cloth_Wool_Never }, 
		{ ["name"] = "Silk Cloth", 				["type"] = "Silk" }, 
		{ ["name"] = "Mageweave Cloth", 	["type"] = "Mageweave" }, 
		{ ["name"] = "Runecloth", 				["type"] = "Runecloth" }, 
		{ ["name"] = "Netherweave Cloth", ["type"] = "Netherweave" }, 
		{ ["name"] = "Frostweave Cloth", 	["type"] = "Frostweave" } 
	}


for k,cloth in ipairs(cloth_list) do

		local cb_always = CreateFrame("CheckButton", "KarniCrap_Cloth_CB"..cloth["type"], KarniCrap_Cloth, "MyCheckButton")
		local cb_never = CreateFrame("CheckButton", "KarniCrap_Cloth_CB"..cloth["type"].."_Never", KarniCrap_Cloth, "MyCheckButton")
		local fs = cb_always:CreateFontString("$parent_Text")
		-- if "always" box is checked
		cb_always:SetScript("OnClick", function(self) 
			if (self:GetChecked()) then	
				cloth["always"] = true;							
				cloth["never"] = false;

				_G["KarniCrap_Cloth_CB"..cloth["type"].."_Never"]:SetChecked(false);
				
				--echo("1"..tostring(cloth["always"]))
				--echo("2"..tostring(KarniCrapConfig.Cloth_Linen))

		
				echo("value for always is "..tostring(KarniCrapConfig.Cloth_Linen))
				echo("value for never is "..tostring(KarniCrapConfig.Cloth_Linen_Never))

				--echo(cloth["type"].."(never) is "..tostring(cloth["never"]))
			else 
				cloth["always"] = false;
				--echo(cloth["type"].."(always) is "..tostring(cloth["always"]))	
			end	
		end )
		-- if "never" box is checked 
		cb_never:SetScript("OnClick", function(self) 
			if (self:GetChecked()) then	
			  cloth["always"] = false;							
				cloth["never"] = true;
				_G["KarniCrap_Cloth_CB"..cloth["type"] ]:SetChecked(false);
				echo(cloth["type"].."(always) is "..tostring(cloth["always"]))
				echo(cloth["type"].."(never) is "..tostring(cloth["never"]))

			else 
				cloth["never"] = false;
				echo(cloth["type"].."(never) is "..tostring(cloth["never"]))
			end
		end )


		-- label postioning
		fs:SetPoint("LEFT", -165, 1)
		fs:SetFontObject("GameFontNormalSmall")
		fs:SetText("|cFFFFFFFF["..cloth["name"].."]")
		-- positioning for checkboxes
		if k == 1 then
			cb_always:SetPoint("TOPLEFT", "KarniCrap_Cloth", "TOPLEFT", 175, -30)
			cb_never:SetPoint("TOPLEFT", cb_always, "TOPRIGHT")
			previousCB = cb_always
		else
			cb_always:SetPoint("TOPLEFT", previousCB, "BOTTOMLEFT", 0, 5)
			cb_never:SetPoint("TOPLEFT", cb_always, "TOPRIGHT")
			cb_always:SetText(cloth)
			previousCB = cb_always
		end
		_G["KarniCrap_Cloth_CB"..cloth["type"] ]:SetChecked(cloth["always"])
		_G["KarniCrap_Cloth_CB"..cloth["type"].."_Never"]:SetChecked(cloth["never"])
	end


]]--











--------------------------------------------------------------------------------
--<<                             Initialize UI                              >>--   
--------------------------------------------------------------------------------
-- Set the state of the UI when the player enters the world
function KarniCrap_InitializeUI()

 	KarniCrap_Version:SetText("Version "..KarniCrapConfig.Version);

	-- addon disabled
	if KarniCrapConfig.Enabled == false then 
		KarniCrap_Disable() 
	else 
		KarniCrap_Off:Hide()
		KarniCrap_CBEnabled:SetChecked(KarniCrapConfig.Enabled) 
	end	

	-- poor item thresholds
	KarniCrap_CBPoor:SetChecked(KarniCrapConfig.Poor)
	KarniCrap_Poor_GoldInputBox:SetNumber(KarniCrapConfig.PoorThreshold_Gold)
	KarniCrap_Poor_SilverInputBox:SetNumber(KarniCrapConfig.PoorThreshold_Silver)
	KarniCrap_Poor_CopperInputBox:SetNumber(KarniCrapConfig.PoorThreshold_Copper)
	KarniCrap_CheckButtonPoor()
	
	-- common item thresholds
	KarniCrap_Tab1_CBCommon:SetChecked(KarniCrapConfig.Common);
	KarniCrap_Tab1_CBCommonDesc_GoldInputBox:SetNumber(KarniCrapConfig.CommonThreshold_Gold)
	KarniCrap_Tab1_CBCommonDesc_SilverInputBox:SetNumber(KarniCrapConfig.CommonThreshold_Silver)
	KarniCrap_Tab1_CBCommonDesc_CopperInputBox:SetNumber(KarniCrapConfig.CommonThreshold_Copper)
	KarniCrap_CheckButtonCommon()
	
	-- misc settings
	KarniCrap_Tab1_CBUseStackValue:SetChecked(KarniCrapConfig.UseStackValue)
	KarniCrap_Tab1_CBEcho:SetChecked(KarniCrapConfig.Echo)

	-- corpse settings
	KarniCrap_Corpses_CBSkinnable:SetChecked(KarniCrapConfig.Skinnable)
	KarniCrap_Corpses_CBGatherable:SetChecked(KarniCrapConfig.Gatherable)
	KarniCrap_Corpses_CBMinable:SetChecked(KarniCrapConfig.Minable)
	KarniCrap_Corpses_CBEngineerable:SetChecked(KarniCrapConfig.Engineerable)
	KarniCrap_Corpses_CBSkilledEnough:SetChecked(KarniCrapConfig.SkilledEnough)
	
	-- tradeskills
	KarniCrap_Tradeskills_CBCooking:SetChecked(KarniCrapConfig.Cooking)
	KarniCrap_Tradeskills_CBFishing:SetChecked(KarniCrapConfig.Fishing)

	-- pickpocket (disabled unless player is a rogue)
	KarniCrap_Tradeskills_CBPickpocketing:SetChecked(KarniCrapConfig.Pickpocketing)
	KarniCrap_Tradeskills_CBPickpocketing:Disable()
	KarniCrap_Tradeskills_CBPickpocketing:SetAlpha(0.3)

	local localizedClass, englishClass = UnitClass("player")
	if englishClass == "ROGUE" then 
		KarniCrap_Tradeskills_CBPickpocketing:Enable()
		KarniCrap_Tradeskills_CBPickpocketing:SetAlpha(1)
	end

	-- cloth always
	KarniCrap_Cloth_CBLinen:SetChecked(KarniCrapConfig.Cloth_Linen)
	KarniCrap_Cloth_CBWool:SetChecked(KarniCrapConfig.Cloth_Wool)
	KarniCrap_Cloth_CBSilk:SetChecked(KarniCrapConfig.Cloth_Silk)
	KarniCrap_Cloth_CBMageweave:SetChecked(KarniCrapConfig.Cloth_Mageweave)
	KarniCrap_Cloth_CBRunecloth:SetChecked(KarniCrapConfig.Cloth_Runecloth)
	KarniCrap_Cloth_CBNetherweave:SetChecked(KarniCrapConfig.Cloth_Netherweave)
	KarniCrap_Cloth_CBFrostweave:SetChecked(KarniCrapConfig.Cloth_Frostweave)
	KarniCrap_Cloth_CBEmbersilk:SetChecked(KarniCrapConfig.Cloth_Embersilk)
	KarniCrap_Cloth_CBWindwool:SetChecked(KarniCrapConfig.Cloth_Windwool)
	-- cloth never
	KarniCrap_Cloth_CBLinen_Never:SetChecked(KarniCrapConfig.Cloth_Linen_Never)
	KarniCrap_Cloth_CBWool_Never:SetChecked(KarniCrapConfig.Cloth_Wool_Never)
	KarniCrap_Cloth_CBSilk_Never:SetChecked(KarniCrapConfig.Cloth_Silk_Never)
	KarniCrap_Cloth_CBMageweave_Never:SetChecked(KarniCrapConfig.Cloth_Mageweave_Never)
	KarniCrap_Cloth_CBRunecloth_Never:SetChecked(KarniCrapConfig.Cloth_Runecloth_Never)
	KarniCrap_Cloth_CBNetherweave_Never:SetChecked(KarniCrapConfig.Cloth_Netherweave_Never)
	KarniCrap_Cloth_CBFrostweave_Never:SetChecked(KarniCrapConfig.Cloth_Frostweave_Never)
	KarniCrap_Cloth_CBEmbersilk_Never:SetChecked(KarniCrapConfig.Cloth_Embersilk_Never)
	KarniCrap_Cloth_CBWindwool_Never:SetChecked(KarniCrapConfig.Cloth_Windwool_Never)

	-- scrolls
	KarniCrap_Scrolls_CBMaxScrolls:SetChecked(KarniCrapConfig.ScrollMax)
	KarniCrap_Scrolls_CBScrollAgility:SetChecked(KarniCrapConfig.Scroll_Agility)
	KarniCrap_Scrolls_CBScrollIntellect:SetChecked(KarniCrapConfig.Scroll_Intellect)
	KarniCrap_Scrolls_CBScrollProtection:SetChecked(KarniCrapConfig.Scroll_Protection)
	KarniCrap_Scrolls_CBScrollSpirit:SetChecked(KarniCrapConfig.Scroll_Spirit)
	KarniCrap_Scrolls_CBScrollStamina:SetChecked(KarniCrapConfig.Scroll_Stamina)
	KarniCrap_Scrolls_CBScrollStrength:SetChecked(KarniCrapConfig.Scroll_Strength)
	KarniCrap_CBMaxScrolls()
	
	-- food & water 
	KarniCrap_Consumables_RBFood1:SetChecked(KarniCrapConfig.NeverFood)
	KarniCrap_Consumables_RBFood2:SetChecked(KarniCrapConfig.AlwaysFood)
	KarniCrap_Consumables_CBFoodMax:SetChecked(KarniCrapConfig.FoodMax)
	KarniCrap_Consumables_RBWater1:SetChecked(KarniCrapConfig.NeverWater)
	KarniCrap_Consumables_RBWater2:SetChecked(KarniCrapConfig.AlwaysWater)
	KarniCrap_Consumables_CBWaterMax:SetChecked(KarniCrapConfig.WaterMax)
	KarniCrap_RBFood()
	KarniCrap_RBWater()
	
	-- potions 
	KarniCrap_Potions_RBHealth1:SetChecked(KarniCrapConfig.NeverHealth)
	KarniCrap_Potions_RBHealth2:SetChecked(KarniCrapConfig.AlwaysHealth)
	KarniCrap_Potions_CBHealthMax:SetChecked(KarniCrapConfig.HealthMax)
	KarniCrap_Potions_RBMana1:SetChecked(KarniCrapConfig.NeverMana)
	KarniCrap_Potions_RBMana2:SetChecked(KarniCrapConfig.AlwaysMana)
	KarniCrap_Potions_CBManaMax:SetChecked(KarniCrapConfig.ManaMax)
	KarniCrap_RBHealth()
	KarniCrap_RBMana()
	
	-- quality filtering
	KarniCrap_Quality_CBQualityPoor:SetChecked(KarniCrapConfig.Quality_Poor)
	KarniCrap_Quality_CBQualityCommon:SetChecked(KarniCrapConfig.Quality_Common)
	KarniCrap_Quality_CBQualityUncommon:SetChecked(KarniCrapConfig.Quality_Uncommon)
	KarniCrap_Quality_CBQualityRare:SetChecked(KarniCrapConfig.Quality_Rare)
	KarniCrap_Quality_CBQualityEpic:SetChecked(KarniCrapConfig.Quality_Epic)
	KarniCrap_Quality_CBQualityGrouped:SetChecked(KarniCrapConfig.Quality_Grouped)
	
	-- auto-destroy
	KarniCrap_CBDestroy:SetChecked(KarniCrapConfig.Destroy)
	KarniCrap_CBDestroySlots:SetChecked(KarniCrapConfig.DestroySlots)
	KarniCrap_EBDestroySlotsNum:SetNumber(KarniCrapConfig.DestroySlotsNum)
	KarniCrap_CBDestroyGroup:SetChecked(KarniCrapConfig.DestroyGroup)
	KarniCrap_CBDestroyRaid:SetChecked(KarniCrapConfig.DestroyRaid)
	KarniCrap_CBNoDestroyTradeskill:SetChecked(KarniCrapConfig.NoDestroyTradeskill)
	KarniCrap_DestroyUI()

	
	-- inventory
	KarniCrap_Inventory_CBHideQuestItems:SetChecked(KarniCrapConfig.HideQuestItems)
	KarniCrap_CBOpenAtMerchant:SetChecked(KarniCrapConfig.OpenAtMerchant)
	
	-- sorting
	if KarniCrapConfig.InvSort == "Stack Value" then
		KarniCrap_ValueHeader:SetText("Stack Value")
	elseif KarniCrapConfig.InvSort == "Item Value" then
		KarniCrap_ValueHeader:SetText("Item Value")
	else
		KarniCrap_ValueHeader:SetText("Current Value")
	end
	
	-- blacklist/whitelist
	KarniCrap_BtnDestroyItem:Disable();
	KarniCrap_InitializeBlacklist()
	KarniCrap_InitializeWhitelist()

	-- categories
	KarniCrap_InitializeCategories()
	KarniCrap_SelectCategory(1)

 end
