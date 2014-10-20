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
