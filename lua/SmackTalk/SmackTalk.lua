-- Author: Souldoubt
-- Date: 11/2/2016
-- Let's talk some Smack. 


-- Global variables
rules = {}
numRules = 0


--============================ On Load and Event Registering =======================
function smackTalkRegisterEvent()
	--SmackTalkMain:RegisterEvent("PLAYER_REGEN_DISABLED")
	--SmackTalkMain:RegisterEvent("PLAYER_REGEN_ENABLED")
	--SmackTalkMain:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
	--SmackTalkMain:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
	--SmackTalkMain:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
	--SmackTalkMain:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	--SmackTalkMain:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
	--SmackTalkMain:RegisterEvent("COMBAT_TEXT_UPDATE")			-- This might be good in other addon for auras incoming heals
	--SmackTalkMain:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS") -- Creature hits you
	--SmackTalkMain:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
end

function processRuleEvents(rules)
	-- for i,v in pairs(rules) do
	-- 	--rules[i].trigger
	-- end
end

function processString(rules)
	--SendChatMessage("Blargh", "SAY", "Orcish");
end
--============================ Accessor/Utility Methods ====================================
function getRNG(percentToProc)
	randomRoll = math.random(1, (100/percentToProc))
	return randomRoll
end

--======== Do some stuff
function talkSmack(percentProc, SmackString)
	
	if getRNG(percentProc) == 1 then
		local myFaction = UnitFactionGroup("player")
		if (myFaction == "Alliance") then
			SendChatMessage(SmackString, "SAY", "Common")
		else
			SendChatMessage(SmackString, "SAY", "Orcish");
		end
	end
end

function ruleExists(ruleID)
	if rules[ruleID] == nil then
		return false
	else
		return true
	end
end

--============================ Rule Constructor/Destructor/Mutator Methods =========
function createNewRule(theTrigger, theProcRate, theNumStr, strArray)
	local ruleTable = {trigger=theTrigger, procRate=theProcRate, numStr=theNumStr, strings=strArray}
	numRules = numRules+1 --Create and index one higher than the current index
	rules[numRules]=ruleTable
end
 
function modifyRule(ruleID, newTrigger, newProcRate, newNumStr, newStrArray)
  if ruleExists(ruleID) then
	rules[ruleID].trigger = newTrigger
	rules[ruleID].procRate = newProcRate
	rules[ruleID].numStr = newNumStr
	rules[ruleID].strings = newStrArray
  end
end

function replaceRule(ruleID, newRuleTable)
	if ruleExists(ruleID) then
		rules[ruleID] = newRuleTable
	else
		printf("Nothing to replace, derp derp")
	end
end

function deleteRule(ruleID)
	if ruleExists(ruleID) then
		table.remove(rules, ruleID)
		numRules = numRules - 1
	else
		printf("Rule "..ruleID.." doesn't exist!")
	end
end

--==================================================================================
--============================ Modify Notification strings in exisiting rule =======
function addStrToRule(ruleID, newString)
	if ruleExists(ruleID) then
		rules[ruleID].numStr = rules[ruleID].numStr + 1   -- increment numStr in table
		table.insert(rules[ruleID].strings, newString)
	end
end


function deleteStrFromRule(ruleID, strToDelete)
	if ruleExists(ruleID) then
		for i=1,rules[ruleID].numStr do
			if string.find(rules[ruleID].strings[i], strToDelete) ~= nil then
				table.remove(rules[ruleID].strings, i)
				rules[ruleID].numStr = rules[ruleID].numStr - 1
			end
		end
	else
		printf("Rule "..i.." doesn't exist!")
	end
end


--============================ Event Handler(s) =====================================
function smackEventHandler()
	smackMsg = arg1
	printEvents(event, smackMsg)
	if ( event == "COMBAT_TEXT_UPDATE" ) then
		printf("Arg2: "..arg2)
		printf("Arg3: "..arg3)
		printf("Arg4: "..arg4)
		printf("Arg5: "..arg5)
		printf("Arg6: "..arg6)

	end
end

--============================ printf Entire Rule Table Func() ======================
function printRuleTable(someTable)
	for i,v in pairs(someTable) do
		printf("=========== Rule "..i.." ==========")
		printf("Trigger: "..someTable[i].trigger)
		printf("Proc %:  "..someTable[i].procRate)
		printf("numStr:  "..someTable[i].numStr)
	
		for y=1,someTable[i].numStr do
		      printf("String "..y.." : "..someTable[i].strings[y])
		end
	      printf("\n")
	end
end

--======================== printEvent debug function  ============================
function printEvents(theEvt, theMsg)
	printcolor(cMAGENTA, "EVENT: "..theEvt)
	printcolor(cSEXTEAL, "MESSAGE: "..theMsg)
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