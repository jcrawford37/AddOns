#!/usr/bin/env lua

-- local table to export for external require statements
local smackTables = {}

-- "Class" member variables
rules = {}
numRules = 0

--============================ Accessor/Utility Methods ====================================
function smackTables.getRules()
	return rules
end

function smackTables.getNumRules()
	return numRules
end

function smackTables.ruleExists(ruleID)
	if rules[ruleID] == nil then
		return false
	else
		return true
	end
end

--============================ Rule Constructor/Destructor/Mutator Methods =========
function smackTables.createNewRule(theTrigger, theProcRate, theNumStr, strArray)
local ruleTable = {trigger=theTrigger, procRate=theProcRate, numStr=theNumStr, strings=strArray}
numRules = numRules+1 --Create and index one higher than the current index
rules[numRules]=ruleTable
end
 
function smackTables.modifyRule(ruleID, newTrigger, newProcRate, newNumStr, newStrArray)
  if rules[ruleID] ~= nil then
  	rules[ruleID].trigger = newTrigger
  	rules[ruleID].procRate = newProcRate
  	rules[ruleID].numStr = newNumStr
  	rules[ruleID].strings = newStrArray
  end
end

function smackTables.replaceRule(ruleID, newRuleTable)
	if rules[ruleID] ~= nil then
		rules[ruleID] = newRuleTable
	else
		print("Nothing to replace, derp derp")
	end
end

function smackTables.deleteRule(ruleID)
	if smackTables.ruleExists(ruleID) then
		table.remove(rules, ruleID)
		numRules = numRules - 1
	else
		print("Rule "..ruleID.." doesn't exist!")
	end
end


--============================ Modify Notification strings in exisiting rule =======
function smackTables.addStrToRule(ruleID, newString)
	if smackTables.ruleExists(ruleID) then
		rules[ruleID].numStr = rules[ruleID].numStr + 1   -- increment numStr in table
		table.insert(rules[ruleID].strings, newString)
	end
end


function smackTables.deleteStrFromRule(ruleID, strToDelete)
	if smackTables.ruleExists(ruleID) then
		for i=1,rules[ruleID].numStr do
			if string.find(rules[ruleID].strings[i], strToDelete) ~= nil then
				table.remove(rules[ruleID].strings, i)
				rules[ruleID].numStr = rules[ruleID].numStr - 1
			end
		end
	else
		print("Rule "..i.." doesn't exist!")
	end
end






--============================ Print Entire Rule Table Func() ======================
function smackTables.printRuleTable(someTable)
for i,v in pairs(someTable) do
print("=========== TABLE "..i.."==========")
print("Trigger: "..someTable[i].trigger)
print("Proc %:  "..someTable[i].procRate)
print("numStr:  "..someTable[i].numStr)
for y=1,someTable[i].numStr do
              print("String "..y.." : "..someTable[i].strings[y])
end
print("\n")
end
end


--======== Return "Class" table to requiring script ================================
return smackTables

