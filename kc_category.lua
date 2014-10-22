--------------------------------------------------------------------------------
--<<                            Option Categories                           >>--   
--------------------------------------------------------------------------------

local category_selected = 1	
local category_maxvisible = 10
local category_numitems = 8
local category_items = {}
	category_items[1] = { 	["frame"] = "KarniCrap_Destroy", 		["display"] = "Auto-Destroy" }
	category_items[2] = { 	["frame"] = "KarniCrap_Cloth", 			["display"] = "Cloth" }
	category_items[3] = { 	["frame"] = "KarniCrap_Corpses", 		["display"] = "Corpses" }
	category_items[4] = { 	["frame"] = "KarniCrap_Consumables",		["display"] = "Food & Water" }
	category_items[5] = { 	["frame"] = "KarniCrap_Potions", 		["display"] = "Potions" }
	category_items[6] = { 	["frame"] = "KarniCrap_Quality", 		["display"] = "Quality" }
	category_items[7] = { 	["frame"] = "KarniCrap_Scrolls", 		["display"] = "Scrolls" }
	category_items[8] = { 	["frame"] = "KarniCrap_Tradeskills",		["display"] = "Tradeskills" }
	--category_items[5] = {	["frame"] = "KarniCrap_Pickpocketing", 		["display"] = "Pickpocketing" }
	--category_items[2] = {	["frame"] = "KarniCrap_BOP", 			["display"] = "BOP Warnings" }



function KarniCrap_InitializeCategories()
	local line
 	for line = 1, category_maxvisible do
 		if category_items[line] then
 			_G["CategoryItem"..line.."_Name"]:SetText(category_items[line].display)
 		end
	end
end


function KarniCrap_SelectCategory(id)
	local line, name

	category_selected = id	
	for line = 1, category_numitems do
		name = _G["CategoryItem"..line.."_Name"]:GetText()

		if (_G["CategoryItem"..line]:GetID() == id ) then
			_G["CategoryItem"..line]:LockHighlight();
			KarniCrap_OptionsFrame_Header:SetText(name)
			_G[category_items[line].frame]:Show()
		else 
			_G["CategoryItem"..line]:UnlockHighlight();
			_G[category_items[line].frame]:Hide()
		end
	end
end


-- handles the option categories scroll area. Not enough options to need it yet :)
function KarniCrap_CategoryScrollBarUpdate()
	local line, lineplusoffset; -- an index of our data calculated from the scroll offset

	FauxScrollFrame_Update(KarniCrap_CategoryScrollBar,category_numitems,category_maxvisible,16);
	for line = 1, category_maxvisible do
		-- create the button frames for the list
		lineplusoffset = line + FauxScrollFrame_GetOffset(KarniCrap_CategoryScrollBar);
		if lineplusoffset < category_numitems + 1 then
			_G["CategoryItem"..line]:Show();
		else
			_G["CategoryItem"..line]:Hide();
		end
	end
end
