#!/usr/bin/env lua

smackObj = require("smackTables")
--[[ =============================================================================]]
--[[ =============     UNIT TEST FOR SMACK TALK TABLE FUNCTIONS     ==============]]
--[[ =============================================================================]]

--:::: TEST CREATE NEW VALID RULE
smackObj.createNewRule("EVENT_A", 25, 2, {"Stuff", "Things"})
print("----- Testing Original Rule -----")
smackObj.printRuleTable(rules)

--:::: TEST ADD A NEW STRING TO EXISTING RULE
smackObj.addStrToRule(1, "Whadddup")
print("----- Testing after adding string to rule -----")
smackObj.printRuleTable(rules)

--:::: TEST DELETION OF STRING FROM EXISTING RULE
smackObj.deleteStrFromRule(1, "Whadddup")
print("----- Testing after deleting string from rule -----")
smackObj.printRuleTable(rules)

--:::: TEST COMPLETE DELETION OF RULE
smackObj.deleteRule(1)
print("----- Testing After Delete -----")
smackObj.printRuleTable(rules)

