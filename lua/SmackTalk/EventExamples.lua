==================  "PLAYER_REGEN_DISABLED"  ==================================================
Event happens when player enters comabt

==================  "PLAYER_REGEN_ENABLED"  ===================================================
Event is fired when player leaves combat

==================  "CHAT_MSG_COMBAT_SELF_HITS"  ==============================================
White hits that you land on enemy
White crits, and glancing blows are also here

==================  "CHAT_MSG_COMBAT_SELF_MISSES"  ============================================
Attempt to white hit, but you miss, enemy dodges, enemy parries

==================  "CHAT_MSG_SPELL_SELF_BUFF"  ===============================================
Blood rage initial 10 rage, but not ticks

==================  "CHAT_MSG_SPELL_SELF_DAMAGE"  =============================================
"Yellow" abilities in combat log. Heroic strike is an example
Direct damage spells like "Starfire"
Misses are in here too. For example A sunder armor miss shows up here, but not successful sunder


==================  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"  ====================================


==================  "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS"  =====================================
Most buffs fall into this category. 
blood rage ticks
battleshout 
Clearcasting
Gaining first aid
First aid ticks

==================  "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS"    ================================
Creature melees you. Hits, crits, crushes

==================  "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES"  ================================
Player dodges or parries or enemy misses


=================== Advanced Parsing =====================
==================  "COMBAT_TEXT_UPDATE"   ===================================================

This event fires but has more than just message. It has things like AURA_START, AURA_END, 
AURA_HARMFUL_START, AURA_HARMFUL_END (Debuffs)

Example simple structure is:
EVENT: COMBAT_TEXT_UPDATE
arg1:   AURA_START
arg2:   Berserker Stance

EVENT: COMBAT_TEXT_UPDATE
arg1:   AURA_START
arg2:   First Aid

EVENT: COMBAT_TEXT_UPDATE
arg1:   AURA_START_HARMFUL
arg2:   Recently Bandaged

INCOMING HEAL Example:
EVENT: COMBAT_TEXT_UPDATE
arg1: Caster Name
arg2: Amount healed

GAINING REPUTATION Example:
arg1: FACTION
arg2: Stormwind
arg3: 27  (amount of rep gained)

Spell becomes active:
arg1: SPELL_ACTIVE
arg2: Overpower

arg1: SPELL_ACTIVE
arg2: Execute