--LUA functions to loop through bag and get quality
-- Could use gross Hex code for color gray, don't like it though


--=================== Global Variables ==========================================
GraySaleUpdateInterval = 1.0;			--OnUpdate function limiter.
GraySaleCounter = 0;					--Variable to increment with OnUpdate arg1
graySaleDebug = false;					--Set to true for extra, helpful printf's
LoopSellEnable = false;
totalGrays = 0;
trashList = {};

--========================================Slash Command ================================================
function GraySale_OnLoad()
	SLASH_GRAYSALEADD1, SLASH_GRAYSALEREM1, SLASH_GRAYSALEPRINT1 = "/addtotrash", "/removefromtrash", "/printtrash";
	local function graySaleAdd(msg, editbox)
		addToTrashList(msg)
	end
	
	local function graySaleRemove(msg, editbox)
		removeFromTrashList(msg)
	end
	
	local function graySalePrint(msg, editbox)
		printTrashList()
	end
	-- Register function to slash command
	SlashCmdList["GRAYSALEADD"] = graySaleAdd
	SlashCmdList["GRAYSALEREM"] = graySaleRemove
	SlashCmdList["GRAYSALEPRINT"] = graySalePrint
end

--============================= Boolean to see if an item is a gray ====================================
function isGray(itemId)
	local itemIsGray = false;
	-- select 3 gets the quality 
	if (itemId ~= nil) then
		if (select(3, GetItemInfo(itemId)) == 0) then
			itemIsGray = true
		end
	end
	return itemIsGray
end

--============================= Boolean to see if an item is on trashList ==============================
function isTrash(itemId)
	local itemIsTrash = false;
	-- select 1 gets the quality 
	if (itemId ~= nil) then
		for i,v in pairs(trashList) do
			if (itemId==itemLinkToItemId(v)) then
				if (graySaleDebug) then
					printf("Ermahgerd! Trash! -->"..v)
				end
				itemIsTrash = true
				break
			end
		end	
	end
	return itemIsTrash
end

--=========================Add commonly sold Item to the Trash List to be treated as a gray ============
function addToTrashList(itemLink)
	local found = false
	for i,v in pairs(trashList) do
		if (v == itemLink) then
			found = true;
			break;
		end
	end
	if (found) then
		printf("Item already on Trash List.")
	else
		printf("Added item "..itemLink.." to trash list.")
		table.insert(trashList, itemLink)
	end
end

--===================================== Remove an Item from the Trash List =============================
function removeFromTrashList(itemLink)
	local found = false
	if itemLink == "*" then
		for k in pairs(trashList) do
			trashList[k] = nil
		end
		printf("Trash List Cleared!")
		return
	end

	for i,v in pairs(trashList) do
		if (v == itemLink) then
			found = true;
			table.remove(trashList, i)
			printf("Item "..v.." removed from Trash List.")
			break;
		end
	end
	if not (found) then
		printf("Item is not on Trash List.")
	end
end


--===================================== Print the Trash List ===========================================
function printTrashList()
	printf("======== Trash List ========")
	for i,v in pairs(trashList) do
		printf("Item "..i..": "..v)
	end
end


--=========================== Get the itemId from the itemLink in a given bag/slot =====================
function GetContainerItemId(bagId, bagSlot)
	local itemId, tempItemLink

	-- Get itemLink (only function for bag scrubbing 1.12)
	tempItemLink = GetContainerItemLink(bagId, bagSlot);


	--Don't process stuff unless it's not nil, aka something in slot.
	if tempItemLink ~= nil then
		if (graySaleDebug) then
			printf(tempItemLink)
		end
		-- Escape the characters with ascii 124
		itemId = string.gsub(tempItemLink, "\124", "\124\124")
		
		if (graySaleDebug) then
			printf(itemId)
		end
		
		-- Strip off first half of item link
		itemId = string.gsub(itemId,"|.*Hitem:?","")
		if (graySaleDebug) then
			printf(itemId)
		end
		
		
		
		-- Strip off the last half of item link crap
		itemId = string.gsub(itemId,":%d:%d:%d?.*%]*","")
		if (graySaleDebug) then
			printf(itemId)
		end
	else
		itemId = nil;
	end
	
	return itemId
end

--=================================== Translate a single item link to an item id =======================
function itemLinkToItemId(itemLink)
	local itemId, tempItemLink
	-- Get itemLink (only function for bag scrubbing 1.12)
	tempItemLink = itemLink;
	
	--Don't process stuff unless it's not nil, aka something in slot.
	if tempItemLink ~= nil then
		if (graySaleDebug) then
			printf(tempItemLink)
		end
		-- Escape the characters with ascii 124
		itemId = string.gsub(tempItemLink, "\124", "\124\124")
		
		if (graySaleDebug) then
			printf(itemId)
		end
		
		-- Strip off first half of item link
		itemId = string.gsub(itemId,"|.*Hitem:?","")
		if (graySaleDebug) then
			printf(itemId)
		end
		
		
		
		-- Strip off the last half of item link crap
		itemId = string.gsub(itemId,":%d:%d:%d?.*%]*","")
		if (graySaleDebug) then
			printf(itemId)
		end
	else
		itemId = nil;
	end
	
	return itemId
end

--========================= loop through bags, sell if quality 0 or item is on trash list ==============
function SellJunk()
	--Loop through each bag
	for theBag=0,4 do 
		--Loop through each slot in said bag
		for theSlot=1,GetContainerNumSlots(theBag) do
			if isGray(GetContainerItemId(theBag, theSlot)) or isTrash(GetContainerItemId(theBag, theSlot)) then
				UseContainerItem(theBag, theSlot)
				if (graySaleDebug) then
					printf("Sold: "..GetContainerItemLink(theBag, theSlot))
				end
				break
			else
				if (graySaleDebug) then
					printf("Not Selling Thing in (bag,slot): "..theBag..","..theSlot)
				end
			end
		
		end
	end
	
end


--======================= Function to fire off when "Sell Junk" button is clicked ======================
function EnableLoopSale()
		
	for theBag=0,4 do 
		--Loop through each slot in said bag
		for theSlot=1,GetContainerNumSlots(theBag) do
			if isGray(GetContainerItemId(theBag, theSlot)) or isTrash(GetContainerItemId(theBag, theSlot)) then
				totalGrays = totalGrays + 1
			else
				if (graySaleDebug) then
					printf("Not Selling Thing in (bag,slot): "..theBag..","..theSlot)
				end
			end
		
		end
	end
	
	if (LoopSellEnable ~= true) and (totalGrays > 0) then
		printf("Total Trash Items: "..totalGrays)
		LoopSellEnable = true;
		PlaySoundFile("Sound\\Creature\\Peon\\PeonYes3.wav")
	elseif (totalGrays == 0) then
		printcolor(cSEXGREEN, "No grays to sell")
		PlaySoundFile("Sound\\Creature\\Peon\\PeonWhat4.wav")
		--printf("No Junk to sell!")
	end	
end


--============ Let's try to do this loop thing onUpdate I guess as a quasi-timer thing =================
function GraySale_OnUpdate()
	--Just exit if the button isn't clicked
	if (LoopSellEnable ~= true) then
		return
	end
	
	--"arg1" gets passed in from XML <OnUpdate> as current ticking time in hundredths of a second
	GraySaleCounter = GraySaleCounter + arg1
		
	if GraySaleCounter > GraySaleUpdateInterval then
		--Do Stuff or Call Func
		printcolor(cSEXGREEN,"Selling Trash Item: "..totalGrays)
		--printf("Selling Trash Item: "..totalGrays)
		SellJunk()
		GraySaleCounter = 0;
		totalGrays = totalGrays - 1;
	end 
	
	if (totalGrays == 0) then
		--printf("Done Selling Trash!")
		printcolor(cSEXGREEN,"Done Selling Trash!")
		LoopSellEnable = false;
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