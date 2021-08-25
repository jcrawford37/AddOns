--=================== Global Variables ==========================================
Clock_UpdateInterval = 20;          --OnUpdate function limiter.
clockCounter = 0;                   --Variable to increment with OnUpdate arg1
local_time_offset = -7               --I'm MDT so offset is GMT -7 currently


--=========== Soul Clock "OnSomething" Handlers for SoulClock.xml ===============
function SoulClock_OnLoad()
    SmackTalkMain:RegisterEvent("PLAYER_LOGIN")
    SmackTalkMain:RegisterEvent("PLAYER_ENTERING_WORLD")
    SoulClock:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
    SetClockString();

    SLASH_SCLOCKGMT1 = "/setgmt"
    local function SetGmtSlash(msg, editbox)
        SetGmtOffset(msg)
    end
    
    -- Register function to slash command
    SlashCmdList["SCLOCKGMT"] = SetGmtSlash

end

function Clock_OnUpdate()
        clockCounter = clockCounter + arg1
        
        if clockCounter > Clock_UpdateInterval then
            SetClockString()
            SetXPString()
            clockCounter = 0
        end     
end

--========== Event Handler =====================
function SoulClock_EventHandler()
    if event == "CHAT_MSG_COMBAT_XP_GAIN" then
        SetXPString();
    end
        
end

--=========== Set your GMT offset for your timezone ================
function SetGmtOffset(new_time_offset)
    printf("You adjusted your clock to GMT"..new_time_offset)
    local_time_offset = new_time_offset
    SetClockString()
end

--=========== Get Server Time, convert to your local time ==============
function SetClockString()
    local hh, mm = GetGameTime();  -- Get hours and minutes from Server
    
    -- put hours variable into local time
    hh = hh + local_time_offset

    -- If server time is next morning
    -- wrap around so that you don't get a negative hour value
    if hh <= 0 then
        hh = hh + 12
    end

    --==== Set the clock string that displays in the little clock box =====--
    SoulClockClockString:SetText(string.format("%d:%02d", hh, mm));
end

--============= Set the String of % of XP ====================
function SetXPString()
    local currentXP = UnitXP("player")
    local maxXP = UnitXPMax("Player")
    local percentXP = (currentXP / maxXP)*100
    
    SoulClockXPString:SetText(string.format("XP: %.1f %%", percentXP));
end

