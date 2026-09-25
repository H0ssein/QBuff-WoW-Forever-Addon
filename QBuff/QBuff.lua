local addonName, addonTable = ...

local DEBUG_MODE = true

local function DebugPrint(msg, ...)
    if DEBUG_MODE then
        print(string.format("|cffaaaaaa[QBuff Debug]|r " .. msg, ...))
    end
end

local function GetClassColoredName(name, class)
    if not name then return "Unknown" end
    if class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class] then
        local color = RAID_CLASS_COLORS[class]
        local colorStr = color.colorStr or string.format("ff%02x%02x%02x", color.r*255, color.g*255, color.b*255)
        return "|c" .. colorStr .. name .. "|r"
    end
    return name
end

local Config = {
    Size = 44,
    Point = "CENTER",
    RelativePoint = "CENTER",
    X = 0,
    Y = -150,
}

local ClassBuffs = {
    ["PRIEST"] = {"Power Word: Fortitude"},
    ["MAGE"] = {
        "Arcane Intellect",
        "Dampen Magic",
        "Amplify Magic",
        "Frost Armor",
        "Ice Armor",
        "Mage Armor",
        "Mana Shield",
        "Ice Barrier",
        "Fire Ward",
        "Frost Ward",

    },
    ["DRUID"] = {"Mark of the Wild", "Thorns"},
    ["PALADIN"] = {"Blessing of Might", "Blessing of Wisdom", "Blessing of Kings"},
    ["WARLOCK"] = {"Demon Armor", "Unending Breath", "Detect Invisibility"},
    ["SHAMAN"] = {"Lightning Shield", "Rockbiter Weapon", "Flametongue Weapon", "Water Walking"},
    ["WARRIOR"] = nil,
    ["HUNTER"] = nil,
    ["ROGUE"] = nil,
}

local BuffDefaults = {
    ["Power Word: Fortitude"]  = { enabled = true,  self = true,  party = true,  travelers = false },
    ["Arcane Intellect"]       = { enabled = true,  self = true,  party = true,  travelers = false },
    ["Frost Armor"]            = { enabled = true,  self = true,  party = false, travelers = false },
    ["Ice Armor"]              = { enabled = false, self = true,  party = false, travelers = false },
    ["Mage Armor"]             = { enabled = false, self = true,  party = false, travelers = false },
    ["Mana Shield"]            = { enabled = false, self = true,  party = false, travelers = false },
    ["Ice Barrier"]            = { enabled = false, self = true,  party = false, travelers = false },
    ["Fire Ward"]              = { enabled = false, self = true,  party = false, travelers = false },
    ["Frost Ward"]             = { enabled = false, self = true,  party = false, travelers = false },
    ["Dampen Magic"]           = { enabled = false, self = false, party = false, travelers = false },
    ["Amplify Magic"]          = { enabled = false, self = false, party = false, travelers = false },
    ["Mark of the Wild"]       = { enabled = true,  self = true,  party = true,  travelers = false },
    ["Thorns"]                 = { enabled = true,  self = true,  party = true,  travelers = false },
    ["Blessing of Might"]      = { enabled = true,  self = true,  party = true,  travelers = false },
    ["Blessing of Wisdom"]     = { enabled = false, self = false, party = false, travelers = false },
    ["Blessing of Kings"]      = { enabled = false, self = false, party = false, travelers = false },
    ["Demon Armor"]            = { enabled = true,  self = true,  party = false, travelers = false },
    ["Unending Breath"]        = { enabled = true,  self = true,  party = true,  travelers = false },
    ["Detect Invisibility"]    = { enabled = false, self = false, party = false, travelers = false },
    ["Lightning Shield"]       = { enabled = true,  self = true,  party = false, travelers = false },
    ["Rockbiter Weapon"]       = { enabled = true,  self = true,  party = false, travelers = false },
    ["Flametongue Weapon"]     = { enabled = false, self = false, party = false, travelers = false },
    ["Water Walking"]          = { enabled = false,  self = false,  party = true,  travelers = false },
}

local BuffMutuallyExclusive = {
    {"Dampen Magic", "Amplify Magic"},
    {"Rockbiter Weapon", "Flametongue Weapon"},
    {"Frost Armor", "Ice Armor", "Mage Armor"},
    {"Fire Ward", "Frost Ward"},
}
addonTable.BuffMutuallyExclusive = BuffMutuallyExclusive

local BuffTargetClasses = {
    ["Power Word: Fortitude"] = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Arcane Intellect"]      = {WARRIOR=false, ROGUE=false, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Mark of the Wild"]      = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Thorns"]                = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Blessing of Might"]     = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=false, WARLOCK=false, PRIEST=false, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Blessing of Wisdom"]    = {WARRIOR=false, ROGUE=false, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Blessing of Kings"]     = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Dampen Magic"]          = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Amplify Magic"]         = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Unending Breath"]       = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Detect Invisibility"]   = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
    ["Water Walking"]         = {WARRIOR=true, ROGUE=true, HUNTER=true, MAGE=true, WARLOCK=true, PRIEST=true, DRUID=true, SHAMAN=true, PALADIN=true},
}
addonTable.BuffTargetClasses = BuffTargetClasses

local BuffIcons = {
    ["Power Word: Fortitude"]  = "Interface\\Icons\\Spell_Holy_WordFortitude",
    ["Arcane Intellect"]       = "Interface\\Icons\\Spell_Holy_MagicalSentry",
    ["Frost Armor"]            = "Interface\\Icons\\Spell_Frost_FrostArmor02",
    ["Ice Armor"]              = "Interface\\Icons\\Spell_Frost_FrostArmor02",
    ["Mage Armor"]             = "Interface\\Icons\\Spell_MageArmor",
    ["Mana Shield"]            = "Interface\\Icons\\Spell_Shadow_DetectLesserInvisibility",
    ["Ice Barrier"]            = "Interface\\Icons\\Spell_Ice_Lament",
    ["Fire Ward"]              = "Interface\\Icons\\Spell_Fire_FireArmor",
    ["Frost Ward"]             = "Interface\\Icons\\Spell_Frost_FrostWard",
    ["Dampen Magic"]           = "Interface\\Icons\\Spell_Nature_AbolishMagic",
    ["Amplify Magic"]          = "Interface\\Icons\\Spell_Holy_FlashHeal",
    ["Mark of the Wild"]       = "Interface\\Icons\\Spell_Nature_Regeneration",
    ["Thorns"]                 = "Interface\\Icons\\Spell_Nature_Thorns",
    ["Blessing of Might"]      = "Interface\\Icons\\Spell_Holy_FistOfJustice",
    ["Blessing of Wisdom"]     = "Interface\\Icons\\Spell_Holy_SealOfWisdom",
    ["Blessing of Kings"]      = "Interface\\Icons\\Spell_Magic_MageArmor",
    ["Demon Armor"]            = "Interface\\Icons\\Spell_Shadow_RagingScream",
    ["Unending Breath"]        = "Interface\\Icons\\Spell_Shadow_DemonBreath",
    ["Detect Invisibility"]    = "Interface\\Icons\\Spell_Shadow_DetectInvisibility",
    ["Lightning Shield"]       = "Interface\\Icons\\Spell_Nature_LightningShield",
    ["Rockbiter Weapon"]       = "Interface\\Icons\\Spell_Nature_RockBiter",
    ["Flametongue Weapon"]     = "Interface\\Icons\\Spell_Fire_FlameTounge",
    ["Water Walking"]          = "Interface\\Icons\\Spell_Frost_WindWalkOn",
}
addonTable.BuffIcons = BuffIcons

local _, playerClass = UnitClass("player")
local potentialBuffs = ClassBuffs[playerClass]

addonTable.MyBuffs = {}
local myBuffs = addonTable.MyBuffs

local IsSelfCastBuff = {
    ["Demon Armor"]        = true,
    ["Lightning Shield"]   = true,
    ["Rockbiter Weapon"]   = true,
    ["Flametongue Weapon"] = true,
    ["Frost Armor"]        = true,
    ["Ice Armor"]          = true,
    ["Mage Armor"]         = true,
    ["Mana Shield"]        = true,
    ["Ice Barrier"]        = true,
    ["Fire Ward"]          = true,
    ["Frost Ward"]         = true,
}
addonTable.IsSelfCastBuff = IsSelfCastBuff

if not potentialBuffs then
    return
end

function QBuff_UpdateKnownBuffs()
    local knownSpells = {}
    local i = 1
    while true do
        local name = nil
        if C_SpellBook and C_SpellBook.GetSpellBookItemName then
            local bank = (Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player) or 0
            name = C_SpellBook.GetSpellBookItemName(i, bank)
        elseif GetSpellBookItemName then
            name = GetSpellBookItemName(i, "spell")
        elseif GetSpellName then
            name = GetSpellName(i, "spell")
        end

        if not name then break end
        knownSpells[name] = true
        i = i + 1
    end

    wipe(addonTable.MyBuffs)
    for _, buff in ipairs(potentialBuffs) do
        if DEBUG_MODE or knownSpells[buff] then
            table.insert(addonTable.MyBuffs, buff)

            if QBuffSettingsPerChar and QBuffSettingsPerChar.buffs then
                if not QBuffSettingsPerChar.buffs[buff] then
                    local def = BuffDefaults[buff] or { enabled = true, self = true, party = true, travelers = false }
                    QBuffSettingsPerChar.buffs[buff] = { enabled = def.enabled, self = def.self, party = def.party, travelers = def.travelers }
                elseif QBuffSettingsPerChar.buffs[buff].enabled == nil then
                    local def = BuffDefaults[buff]
                    QBuffSettingsPerChar.buffs[buff].enabled = def and def.enabled or true
                end

                if not QBuffSettingsPerChar.buffs[buff].classes then
                    QBuffSettingsPerChar.buffs[buff].classes = {}
                    if addonTable.BuffTargetClasses[buff] then
                        for k, v in pairs(addonTable.BuffTargetClasses[buff]) do
                            QBuffSettingsPerChar.buffs[buff].classes[k] = v
                        end
                    end
                end

                if IsSelfCastBuff[buff] then
                    QBuffSettingsPerChar.buffs[buff].party = false
                    QBuffSettingsPerChar.buffs[buff].self = QBuffSettingsPerChar.buffs[buff].enabled
                    QBuffSettingsPerChar.buffs[buff].travelers = false
                end
            end
        end
    end

    for _, group in ipairs(BuffMutuallyExclusive) do
        local selfOwner, partyOwner, travelersOwner = nil, nil, nil
        for _, member in ipairs(group) do
            local cfg = QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[member]
            if cfg and cfg.enabled then
                local isSelfCast = IsSelfCastBuff[member]

                if cfg.self then
                    if not selfOwner then
                        selfOwner = member
                    else
                        cfg.self = false
                    end
                end

                if cfg.party then
                    if not partyOwner then
                        partyOwner = member
                    else
                        cfg.party = false
                    end
                end

                if cfg.travelers then
                    if not travelersOwner then
                        travelersOwner = member
                    else
                        cfg.travelers = false
                    end
                end

                if isSelfCast then
                    if selfOwner ~= member then
                        cfg.enabled = false
                        cfg.self = false
                    end
                else
                    local hasAny = cfg.self or cfg.party or cfg.travelers
                    if not hasAny then
                        cfg.enabled = false
                    end
                end
            end
        end
    end

    if QBuffOptionsFrame and QBuffOptionsFrame.contentFrame then
        QBuffOptionsFrame.contentFrame.initialized = false
        if QBuffOptionsFrame:IsShown() then
            for _, child in ipairs({QBuffOptionsFrame.contentFrame:GetChildren()}) do
                child:Hide()
            end
            QBuffOptionsFrame:GetScript("OnShow")()
        end
    end
end

local frame = CreateFrame("Button", "QBuffFrame", UIParent, "SecureActionButtonTemplate, SecureHandlerStateTemplate" .. (BackdropTemplateMixin and ", BackdropTemplate" or ""))

frame:SetAttribute("_onstate-hastarget", [[
    if self:GetAttribute("type1") == "macro" then
        local name = self:GetAttribute("q_name")
        local buff = self:GetAttribute("q_buff")
        if name and buff then
            if newstate == "true" then
                self:SetAttribute("macrotext1", "/targetexact " .. name .. "\n/cast [@target,exists,help] " .. buff .. "\n/targetlasttarget")
            else
                self:SetAttribute("macrotext1", "/targetexact " .. name .. "\n/cast [@target,exists,help] " .. buff .. "\n/cleartarget")
            end
        end
    end
]])
RegisterStateDriver(frame, "hastarget", "[exists] true; false")

frame:SetSize(Config.Size, Config.Size)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton", "RightButton")
frame:RegisterForClicks("AnyDown")
frame:Hide()
frame:SetScript("OnDragStart", function(self)
    if IsShiftKeyDown() and not InCombatLockdown() then
        self:StartMoving()
    end
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
    QBuffDB = QBuffDB or {}
    QBuffDB.point = point
    QBuffDB.relativePoint = relativePoint
    QBuffDB.x = xOfs
    QBuffDB.y = yOfs
end)

frame:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
frame:SetBackdropBorderColor(1, 0.8, 0.1, 1)

local bg = frame:CreateTexture(nil, "BACKGROUND")
bg:SetColorTexture(0, 0.25, 0.5, 1)
bg:SetPoint("TOPLEFT", 3, -3)
bg:SetPoint("BOTTOMRIGHT", -3, 3)

local icon = frame:CreateTexture(nil, "ARTWORK")
icon:SetPoint("TOPLEFT", 4, -4)
icon:SetPoint("BOTTOMRIGHT", -4, 4)
icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local glowFrame = CreateFrame("Frame", nil, frame)
glowFrame:SetAllPoints(icon)
glowFrame:Hide()

local function CreateEdgeSparkle(startPoint, r, g, b, offset1, offset2, offset3, offset4)
    local spark = glowFrame:CreateTexture(nil, "OVERLAY")
    spark:SetTexture("Interface\\Cooldown\\star4")
    spark:SetBlendMode("ADD")
    spark:SetSize(20, 20)
    spark:SetVertexColor(r, g, b)
    spark:SetPoint("CENTER", glowFrame, startPoint)

    local ag = spark:CreateAnimationGroup()
    local d = 0.8

    local t1 = ag:CreateAnimation("Translation")
    t1:SetOffset(offset1.x, offset1.y)
    t1:SetDuration(d)
    t1:SetOrder(1)
    local t2 = ag:CreateAnimation("Translation")
    t2:SetOffset(offset2.x, offset2.y)
    t2:SetDuration(d)
    t2:SetOrder(2)
    local t3 = ag:CreateAnimation("Translation")
    t3:SetOffset(offset3.x, offset3.y)
    t3:SetDuration(d)
    t3:SetOrder(3)
    local t4 = ag:CreateAnimation("Translation")
    t4:SetOffset(offset4.x, offset4.y)
    t4:SetDuration(d)
    t4:SetOrder(4)

    ag:SetLooping("REPEAT")
    return ag
end

local s = Config.Size - 8
local ag1 = CreateEdgeSparkle("TOPLEFT", 1, 0.8, 0.1, {x=s,y=0}, {x=0,y=-s}, {x=-s,y=0}, {x=0,y=s})
local ag2 = CreateEdgeSparkle("TOPRIGHT", 0.1, 0.7, 1.0, {x=0,y=-s}, {x=-s,y=0}, {x=0,y=s}, {x=s,y=0})
local ag3 = CreateEdgeSparkle("BOTTOMRIGHT", 1, 0.8, 0.1, {x=-s,y=0}, {x=0,y=s}, {x=s,y=0}, {x=0,y=-s})
local ag4 = CreateEdgeSparkle("BOTTOMLEFT", 0.1, 0.7, 1.0, {x=0,y=s}, {x=s,y=0}, {x=0,y=-s}, {x=-s,y=0})

local hasShinedThisSession = false
frame:SetScript("OnEnter", function(self)
    if not hasShinedThisSession then
        hasShinedThisSession = true
        glowFrame:Hide()
        ag1:Stop() ag2:Stop() ag3:Stop() ag4:Stop()
    end
end)

local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
highlight:SetBlendMode("ADD")
highlight:SetPoint("TOPLEFT", 4, -4)
highlight:SetPoint("BOTTOMRIGHT", -4, 4)
highlight:SetVertexColor(0.1, 0.7, 1.0, 0.3)

local currentTargetName = nil
local currentSpell = nil
local inCombat = InCombatLockdown() or false
local buffQueue = {}
local queuedNames = {}
local pendingCastTarget = nil
local pendingCastSpell = nil

local ProcessQueue

function addonTable.ClearQueue()
    buffQueue = {}
    queuedNames = {}
    if not InCombatLockdown() then
        if ProcessQueue then ProcessQueue() end
    end
end

local function PopPendingTarget(targetName, entirely, penaltyTime)
    for i, current in ipairs(buffQueue) do
        if current.name == targetName then
            local isSelf = (current.name == UnitName("player"))
            if entirely then
                table.remove(buffQueue, i)
                if isSelf or current.isParty then
                    queuedNames[targetName] = nil
                else
                    if penaltyTime then
                        queuedNames[targetName] = GetTime() - 300 + penaltyTime
                    else
                        queuedNames[targetName] = GetTime()
                    end
                end
            else
                table.remove(current.spells, 1)
                if #current.spells == 0 then
                    table.remove(buffQueue, i)
                    if isSelf or current.isParty then
                        queuedNames[targetName] = nil
                    else
                        if penaltyTime then
                            queuedNames[targetName] = GetTime() - 300 + penaltyTime
                        else
                            queuedNames[targetName] = GetTime()
                        end
                    end
                else
                    current.spell = current.spells[1]
                end
            end
            if not InCombatLockdown() then
                ProcessQueue()
            end
            break
        end
    end
end

local WeaponImbueBuffs = {
    ["Rockbiter Weapon"]   = true,
    ["Flametongue Weapon"] = true,
}

local imbueCache = nil
local imbueCacheTime = 0

function QBuff_InvalidateImbueCache()
    imbueCache = nil
    imbueCacheTime = 0
end

local function HasWeaponImbue(buffName)
    if imbueCache and (GetTime() - imbueCacheTime < 5.0) then
        if imbueCache[buffName] ~= nil then
            return unpack(imbueCache[buffName])
        end
    end

    local v1, v2, v3, v4, v5, v6, v7, v8 = GetWeaponEnchantInfo()
    local hasMH = (v1 == 1 or v1 == true)
    local hasOH = (v4 == 1 or v4 == true) or (v5 == 1 or v5 == true)

    local kw = (buffName == "Flametongue Weapon") and "flametongue" or "rockbiter"
    local otherKw = (buffName == "Flametongue Weapon") and "rockbiter" or "flametongue"

    local foundMatch = false
    local foundOther = false

    local function CheckText(txt)
        if not txt then return end
        local lower = string.lower(txt)
        if string.find(lower, kw, 1, true) then foundMatch = true end
        if string.find(lower, otherKw, 1, true) then foundOther = true end
    end

    if C_TooltipInfo and C_TooltipInfo.GetInventoryItem then
        pcall(function()
            local data = C_TooltipInfo.GetInventoryItem("player", 16)
            if data and data.lines then
                for _, line in ipairs(data.lines) do
                    CheckText(line.leftText)
                    if line.args then
                        for _, arg in ipairs(line.args) do
                            CheckText(arg.stringVal)
                        end
                    end
                end
            end
            local dataOH = C_TooltipInfo.GetInventoryItem("player", 17)
            if dataOH and dataOH.lines then
                for _, line in ipairs(dataOH.lines) do
                    CheckText(line.leftText)
                    if line.args then
                        for _, arg in ipairs(line.args) do
                            CheckText(arg.stringVal)
                        end
                    end
                end
            end
        end)
    end

    if not foundMatch and not foundOther then
        pcall(function()
            if not QBuffScanTooltip then
                QBuffScanTooltip = CreateFrame("GameTooltip", "QBuffScanTooltip", UIParent, "GameTooltipTemplate")
            end
            QBuffScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
            local function ScanSlot(slot)
                QBuffScanTooltip:ClearLines()
                QBuffScanTooltip:SetInventoryItem("player", slot)
                for i = 1, 30 do
                    local line = _G["QBuffScanTooltipTextLeft" .. i]
                    if line then
                        CheckText(line:GetText())
                    end
                end
            end
            ScanSlot(16)
            ScanSlot(17)
        end)
    end

    local result = false
    local rem = 9999
    if foundMatch then result = true
    elseif foundOther then result = false
    else result = (hasMH or hasOH) and true or false end

    if result then
        local foundKw = false
        if hasMH then
            if foundMatch and string.find(string.lower((v4 == 1 and "kw" or "kw")), "x") then end
            rem = v2 and (v2 / 1000) or 9999
        elseif hasOH then
            rem = v6 and (v6 / 1000) or 9999
        end
    end

    if not imbueCache then imbueCache = {} end
    imbueCache[buffName] = {result, rem}
    imbueCacheTime = GetTime()

    return result, rem
end

local function MatchAura(auraName, auraIcon, auraSpellId, buffName)
    if not buffName then return false end

    local shortName = string.gsub(buffName, "%s+Weapon$", "")
    local lowerBuff = string.lower(buffName)
    local lowerShort = string.lower(shortName)

    if auraName then
        local lowerAura = string.lower(auraName)
        if lowerAura == lowerBuff or lowerAura == lowerShort then
            return true
        end
        if string.find(lowerAura, lowerShort, 1, true) or string.find(lowerAura, lowerBuff, 1, true) then
            return true
        end
    end

    if auraIcon then
        local iconStr = string.lower(tostring(auraIcon))
        if buffName == "Rockbiter Weapon" then
            if string.find(iconStr, "rockbiter") or auraIcon == 136050 then
                return true
            end
        elseif buffName == "Flametongue Weapon" then
            if string.find(iconStr, "flametongue") or string.find(iconStr, "flametounge") or auraIcon == 135814 then
                return true
            end
        end
    end

    return false
end

local function HasBuff(unit, buffName)
    local isPlayer = UnitIsUnit("player", unit)

    if isPlayer and WeaponImbueBuffs[buffName] then
        local has, rem = HasWeaponImbue(buffName)
        if has then
            return true, rem
        end
    end

    local function GetRem(expirationTime)
        if not expirationTime or expirationTime == 0 then return 9999 end
        return math.max(0, expirationTime - GetTime())
    end

    if C_UnitAuras then
        if C_UnitAuras.GetBuffDataByIndex then
            for i = 1, 40 do
                local success, aura = pcall(C_UnitAuras.GetBuffDataByIndex, unit, i)
                if success and aura and MatchAura(aura.name, aura.icon, aura.spellId, buffName) then
                    return true, GetRem(aura.expirationTime)
                end
            end
        end
        if C_UnitAuras.GetAuraDataByIndex then
            for i = 1, 40 do
                local success, aura = pcall(C_UnitAuras.GetAuraDataByIndex, unit, i, "HELPFUL")
                if success and aura and MatchAura(aura.name, aura.icon, aura.spellId, buffName) then
                    return true, GetRem(aura.expirationTime)
                end
            end
        end
    end

    if UnitAura then
        for i = 1, 40 do
            local success, name, icon, _, _, duration, expirationTime, _, _, _, spellId = pcall(UnitAura, unit, i, "HELPFUL")
            if success and name and MatchAura(name, icon, spellId, buffName) then
                return true, GetRem(expirationTime)
            end
        end
    end

    if UnitBuff then
        for i = 1, 40 do
            local success, name, _, icon, _, duration, expirationTime = pcall(UnitBuff, unit, i)
            if success and name and MatchAura(name, icon, nil, buffName) then
                return true, GetRem(expirationTime)
            end
        end
    end

    return false, 0
end

local function GetMissingBuffs(unit, name)
    local missing = {}
    local isSelf = UnitIsUnit("player", unit)
    local isParty = string.match(unit, "^party") or string.match(unit, "^raid")

    local skipBuff = {}
    for _, group in ipairs(BuffMutuallyExclusive) do
        for _, member in ipairs(group) do
            local hasIt = HasBuff(unit, member)
            if hasIt then
                for _, other in ipairs(group) do
                    if other ~= member then skipBuff[other] = true end
                end
                break
            end
        end
    end

    for _, buff in ipairs(myBuffs) do
        if not skipBuff[buff] then
            local allowed = false
            local threshold = 0
            local conf = QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buff]
            if conf then
                if conf.enabled == false then
                    allowed = false
                elseif IsSelfCastBuff[buff] then
                    allowed = isSelf and (conf.enabled ~= false)
                elseif isSelf then allowed = conf.self
                elseif isParty then allowed = conf.party
                else allowed = conf.travelers end

                if allowed and not isSelf and conf.classes then
                    local _, unitClass = UnitClass(unit)
                    if unitClass and conf.classes[unitClass] == false then
                        allowed = false
                    end
                end

                if allowed and not isSelf and not isParty then
                    local allowPvP = QBuffSettingsPerChar.buffPvP == true
                    if UnitIsPVP(unit) and not UnitIsPVP("player") and not allowPvP then
                        allowed = false
                    end
                end

                if (isSelf or isParty) and conf.rebuffThreshold then
                    threshold = conf.rebuffThreshold
                end
            else
                allowed = true
            end

            if allowed and WeaponImbueBuffs[buff] then
                local hasWeapon = GetInventoryItemLink("player", 16) or GetInventoryItemLink("player", 17)
                if not hasWeapon then
                    allowed = false
                end
            end

            if allowed then
                local has, rem = HasBuff(unit, buff)
                if not has or rem <= threshold then
                    table.insert(missing, buff)
                end
            end
        end
    end
    if #missing > 0 then return missing end
    return nil
end

local function IsSpellInRangeCompat(spellName, unit)
    if C_Spell and C_Spell.IsSpellInRange then
        local res = C_Spell.IsSpellInRange(spellName, unit)
        if res == true then return 1
        elseif res == false then return 0
        end
        return nil
    elseif IsSpellInRange then
        return IsSpellInRange(spellName, unit)
    end
    return nil
end

local function IsUsableSpellCompat(spellName)
    if C_Spell and C_Spell.IsSpellUsable then
        local isUsable, noMana = C_Spell.IsSpellUsable(spellName)
        return isUsable, noMana
    elseif IsUsableSpell then
        return IsUsableSpell(spellName)
    end
    return true, false
end

local function GetSpellCooldownCompat(spellName)
    if C_Spell and C_Spell.GetSpellCooldown then
        local cd = C_Spell.GetSpellCooldown(spellName)
        if cd then
            return cd.startTime, cd.duration
        end
        return 0, 0
    elseif GetSpellCooldown then
        local start, duration = GetSpellCooldown(spellName)
        return start, duration
    end
    return 0, 0
end

local function UpdateButton(unit, name, missingBuff)
    currentTargetName = name
    currentSpell = missingBuff

    local spellIcon = BuffIcons[missingBuff] or (C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(missingBuff)) or (GetSpellTexture and GetSpellTexture(missingBuff))
    if spellIcon then
        icon:SetTexture(spellIcon)
    else
        icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    end

    frame:SetAttribute("type1", nil)
    frame:SetAttribute("macrotext1", nil)
    frame:SetAttribute("spell1", nil)
    frame:SetAttribute("unit1", nil)

    if IsSelfCastBuff[missingBuff] then
        frame:SetAttribute("type1", "macro")
        frame:SetAttribute("macrotext1", "/cast " .. missingBuff)
    elseif unit and (string.match(unit, "^party") or string.match(unit, "^raid") or unit == "target" or unit == "player") then
        frame:SetAttribute("type1", "spell")
        frame:SetAttribute("spell1", missingBuff)
        frame:SetAttribute("unit1", unit)
    else
        frame:SetAttribute("type1", "macro")
        frame:SetAttribute("q_name", name)
        frame:SetAttribute("q_buff", missingBuff)

        if UnitExists("target") then
            local macro = string.format("/targetexact %s\n/cast [@target,exists,help] %s\n/targetlasttarget", name, missingBuff)
            frame:SetAttribute("macrotext1", macro)
        else
            local macro = string.format("/targetexact %s\n/cast [@target,exists,help] %s\n/cleartarget", name, missingBuff)
            frame:SetAttribute("macrotext1", macro)
        end
    end

    if not frame:IsShown() then
        hasShinedThisSession = false
        if not QBuffSettingsPerChar or QBuffSettingsPerChar.showGlow ~= false then
            glowFrame:Show()
            ag1:Play() ag2:Play() ag3:Play() ag4:Play()
        end
        frame:Show()
    end
end

local priorityUnitsToScan = {"player"}
for i = 1, 4 do table.insert(priorityUnitsToScan, "party"..i) end
for i = 1, 40 do table.insert(priorityUnitsToScan, "raid"..i) end

local lowPriorityUnitsToScan = {"target", "mouseover"}
for i = 1, 40 do table.insert(lowPriorityUnitsToScan, "nameplate"..i) end

ProcessQueue = function()
    local foundAnyone = false
    local i = 1

    while i <= #buffQueue do
        local current = buffQueue[i]

        local currentUnitToken = nil
        for _, u in ipairs(priorityUnitsToScan) do
            if UnitExists(u) and GetUnitName(u, false) == current.name then
                currentUnitToken = u
                break
            end
        end
        if not currentUnitToken then
            for _, u in ipairs(lowPriorityUnitsToScan) do
                if UnitExists(u) and GetUnitName(u, false) == current.name then
                    currentUnitToken = u
                    break
                end
            end
        end

        if currentUnitToken then
            current.lastSeen = GetTime()
            current.isGhost = false
            current.isParty = (string.match(currentUnitToken, "^party") or string.match(currentUnitToken, "^raid") or currentUnitToken == "player")

            if current.isParty then
                local missingBuffs = GetMissingBuffs(currentUnitToken, current.name)
                if missingBuffs then
                    current.spells = missingBuffs
                    current.spell = missingBuffs[1]
                else
                    DebugPrint("Auto-removed (buff no longer needed): %s", current.coloredName or current.name)
                    table.remove(buffQueue, i)
                    queuedNames[current.name] = nil
                    current.spells = {}
                end
            end

            if current.spells and #current.spells > 0 and string.match(currentUnitToken, "^nameplate") then
                if not IsSelfCastBuff[current.spell] then
                    local res = IsSpellInRangeCompat(current.spell, currentUnitToken)
                    local inRange = true
                    if res == 0 then
                        inRange = false
                    elseif res == nil then
                        inRange = CheckInteractDistance(currentUnitToken, 1) and true or false
                    end

                    if not inRange then
                        DebugPrint("Auto-removed (out of range/LOS): %s", current.coloredName or current.name)
                        table.remove(buffQueue, i)
                        queuedNames[current.name] = nil
                        current.spells = {}
                    end
                end
            end

            if current.spells and #current.spells > 0 then
                local _, noMana = IsUsableSpellCompat(current.spell)
                if noMana then
                    icon:SetVertexColor(0.5, 0.5, 1, 1)
                else
                    icon:SetVertexColor(1, 1, 1, 1)
                end

                if not frame:IsShown() or currentTargetName ~= current.name or currentSpell ~= current.spell then
                    UpdateButton(currentUnitToken, current.name, current.spell)
                end
                foundAnyone = true

                if i > 1 then
                    table.insert(buffQueue, 1, table.remove(buffQueue, i))
                end
                break
            end
        else
            current.isGhost = true
            if not current.isParty then
                DebugPrint("Auto-removed (traveler out of sight): %s", current.coloredName or current.name)
                table.remove(buffQueue, i)
                queuedNames[current.name] = nil
                current.spells = {}
            else
            local _, noMana = IsUsableSpellCompat(current.spell)
            if noMana then
                icon:SetVertexColor(0.5, 0.5, 1, 1)
            else
                icon:SetVertexColor(1, 1, 1, 1)
            end
            if not frame:IsShown() or currentTargetName ~= current.name or currentSpell ~= current.spell then
                UpdateButton(nil, current.name, current.spell)
            end
            foundAnyone = true

            if i > 1 then
                table.insert(buffQueue, 1, table.remove(buffQueue, i))
            end
            break
            end
        end

        if current.spells and #current.spells > 0 then
            i = i + 1
        end
    end

    if not foundAnyone then
        if frame:IsShown() or frame:GetAttribute("type1") ~= nil then
            if not InCombatLockdown() then
                frame:SetAttribute("type1", nil)
                frame:SetAttribute("macrotext1", nil)
                frame:SetAttribute("spell1", nil)
                frame:SetAttribute("unit1", nil)
            end
            frame:Hide()
            if glowFrame then glowFrame:Hide() end
            if ag1 then ag1:Stop() ag2:Stop() ag3:Stop() ag4:Stop() end
            currentTargetName = nil
            currentSpell = nil
        end
    end
end

local function CheckUnit(unit)
    if UnitIsDeadOrGhost("player") then return end
    if IsMounted() or UnitOnTaxi("player") then return end

    if unit == "mouseover" and GetCVar("nameplateShowFriends") == "1" then
        return
    end

    if (unit == "mouseover" or unit == "target") and (UnitInParty(unit) or UnitInRaid(unit) or UnitIsUnit("player", unit)) then
        return
    end

    if UnitExists(unit) and UnitIsPlayer(unit) and (UnitIsUnit("player", unit) or UnitIsFriend("player", unit)) then
        if UnitOnTaxi(unit) then return end

        local name = GetUnitName(unit, false)
        if not name then return end

        if UnitIsDeadOrGhost(unit) or UnitIsDead(unit) then
            if queuedNames[name] then
                queuedNames[name] = nil
                for i = #buffQueue, 1, -1 do
                    if buffQueue[i].name == name then
                        table.remove(buffQueue, i)
                    end
                end
            end
            return
        end

        local qVal = queuedNames[name]
        local recentlyProcessed = false
        if qVal == true then
            recentlyProcessed = true
            elseif type(qVal) == "number" then
                if GetTime() - qVal < 300 then
                    recentlyProcessed = true
                else
                    queuedNames[name] = nil
                end
            end

            if not recentlyProcessed then
                local missingBuffs = GetMissingBuffs(unit, name)
                if missingBuffs then
                    local firstBuff = missingBuffs[1]
                    if not IsSelfCastBuff[firstBuff] and not UnitIsUnit("player", unit) then
                        local res = IsSpellInRangeCompat(firstBuff, unit)
                        local inRange = true
                        if res == 0 then
                            inRange = false
                        elseif res == nil then
                            inRange = CheckInteractDistance(unit, 1) and true or false
                        end

                        if not inRange then
                            return
                        end
                    end

                local priority = 3
                if UnitIsUnit("player", unit) or UnitInParty(unit) or UnitInRaid(unit) then
                    priority = 1
                elseif unit == "target" then
                    priority = 2
                end

                local _, class = UnitClass(unit)
                local coloredName = GetClassColoredName(name, class)
                table.insert(buffQueue, {
                    name = name,
                    coloredName = coloredName,
                    spells = missingBuffs,
                    spell = missingBuffs[1],
                    priority = priority,
                    isParty = UnitInParty(unit) or UnitInRaid(unit),
                    addedAt = GetTime()
                })
                queuedNames[name] = true
                DebugPrint("Added to queue (#%d): %s (%s)", #buffQueue, coloredName, missingBuffs[1])
            end
        end
    end
end

local lastNameplateState = nil

local function ScanUnits()
    if UnitIsDeadOrGhost("player") then return end
    if IsMounted() or UnitOnTaxi("player") then return end
    if not addonTable.MyBuffs or #addonTable.MyBuffs == 0 then return end
    if inCombat or InCombatLockdown() then return end

    local currentNameplateState = GetCVar("nameplateShowFriends")
    if lastNameplateState ~= nil and currentNameplateState ~= lastNameplateState then
        DebugPrint("Nameplates toggled! Clearing traveler queue.")
        local i = 1
        while i <= #buffQueue do
            if not buffQueue[i].isParty then
                queuedNames[buffQueue[i].name] = nil
                table.remove(buffQueue, i)
            else
                i = i + 1
            end
        end
    end
    lastNameplateState = currentNameplateState

    for _, unit in ipairs(priorityUnitsToScan) do
        CheckUnit(unit)
    end

    local inInstance, _ = IsInInstance()
    if not inInstance and #buffQueue < 5 then
        for _, unit in ipairs(lowPriorityUnitsToScan) do
            CheckUnit(unit)
            if #buffQueue >= 5 then break end
        end
    end

    if #buffQueue > 1 then
        table.sort(buffQueue, function(a, b)
            if a.priority ~= b.priority then
                return a.priority < b.priority
            end
            return a.addedAt < b.addedAt
        end)
    end

    ProcessQueue()
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("SPELLS_CHANGED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            QBuffDB = QBuffDB or {}
            if QBuffDB.point then
                frame:SetPoint(QBuffDB.point, UIParent, QBuffDB.relativePoint, QBuffDB.x, QBuffDB.y)
            else
                frame:SetPoint(Config.Point, Config.X, Config.Y)
            end

            frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
            frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
            frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
            frame:RegisterEvent("UNIT_AURA")
            frame:RegisterEvent("PLAYER_LOGIN")

            frame:SetScript("PreClick", function(self, button)
                if button == "RightButton" and IsShiftKeyDown() then
                    if QBuffOptionsFrame then
                        QBuffOptionsFrame:SetShown(not QBuffOptionsFrame:IsShown())
                    end
                    return
                end

                if currentTargetName then
                    pendingCastTarget = currentTargetName
                    pendingCastSpell = currentSpell
                    hadTarget = UnitExists("target")
                end
            end)

            frame:SetScript("PostClick", function(self, button)
                if button == "RightButton" and IsShiftKeyDown() then return end

                if not InCombatLockdown() then
                    ProcessQueue()
                end

                local capturedTarget = pendingCastTarget
                local capturedSpell = pendingCastSpell
                if capturedTarget then
                    C_Timer.After(1.5, function()
                        if pendingCastTarget == capturedTarget and pendingCastSpell == capturedSpell then
                            PopPendingTarget(capturedTarget, true, 10)
                            pendingCastTarget = nil
                            pendingCastSpell = nil
                        end
                    end)
                end
            end)

            frame:UnregisterEvent("ADDON_LOADED")
        end
    elseif event == "PLAYER_LOGIN" then
        if not QBuffDB then QBuffDB = {} end
        if not QBuffDB.chars then QBuffDB.chars = {} end

        local realm = GetRealmName() or ""
        local playerKey = UnitName("player") .. " - " .. realm
        if not QBuffDB.chars[playerKey] then
            QBuffDB.chars[playerKey] = {}
        end

        if type(_G["QBuffSettingsPerChar"]) == "table" and not QBuffDB.chars[playerKey].migrated then
            for k, v in pairs(_G["QBuffSettingsPerChar"]) do
                QBuffDB.chars[playerKey][k] = v
            end
            QBuffDB.chars[playerKey].migrated = true
        end

        QBuffSettingsPerChar = QBuffDB.chars[playerKey]
        QBuffSettingsPerChar.buffs = QBuffSettingsPerChar.buffs or {}

        QBuff_UpdateKnownBuffs()

        if QBuffSettingsPerChar.hotkey then
            SetBindingClick(QBuffSettingsPerChar.hotkey, "QBuffFrame")
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        inCombat = true
        if not InCombatLockdown() then
            frame:Hide()
            currentTargetName = nil
            currentSpell = nil
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        inCombat = false
    elseif event == "SPELLS_CHANGED" then
        QBuff_UpdateKnownBuffs()
    elseif event == "PLAYER_LOGIN" then
        QBuff_UpdateKnownBuffs()
    elseif event == "UNIT_INVENTORY_CHANGED" or event == "UNIT_AURA" then
        local unit = ...
        if unit == "player" then
            QBuff_InvalidateImbueCache()
            if not InCombatLockdown() then
                ProcessQueue()
            end
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
        local unit = ...
        if unit ~= "player" then return end
        QBuff_InvalidateImbueCache()

        if pendingCastSpell and pendingCastTarget then
            if event == "UNIT_SPELLCAST_SUCCEEDED" then
                if currentTargetName == pendingCastTarget and currentSpell == pendingCastSpell then
                    local printName = pendingCastTarget
                    for _, v in ipairs(buffQueue) do if v.name == pendingCastTarget then printName = v.coloredName or v.name; break end end
                    DebugPrint("SUCCESS: %s on %s at %s", pendingCastSpell, tostring(printName), date("%H:%M:%S"))
                    PopPendingTarget(pendingCastTarget, false)
                    if not InCombatLockdown() then
                        ProcessQueue()
                    end
                end

                pendingCastSpell = nil
                pendingCastTarget = nil

            else
                local printName = pendingCastTarget
                for _, v in ipairs(buffQueue) do if v.name == pendingCastTarget then printName = v.coloredName or v.name; break end end
                DebugPrint("|cffff0000FAILED:|r %s on %s at %s", pendingCastSpell, tostring(printName), date("%H:%M:%S"))

                local start, duration = GetSpellCooldownCompat(pendingCastSpell)
                local _, noMana = IsUsableSpellCompat(pendingCastSpell)

                local isOnGCD = (start and start > 0 and duration and duration > 0)

                if not isOnGCD and not noMana then
                    if currentTargetName == pendingCastTarget and currentSpell == pendingCastSpell then
                        PopPendingTarget(pendingCastTarget, true, 10)
                    end
                    pendingCastSpell = nil
                    pendingCastTarget = nil
                end
            end
        end
    end
end)

C_Timer.NewTicker(1.0, ScanUnits)

SLASH_QBUFF1 = "/qbuff"
SlashCmdList["QBUFF"] = function(msg)
    if msg and string.lower(string.trim(msg)) == "debug" then
        print("|cff00ccff[QBuff Debug]|r --- WEAPON ENCHANTS ---")
        local v1, v2, v3, v4, v5, v6, v7, v8 = GetWeaponEnchantInfo()
        print(string.format("v1:%s v2:%s v3:%s v4:%s v5:%s", tostring(v1), tostring(v2), tostring(v3), tostring(v4), tostring(v5)))

        print("|cff00ccff[QBuff Debug]|r --- ALL AURAS (AuraUtil) ---")
        local count = 0
        if AuraUtil and AuraUtil.ForEachAura then
            local function PrintAura(aura)
                count = count + 1
                print(string.format("[%d] %s (id:%s, icon:%s) %s", count, tostring(aura.name), tostring(aura.spellId), tostring(aura.icon), aura.isWeaponEnchant and "WEP" or ""))
            end
            print("Filter: HELPFUL")
            AuraUtil.ForEachAura("player", "HELPFUL", nil, PrintAura)
            print("Filter: PASSIVE")
            AuraUtil.ForEachAura("player", "PASSIVE", nil, PrintAura)
            print("Filter: <empty>")
            AuraUtil.ForEachAura("player", "", nil, PrintAura)
        end
        if count == 0 then print("No AuraUtil auras.") end

        print("|cff00ccff[QBuff Debug]|r --- VISIBLE BUFF FRAMES ---")
        if BuffFrame and BuffFrame.auraFrames then
            for i, f in pairs(BuffFrame.auraFrames) do
                if f:IsShown() and f.auraData then
                    print(string.format("BuffFrame[%s]: %s (icon: %s)", tostring(i), tostring(f.auraData.name), tostring(f.auraData.icon)))
                end
            end
        end
        for i=1, 3 do
            local f = _G["TempEnchant"..i]
            if f and f:IsShown() then
                print(string.format("TempEnchant%d IS SHOWN", i))
            end
        end

        print("|cff00ccff[QBuff Debug]|r --- C_UnitAuras Slots ---")
        if C_UnitAuras and C_UnitAuras.GetAuraSlots then
            local slots = { C_UnitAuras.GetAuraSlots("player", "") }
            print("EMPTY Slots: " .. #slots)
            for _, slot in ipairs(slots) do
                if type(slot) == "number" then
                    local aura = C_UnitAuras.GetAuraDataBySlot("player", slot)
                    if aura then
                        print(string.format("Slot %d: %s", slot, tostring(aura.name)))
                    end
                end
            end
        end
        return
    end

    if not addonTable.MyBuffs or #addonTable.MyBuffs == 0 then
        print("|cff00ccff[QBuff]|r You don't have any buffs!")
        return
    end
    if QBuffOptionsFrame then
        QBuffOptionsFrame:SetShown(not QBuffOptionsFrame:IsShown())
    end
end
