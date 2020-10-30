local MAX_TALENT_TIERS=7
local MAX_TALENT_COLUMNS=3
local CHANGE_SPELL_IDS = {227041, 256231, 226241, 256229}

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded

local function Print(msg)
	print("|cff03C6FCTalents|r - " ..msg)
end

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Talents" then
		Print("AddOn loaded successfully");
	end
end

frame:SetScript("OnEvent", frame.OnEvent);

local function Tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local function CheckFirstUse()
	if TalentsData == nil or Tablelength(TalentsData) == 0 then
		TalentsData = {}
		local specs = GetNumSpecializations()
		for i=1,specs do
			TalentsData[i] = {}
		end
	end
end

local function CanUse()
	if IsResting() or (C_PvP.GetActiveMatchState() == 1 and C_PvP.GetActiveMatchDuration() == 0) then
		return true
	end
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, spellID = UnitAura("player", i, "HELPFUL")
		if spellID then
			if tContains(CHANGE_SPELL_IDS, spellID) then
				return true
			end
		end
	end
	return false
end

function SplitString(s, delimiter)
	if s == nil then
		return nil
	end
     local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function SaveCurrentTalents(profile)
	CheckFirstUse()
	local selectedTalents = ""
	local currentSpec = GetSpecialization()
	-- Get PvE (normal) talents
	for tier=1, MAX_TALENT_TIERS do
		for col=1, MAX_TALENT_COLUMNS do
			talentID, name, texture, selected, available, spellID, unknown, row, colun, unknown, known = GetTalentInfo( tier, col, 1)
			if selected then
				selectedTalents = selectedTalents .. col
				break
			end

		end
	end
	selectedTalents = selectedTalents .. "#"
	-- Get PvP talents
	for i,v in ipairs(C_SpecializationInfo.GetAllSelectedPvpTalentIDs()) do selectedTalents = selectedTalents .. (i==1 and "" or "|") .. v end
	TalentsData[currentSpec][profile] = selectedTalents
	Print("... |cff00FF00success!|r")
end

local function LoadTalents(profile)
	CheckFirstUse()
	if not CanUse() then
		Print("... |cffFF0000Failed|r. You need to be in a |cff03C6FCrested XP area|r or use a |cff00FF00Tome of the Tranquil Mind|r.")
		return
	end
	local currentSpec = GetSpecialization()
	local talents  = TalentsData[currentSpec][profile]
	if talents == nil then
		Print("... |cffFF0000Failed|r. Profile |cffFF0000" .. profile .. "|r not found.")
		return
	end
	talents = SplitString(talents, "#")
	local talentsPvE = talents[1];
	local talentsPvP = SplitString(talents[2], "|");
	for i=1,talentsPvE:len() do
		if talentsPvE:sub(i,i) ~= "_" then
			LearnTalent(GetTalentInfo(i,talentsPvE:sub(i,i),1))
		end
	end
	if talentsPvP ~= nil then 
		for i=1,3 do
			LearnPvpTalent(talentsPvP[i], i)
		end
	end
	Print("... |cff00FF00success!|r")
end

local function ListTalents(profile)
	CheckFirstUse()
	local currentSpec = GetSpecialization()
	local profiles  = TalentsData[currentSpec]
	for key,value in pairs(profiles) do
		print("  - " .. key)
	end
end

local function DeleteProfile(profile)
	CheckFirstUse()
	local currentSpec = GetSpecialization()
	local talents  = TalentsData[currentSpec][profile]
	if talents == nil then
		Print("... |cffFF0000Failed|r. Profile |cffFF0000" .. profile .. "|r not found.")
		return
	end
	TalentsData[currentSpec][profile] = nil
	Print("... |cff00FF00success!|r")
end

SLASH_TALENTS1 = "/talents";
SLASH_TALENTS2 = "/ts";

SlashCmdList["TALENTS"] = function(msg)
	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

	if (cmd == "save" or cmd == "s") and args ~= "" then
		Print("Saving profile: " .. args)
		SaveCurrentTalents(args)
	elseif (cmd == "use" or cmd == "u") and args ~= "" then
		Print("Loading profile: " .. args)
		LoadTalents(args)
	elseif (cmd == "list" or cmd == "l" or cmd == "ls") and args == "" then
		Print("Registered profiles: ")
		ListTalents()
	elseif (cmd == "delete" or cmd == "d" or cmd == "del") and args ~= "" then
		Print("Deleting profile: " .. args)
		DeleteProfile(args)
	else
		print("|cff03C6FC-- Talents help --|r")
		print("|cff00FF00/talents|r list -- list all available profiles for current spec.")
		print("|cff00FF00/talents|r save profile-name -- save your current talents as 'profile-name'")
		print("|cff00FF00/talents|r use profile-name -- change to profile's talents")
		print("|cff00FF00/talents|r delete profile-name -- delete the profile")
	end

end