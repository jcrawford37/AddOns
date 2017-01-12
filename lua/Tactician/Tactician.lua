-- 12/26/2016
-- 3 accessible functions to set dual-wield, 2H, sword board or assorted weapon swaps

--=================== Global Variables ==========================================
numWepSets = 0
tactWeaponTable = {}

--=================== OnLoad function  ==========================================
function Tactician_OnLoad()
	
	-- SLASH_GRAYSALEADD1, SLASH_GRAYSALEREM1, SLASH_GRAYSALEPRINT1 = "/addtotrash", "/removefromtrash", "/printtrash";
	-- local function graySaleAdd(msg, editbox)
	-- 	addToTrashList(msg)
	-- end
	
	-- local function graySaleRemove(msg, editbox)
	-- 	removeFromTrashList(msg)
	-- end
	
	-- local function graySalePrint(msg, editbox)
	-- 	printTrashList()
	-- end
	-- -- Register function to slash command
	-- SlashCmdList["GRAYSALEADD"] = graySaleAdd
	-- SlashCmdList["GRAYSALEREM"] = graySaleRemove
	-- SlashCmdList["GRAYSALEPRINT"] = graySalePrint
end





--=================== Set Accessor / Mutator functions  =========================
function createWeaponSet(weaponSetID, theMainHand, theOffHand)
	if not setAlreadyExists(weaponSetID) then
		tactWeaponTable[weaponSetID] = {}
		tactWeaponTable[weaponSetID].mainHand = theMainHand
		tactWeaponTable[weaponSetID].offHand = theOffHand
		numWepSets = numWepSets + 1
	else
		printf("Can't create set: "..weaponSetID..". Set already exists.")
	end
end

function removeWeaponSet(weaponSetID, theMainHand, theOffHand)
	if setAlreadyExists(weaponSetID) then
		tactWeaponTable[weaponSetID] = nil
	else
		printf("Can't remove "..weaponSetID..". Set doesn't exist.")
	end
end

function updateWeaponSet(weaponSetID, thMainHand, theOffHand)
	if setAlreadyExists(weaponSetID) then
		tactWeaponTable[weaponSetID].mainHand = theMainHand
		tactWeaponTable[weaponSetID].offHand = theOffHand
	else
		printf("Can't update set. Weapon set doesn't exist.")
	end
end

function setAlreadyExists(weaponSetID)
	-- if tactWeaponTable[weaponSetID] ~= nil then
	-- 	return 1
	-- end
	-- return nil
	return false
end

--=================== Meat and Potato functions  ================================
function equipMainHand(bagNum, bagSlot)
	PickupContainerItem(bagNum, bagSlot)
	-- Inventory Item 16 is the main hand weapon slot
	PickupInventoryItem(16)
end

function equipOffHand(bagNum, bagSlot)
	PickupContainerItem(bagNum, bagSlot)
	-- Inventory Item 17 is offhand weapon slot
	PickupInventoryItem(17)
end

function findWeaponInBag(theItemLink)
	for theBag=0,4 do
		for theSlot=1,GetContainerNumSlots() do
			local tempItemLink = GetContainerItemLink(theBag, theSlot)
			if tempItemLink == theItemLink then
				return theBag, theSlot
			end
		end
	end
	return nil
end

function equipWeaponSet(weaponSetID)
	if not tactWeaponTable[weaponSetID] then
		printf("Can't equip: "..weaponSetID..". Set doesn't exist.")
		return nil
	end

	local bagID, slotID

	if tactWeaponTable[weaponSetID].mainHand ~= nil then
		bagID, slotID = findWeaponInBag(tactWeaponTable[weaponSetID].mainHand)
		if bagID ~= nil then
			equipMainHand(bagID, slotID)
		else
			printf("Can't find "..tactWeaponTable[weaponSetID].mainHand.." in your bags.")
		end
	end

	if tactWeaponTable[weaponSetID].mainHand ~= nil then
		bagID, slotID = findWeaponInBag(tactWeaponTable[weaponSetID].offHand)
		if bagID ~= nil then
			equipOffHand(bagID, slotID)
		else
			printf("Can't find "..tactWeaponTable[weaponSetID].offHand.." in your bags.")
		end
	end
end

--======================== Print a weapon set to console ==================================
function printWeaponSet(weaponSetID)
	if tactWeaponTable[weaponSetID] == nil then
		printf("Set "..weaponSetID.." doesn't exist.")
		return
	end
	
	printf("========  "..weaponSetID.." Weapon Set ========")
	printf("Main Hand: "..tactWeaponTable[weaponSetID].mainHand)

	if tactWeaponTable[weaponSetID].offHand ~= nil then
		printf("Off Hand: "..tactWeaponTable[weaponSetID].offHand)
	else
		printf("Off Hand: Empty")
	end
end





--==================== MISC Printf Wrapper stuff==================================
function printf(guts)
	DEFAULT_CHAT_FRAME:AddMessage(guts);
end

function printcolor(hex, guts)
	DEFAULT_CHAT_FRAME:AddMessage("|"..hex..guts);	
end

function printbox(guts)
	message(guts);
end


function select (index, ...)
	local tbl = arg
	if type(arg[1]) == "table" and arg[2] == nil then
		tbl = arg[1]
	end
	if index == "#" then
		return tbl and table.getn(tbl) or 0
	else
		return tbl and tbl[index]
	end
end

--======================= Color Codes for print color ==============================================

cLIGHTRED     	=	"cffff6060"
cLIGHTBLUE    	=	"cff00ccff"
cTORQUISEBLUE	=	"cff00C78C"
cSPRINGGREEN	=	"cff00FF7F"
cGREENYELLOW  	=	"cffADFF2F"
cBLUE         	=	"cff0000ff"
cPURPLE			=	"cffDA70D6"
cGREEN	    	=	"cff00ff00"
cRED          	=	"cffff0000"
cGOLD         	=	"cffffcc00"
cGOLD2			=	"cffFFC125"
cGREY         	=	"cff888888"
cWHITE        	=	"cffffffff"
cSUBWHITE     	=	"cffbbbbbb"
cMAGENTA      	=	"cffff00ff"
cYELLOW       	=	"cffffff00"
cORANGEY		=	"cffFF4500"
cCHOCOLATE		=	"cffCD661D"
cCYAN         	=	"cff00ffff"
cIVORY			=	"cff8B8B83"
cLIGHTYELLOW	=	"cffFFFFE0"
cSEXGREEN		=	"cff71C671"
cSEXTEAL		=	"cff388E8E"
cSEXPINK		=	"cffC67171"
cSEXBLUE		=	"cff00E5EE"
cSEXHOTPINK		=	"cffFF6EB4"