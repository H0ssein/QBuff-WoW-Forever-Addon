local addonName, addonTable = ...

local f = CreateFrame("Frame", "QBuffOptionsFrame", UIParent, "BackdropTemplate")
f:SetSize(260, 200)
f:SetPoint("CENTER")
f:SetFrameStrata("HIGH")
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving)
f:SetScript("OnDragStop", f.StopMovingOrSizing)
f:Hide()
table.insert(UISpecialFrames, "QBuffOptionsFrame")

f:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    tile = false,
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
f:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
f:SetBackdropBorderColor(0.1, 0.7, 1.0, 0.8)

local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
title:SetPoint("TOPLEFT", 20, -15)
title:SetText("QBuff Settings")
title:SetTextColor(0.1, 0.7, 1.0)

local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
closeBtn:SetPoint("CENTER", f, "TOPRIGHT", 0, 0)
closeBtn:SetScript("OnClick", function()
    f:Hide()
end)

if f.SetPropagateKeyboardInput then
    f:SetPropagateKeyboardInput(true)
end

local function FormatKeybindName(key)
    if not key or key == "Not Bound" or key == "Press a Key..." then return key end
    local text = key
    text = string.gsub(text, "SHIFT%-", "S%-")
    text = string.gsub(text, "CTRL%-", "C%-")
    text = string.gsub(text, "ALT%-", "A%-")
    text = string.gsub(text, "BUTTON", "MB")
    text = string.gsub(text, "NUMPAD", "N")
    text = string.gsub(text, "MOUSEWHEELUP", "MWUp")
    text = string.gsub(text, "MOUSEWHEELDOWN", "MWDn")
    text = string.gsub(text, "CAPSLOCK", "Caps")
    text = string.gsub(text, "SPACE", "Spc")
    return text
end

local genSettingsBtn = CreateFrame("Button", nil, f)
genSettingsBtn:SetSize(20, 20)
genSettingsBtn:SetPoint("TOPRIGHT", -15, -15)
genSettingsBtn:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
genSettingsBtn:SetHighlightTexture("Interface\\Buttons\\UI-OptionsButton")

genSettingsBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Other Settings", 1, 0.8, 0.1)
    GameTooltip:Show()
end)
genSettingsBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local genFrame = CreateFrame("Frame", "QBuffGeneralSettings", f, "BackdropTemplate")
genFrame:SetSize(220, 150)
genFrame:SetPoint("TOPLEFT", f, "TOPRIGHT", 15, 0)
genFrame:SetFrameStrata("HIGH")
genFrame:Hide()
genFrame:SetBackdrop(f:GetBackdrop())
genFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
genFrame:SetBackdropBorderColor(0.1, 0.7, 1.0, 0.8)
table.insert(UISpecialFrames, "QBuffGeneralSettings")

local genCloseBtn = CreateFrame("Button", nil, genFrame, "UIPanelCloseButton")
genCloseBtn:SetPoint("CENTER", genFrame, "TOPRIGHT", 0, 0)
genCloseBtn:SetScript("OnClick", function() genFrame:Hide() end)

local genTitle = genFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
genTitle:SetPoint("TOPLEFT", 15, -15)
genTitle:SetText("General Settings")
genTitle:SetTextColor(0.1, 0.7, 1.0)

genSettingsBtn:SetScript("OnClick", function()
    if genFrame:IsShown() then genFrame:Hide() else genFrame:Show() end
end)

local hotkeyBtn = CreateFrame("Button", nil, genFrame, "BackdropTemplate")
hotkeyBtn:SetSize(115, 24)
hotkeyBtn:SetPoint("TOPRIGHT", -15, -43)
hotkeyBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
hotkeyBtn:EnableKeyboard(false)
if hotkeyBtn.SetPropagateKeyboardInput then
    hotkeyBtn:SetPropagateKeyboardInput(true)
end

local hotkeyLabel = genFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
hotkeyLabel:SetPoint("LEFT", genFrame, "TOPLEFT", 15, -55)
hotkeyLabel:SetText("Buff Hotkey:")

hotkeyBtn:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
hotkeyBtn:SetBackdropColor(0, 0, 0, 0.8)
hotkeyBtn:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

local pvpCb = CreateFrame("CheckButton", nil, genFrame, "UICheckButtonTemplate")
pvpCb:SetPoint("TOPLEFT", 15, -80)
pvpCb:SetSize(24, 24)

local pvpLabel = genFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
pvpLabel:SetPoint("LEFT", pvpCb, "RIGHT", 5, 0)
pvpLabel:SetText("Buff PvP Flagged Players")

pvpCb:SetScript("OnClick", function(self)
    if not QBuffSettingsPerChar then QBuffSettingsPerChar = {} end
    QBuffSettingsPerChar.buffPvP = self:GetChecked()
end)

pvpCb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Buff PvP Flagged Travelers", 1, 0.8, 0.1)
    GameTooltip:AddLine("When unchecked, prevents you from accidentally\ngetting PvP flagged by ignoring out-of-party\nplayers who are flagged (unless you\nare already flagged).", 1, 1, 1)
    GameTooltip:Show()
end)
pvpCb:SetScript("OnLeave", function() GameTooltip:Hide() end)

local glowCb = CreateFrame("CheckButton", nil, genFrame, "UICheckButtonTemplate")
glowCb:SetPoint("TOPLEFT", 15, -105)
glowCb:SetSize(24, 24)

local glowLabel = genFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
glowLabel:SetPoint("LEFT", glowCb, "RIGHT", 5, 0)
glowLabel:SetText("Show Icon Glow")

glowCb:SetScript("OnClick", function(self)
    if not QBuffSettingsPerChar then QBuffSettingsPerChar = {} end
    QBuffSettingsPerChar.showGlow = self:GetChecked()
end)

glowCb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Icon Glow Effect", 1, 0.8, 0.1)
    GameTooltip:AddLine("Shows a shiny effect around the buff icon\nwhen a new buff target is found.", 1, 1, 1)
    GameTooltip:Show()
end)
glowCb:SetScript("OnLeave", function() GameTooltip:Hide() end)

local btnText = hotkeyBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
btnText:SetPoint("LEFT", 5, 0)
btnText:SetPoint("RIGHT", -5, 0)
btnText:SetJustifyH("CENTER")
btnText:SetWordWrap(false)
btnText:SetTextColor(0.1, 0.9, 1.0)
hotkeyBtn.SetText = function(self, text)
    btnText:SetText(FormatKeybindName(text))
end

local isBinding = false

StaticPopupDialogs["QBUFF_BIND_CONFLICT"] = {
    text = "The key '%s' is already bound to '%s'. Do you want to unbind it and assign it to QBuff?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function(self, data)
        local bindString = data.bindString
        local oldBind = GetBindingKey("CLICK QBuffFrame:LeftButton")
        if oldBind then SetBinding(oldBind) end

        SetBindingClick(bindString, "QBuffFrame", "LeftButton")
        SaveBindings(2)

        QBuffSettingsPerChar.hotkey = bindString
        hotkeyBtn:SetText(bindString)
    end,
    OnCancel = function(self)
        hotkeyBtn:SetText(QBuffSettingsPerChar.hotkey or "Not Bound")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

local function StopBinding()
    isBinding = false
    hotkeyBtn:EnableKeyboard(false)
    hotkeyBtn:SetScript("OnKeyUp", nil)
    if hotkeyBtn.SetPropagateKeyboardInput then
        hotkeyBtn:SetPropagateKeyboardInput(true)
    end
    hotkeyBtn:SetBackdropBorderColor(0.1, 0.7, 1.0, 0.5)
    hotkeyBtn:SetBackdropColor(0, 0, 0, 0.5)
    hotkeyBtn:SetText(QBuffSettingsPerChar and QBuffSettingsPerChar.hotkey or "Not Bound")
end

local function HandleBindKey(key)
    if not isBinding then return end

    if key == "ESCAPE" then
        StopBinding()
        return
    end

    if key == "LSHIFT" or key == "RSHIFT" or key == "LCTRL" or key == "RCTRL" or key == "LALT" or key == "RALT" then return end

    if key == "LeftButton" then key = "BUTTON1" end
    if key == "RightButton" then key = "BUTTON2" end
    if key == "MiddleButton" then key = "BUTTON3" end
    if key == "Button4" then key = "BUTTON4" end
    if key == "Button5" then key = "BUTTON5" end

    local modifier = ""
    if IsShiftKeyDown() then modifier = modifier .. "SHIFT-" end
    if IsControlKeyDown() then modifier = modifier .. "CTRL-" end
    if IsAltKeyDown() then modifier = modifier .. "ALT-" end

    local bindString = modifier .. key
    StopBinding()

    local existingAction = GetBindingAction(bindString)
    if existingAction and existingAction ~= "" and existingAction ~= "CLICK QBuffFrame:LeftButton" then
        StaticPopup_Show("QBUFF_BIND_CONFLICT", bindString, existingAction, {bindString = bindString})
        hotkeyBtn:SetText("Waiting...")
    else
        local oldBind = GetBindingKey("CLICK QBuffFrame:LeftButton")
        if oldBind then SetBinding(oldBind) end

        SetBindingClick(bindString, "QBuffFrame", "LeftButton")
        SaveBindings(2)

        QBuffSettingsPerChar.hotkey = bindString
        hotkeyBtn:SetText(bindString)
    end
end

local function StartBinding()
    isBinding = true
    hotkeyBtn:SetText("Press a Key...")
    hotkeyBtn:SetBackdropBorderColor(1, 0.8, 0.1, 1.0)
    hotkeyBtn:SetBackdropColor(0.1, 0.3, 0.5, 0.7)
    hotkeyBtn:EnableKeyboard(true)
    if hotkeyBtn.SetPropagateKeyboardInput then
        hotkeyBtn:SetPropagateKeyboardInput(false)
    end
    hotkeyBtn:SetScript("OnKeyUp", function(self, key)
        HandleBindKey(key)
    end)
end

hotkeyBtn:RegisterForClicks("AnyUp")
hotkeyBtn:SetScript("OnClick", function(self, button)
    if isBinding then
        if button == "LeftButton" or button == "RightButton" then
            StopBinding()
        else
            HandleBindKey(button)
        end
        return
    end

    if button == "RightButton" then
        local oldBind = GetBindingKey("CLICK QBuffFrame:LeftButton")
        if oldBind then SetBinding(oldBind) end
        SaveBindings(2)
        QBuffSettingsPerChar.hotkey = nil
        hotkeyBtn:SetText("Not Bound")
    elseif button == "LeftButton" then
        StartBinding()
    end
end)

hotkeyBtn:SetScript("OnEnter", function(self)
    if not isBinding then
        self:SetBackdropBorderColor(0.1, 0.7, 1.0, 1.0)
        self:SetBackdropColor(0.1, 0.3, 0.5, 0.5)
    end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Buff Hotkey", 1, 0.8, 0.1)
    GameTooltip:AddLine("Left-Click: Set a new keybind.", 1, 1, 1)
    GameTooltip:AddLine("Right-Click: Clear keybind.", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("Press ESC while binding to cancel.", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)

hotkeyBtn:SetScript("OnLeave", function(self)
    if not isBinding then
        self:SetBackdropBorderColor(0.1, 0.7, 1.0, 0.5)
        self:SetBackdropColor(0, 0, 0, 0.5)
    end
    GameTooltip:Hide()
end)

f:SetScript("OnHide", function()
    if isBinding then
        StopBinding()
    end
    if QBuffClassPopup then QBuffClassPopup:Hide() end
    if QBuffSelfTimerPopup then QBuffSelfTimerPopup:Hide() end
    if QBuffGeneralSettings then QBuffGeneralSettings:Hide() end
end)

local colY = -45
local colSelf = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
colSelf:SetPoint("TOP", f, "TOPLEFT", 95, colY)
colSelf:SetText("Self")
colSelf:SetTextColor(0.1, 0.7, 1.0)
colSelf:SetJustifyH("CENTER")

local colParty = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
colParty:SetPoint("TOP", f, "TOPLEFT", 160, colY)
colParty:SetText("Party/Raid")
colParty:SetTextColor(0.1, 0.7, 1.0)
colParty:SetJustifyH("CENTER")

local colTravelers = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
colTravelers:SetPoint("TOP", f, "TOPLEFT", 225, colY)
colTravelers:SetText("Travelers")
colTravelers:SetTextColor(0.1, 0.7, 1.0)
colTravelers:SetJustifyH("CENTER")

local divider = f:CreateTexture(nil, "ARTWORK")
divider:SetPoint("TOPLEFT", 10, -60)
divider:SetPoint("TOPRIGHT", -10, -60)
divider:SetHeight(1)
divider:SetColorTexture(0.1, 0.7, 1.0, 0.5)

local contentFrame = CreateFrame("Frame", nil, f)
contentFrame:SetPoint("TOPLEFT", 10, -90)
contentFrame:SetPoint("BOTTOMRIGHT", -10, 10)
f.contentFrame = contentFrame

local function CreateModernCheckbox(parent, x, y, buffName, category, onStateChanged)
    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetPoint("TOP", parent, "TOPLEFT", x, y)
    cb:SetSize(26, 26)

    local function updateState()
        if QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
            cb:SetChecked(QBuffSettingsPerChar.buffs[buffName][category])
        else
            cb:SetChecked(true)
        end
    end

    cb:SetScript("OnShow", updateState)
    updateState()

    cb:SetScript("OnClick", function(self)
        if QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
            local isChecked = self:GetChecked()
            QBuffSettingsPerChar.buffs[buffName][category] = isChecked

            if onStateChanged then
                onStateChanged(category, isChecked)
            end

            if addonTable.ClearQueue then addonTable.ClearQueue() end
        end
    end)

    cb:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if category == "self" then
            GameTooltip:SetText("Self", 1, 0.8, 0.1)
            GameTooltip:AddLine("Apply this buff to yourself.", 1, 1, 1, true)
        elseif category == "party" then
            GameTooltip:SetText("Party/Raid", 1, 0.8, 0.1)
            GameTooltip:AddLine("Apply this buff to your group members.", 1, 1, 1, true)
        elseif category == "travelers" then
            GameTooltip:SetText("Travelers", 1, 0.8, 0.1)
            GameTooltip:AddLine("Apply this buff to friendly players you meet in the world.", 1, 1, 1, true)
        end
        GameTooltip:Show()
    end)

    cb:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return cb
end

local ClassPopupFrame = CreateFrame("Frame", "QBuffClassPopup", f, "BackdropTemplate")
ClassPopupFrame:SetSize(185, 80)
ClassPopupFrame:SetFrameStrata("TOOLTIP")
ClassPopupFrame:EnableMouse(true)
ClassPopupFrame:Hide()
ClassPopupFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
ClassPopupFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
ClassPopupFrame:SetBackdropBorderColor(0.1, 0.7, 1.0, 0.8)

local cpClose = CreateFrame("Button", nil, ClassPopupFrame, "UIPanelCloseButton")
cpClose:SetSize(24, 24)
cpClose:SetPoint("CENTER", ClassPopupFrame, "TOPRIGHT", 0, 0)
cpClose:SetScript("OnClick", function() ClassPopupFrame:Hide() end)

local CLASSES = {
    {class="WARRIOR", coords={0, 0.25, 0, 0.25}},
    {class="MAGE",    coords={0.25, 0.49609375, 0, 0.25}},
    {class="ROGUE",   coords={0.49609375, 0.7421875, 0, 0.25}},
    {class="DRUID",   coords={0.7421875, 0.98828125, 0, 0.25}},
    {class="HUNTER",  coords={0, 0.25, 0.25, 0.5}},
    {class="SHAMAN",  coords={0.25, 0.49609375, 0.25, 0.5}},
    {class="PRIEST",  coords={0.49609375, 0.7421875, 0.25, 0.5}},
    {class="WARLOCK", coords={0.7421875, 0.98828125, 0.25, 0.5}},
    {class="PALADIN", coords={0, 0.25, 0.5, 0.75}}
}

local classButtons = {}
ClassPopupFrame.currentBuff = nil

for i, data in ipairs(CLASSES) do
    local btn = CreateFrame("Button", nil, ClassPopupFrame, "BackdropTemplate")
    btn:SetSize(28, 28)
    local col = (i - 1) % 5
    local row = math.floor((i - 1) / 5)
    btn:SetPoint("TOPLEFT", 12 + (col * 32), -12 - (row * 32))

    local tex = btn:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints()
    tex:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
    tex:SetTexCoord(unpack(data.coords))
    btn.tex = tex
    btn.class = data.class

    btn:SetScript("OnClick", function(self)
        local buffName = ClassPopupFrame.currentBuff
        if not buffName or not QBuffSettingsPerChar or not QBuffSettingsPerChar.buffs then return end

        if not QBuffSettingsPerChar.buffs[buffName].classes then
            QBuffSettingsPerChar.buffs[buffName].classes = {}
        end

        local current = QBuffSettingsPerChar.buffs[buffName].classes[self.class]
        QBuffSettingsPerChar.buffs[buffName].classes[self.class] = not current

        if QBuffSettingsPerChar.buffs[buffName].classes[self.class] then
            self.tex:SetDesaturated(false)
            self.tex:SetVertexColor(1, 1, 1, 1)
        else
            self.tex:SetDesaturated(true)
            self.tex:SetVertexColor(0.4, 0.4, 0.4, 1)
        end
        if addonTable.ClearQueue then addonTable.ClearQueue() end
    end)

    table.insert(classButtons, btn)
end

function ClassPopupFrame:OpenForBuff(buffName, anchorFrame)
    self.currentBuff = buffName
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 15, 0)
    self:Show()

    if self.sliderFrame then self.sliderFrame:Hide() end

    local cfg = QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName]

    if cfg and not cfg.classes then
        if addonTable.BuffTargetClasses and addonTable.BuffTargetClasses[buffName] then
            cfg.classes = {}
            for k, v in pairs(addonTable.BuffTargetClasses[buffName]) do
                cfg.classes[k] = v
            end
        end
    end

    for _, btn in ipairs(classButtons) do
        if cfg and cfg.classes and cfg.classes[btn.class] then
            btn.tex:SetDesaturated(false)
            btn.tex:SetVertexColor(1, 1, 1, 1)
        else
            btn.tex:SetDesaturated(true)
            btn.tex:SetVertexColor(0.4, 0.4, 0.4, 1)
        end
    end

    if ClassPopupFrame.clockBtn then
        local threshold = (cfg and cfg.rebuffThreshold) or 60
        if cfg and cfg.rebuffThreshold == 0 then
            ClassPopupFrame.clockBtn.tex:SetDesaturated(true)
            ClassPopupFrame.clockBtn.tex:SetVertexColor(0.4, 0.4, 0.4, 1)
        else
            ClassPopupFrame.clockBtn.tex:SetDesaturated(false)
            ClassPopupFrame.clockBtn.tex:SetVertexColor(1, 1, 1, 1)
        end
    end
end

local clockBtn = CreateFrame("Button", nil, ClassPopupFrame, "BackdropTemplate")
clockBtn:SetSize(28, 28)
clockBtn:SetPoint("TOPLEFT", 12 + (4 * 32), -12 - (1 * 32))
local clockTex = clockBtn:CreateTexture(nil, "ARTWORK")
clockTex:SetAllPoints()
clockTex:SetTexture("Interface\\Icons\\INV_Misc_PocketWatch_01")
clockTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
clockBtn.tex = clockTex
ClassPopupFrame.clockBtn = clockBtn

local sliderFrame = CreateFrame("Frame", nil, ClassPopupFrame, "BackdropTemplate")
sliderFrame:SetSize(185, 50)
sliderFrame:SetPoint("TOPLEFT", ClassPopupFrame, "BOTTOMLEFT", 0, -5)
sliderFrame:SetBackdrop(ClassPopupFrame:GetBackdrop())
sliderFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
sliderFrame:SetBackdropBorderColor(0.1, 0.7, 1.0, 0.8)
sliderFrame:EnableMouse(true)
sliderFrame:Hide()
ClassPopupFrame.sliderFrame = sliderFrame

local slider = CreateFrame("Slider", "QBuffRebuffSlider", sliderFrame, "OptionsSliderTemplate")
slider:SetPoint("CENTER", 0, -5)
slider:SetWidth(150)
slider:SetMinMaxValues(0, 300)
slider:SetValueStep(5)
slider:SetObeyStepOnDrag(true)

_G[slider:GetName() .. "Low"]:SetText("0s")
_G[slider:GetName() .. "High"]:SetText("5m")

local sliderText = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
sliderText:SetPoint("BOTTOM", slider, "TOP", 0, 3)

slider:SetScript("OnValueChanged", function(self, value)
    local val = math.floor(value)
    if val == 0 then
        sliderText:SetText("Rebuff: Wait until expired")
    else
        local mins = math.floor(val / 60)
        local secs = val % 60
        if mins > 0 and secs > 0 then
            sliderText:SetText(string.format("Rebuff: %dm %ds remaining", mins, secs))
        elseif mins > 0 then
            sliderText:SetText(string.format("Rebuff: %dm remaining", mins))
        else
            sliderText:SetText(string.format("Rebuff: %ds remaining", secs))
        end
    end

    local buffName = ClassPopupFrame.currentBuff
    if buffName and QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
        QBuffSettingsPerChar.buffs[buffName].rebuffThreshold = val
        if val == 0 then
            clockTex:SetDesaturated(true)
            clockTex:SetVertexColor(0.4, 0.4, 0.4, 1)
        else
            clockTex:SetDesaturated(false)
            clockTex:SetVertexColor(1, 1, 1, 1)
        end
    end
end)

clockBtn:SetScript("OnEnter", function(self)
    if sliderFrame:IsShown() then return end
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
    GameTooltip:SetText("Early Rebuff Timer", 1, 0.8, 0.1)
    GameTooltip:AddLine("Set how many seconds before expiration\nthis buff should be re-applied.", 1, 1, 1)
    GameTooltip:AddLine("Applies to Self and Party/Raid only.", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)
clockBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
clockBtn:SetScript("OnClick", function()
    if sliderFrame:IsShown() then
        sliderFrame:Hide()
    else
        local buffName = ClassPopupFrame.currentBuff
        if buffName and QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
            local val = QBuffSettingsPerChar.buffs[buffName].rebuffThreshold or 60
            slider:SetValue(val)
        end
        sliderFrame:Show()
        GameTooltip:Hide()
    end
end)

local SelfTimerPopupFrame = CreateFrame("Frame", "QBuffSelfTimerPopup", f, "BackdropTemplate")
SelfTimerPopupFrame:SetSize(185, 50)
SelfTimerPopupFrame:SetFrameStrata("TOOLTIP")
SelfTimerPopupFrame:EnableMouse(true)
SelfTimerPopupFrame:Hide()
SelfTimerPopupFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
SelfTimerPopupFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
SelfTimerPopupFrame:SetBackdropBorderColor(0.1, 0.7, 1.0, 0.8)

local selfSlider = CreateFrame("Slider", "QBuffSelfRebuffSlider", SelfTimerPopupFrame, "OptionsSliderTemplate")
selfSlider:SetPoint("CENTER", 0, -5)
selfSlider:SetWidth(150)
selfSlider:SetMinMaxValues(0, 300)
selfSlider:SetValueStep(5)
selfSlider:SetObeyStepOnDrag(true)

_G[selfSlider:GetName() .. "Low"]:SetText("0s")
_G[selfSlider:GetName() .. "High"]:SetText("5m")

local selfSliderText = selfSlider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
selfSliderText:SetPoint("BOTTOM", selfSlider, "TOP", 0, 3)

selfSlider:SetScript("OnValueChanged", function(self, value)
    local val = math.floor(value)
    if val == 0 then
        selfSliderText:SetText("Rebuff: Wait until expired")
    else
        local mins = math.floor(val / 60)
        local secs = val % 60
        if mins > 0 and secs > 0 then
            selfSliderText:SetText(string.format("Rebuff: %dm %ds remaining", mins, secs))
        elseif mins > 0 then
            selfSliderText:SetText(string.format("Rebuff: %dm remaining", mins))
        else
            selfSliderText:SetText(string.format("Rebuff: %ds remaining", secs))
        end
    end

    local buffName = SelfTimerPopupFrame.currentBuff
    if buffName and QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
        QBuffSettingsPerChar.buffs[buffName].rebuffThreshold = val
    end
end)

function SelfTimerPopupFrame:OpenForBuff(buffName, anchorFrame)
    self.currentBuff = buffName
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -5)
    self:Show()

    local cfg = QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName]
    local val = (cfg and cfg.rebuffThreshold) or 60
    selfSlider:SetValue(val)
end

f:SetScript("OnShow", function()
    if QBuffSettingsPerChar and QBuffSettingsPerChar.hotkey then
        hotkeyBtn:SetText(QBuffSettingsPerChar.hotkey)
    else
        hotkeyBtn:SetText("Not Bound")
    end

    if QBuffSettingsPerChar and QBuffSettingsPerChar.buffPvP ~= nil then
        pvpCb:SetChecked(QBuffSettingsPerChar.buffPvP)
    else
        pvpCb:SetChecked(false)
    end

    if QBuffSettingsPerChar and QBuffSettingsPerChar.showGlow ~= nil then
        glowCb:SetChecked(QBuffSettingsPerChar.showGlow)
    else
        glowCb:SetChecked(true)
    end

    if contentFrame.initialized then return end
    if not addonTable.MyBuffs then return end

    local normalBuffs = {}
    local selfBuffs = {}
    for _, buffName in ipairs(addonTable.MyBuffs) do
        local isSelfCast = addonTable.IsSelfCastBuff and addonTable.IsSelfCastBuff[buffName]
        local isSelfOnly = isSelfCast
        if isSelfOnly then
            table.insert(selfBuffs, buffName)
        else
            table.insert(normalBuffs, buffName)
        end
    end

    local numNormal = #normalBuffs
    local numSelf = #selfBuffs
    local numSelfRows = math.ceil(numSelf / 4)

    local contentStartY = -70
    local baseHeight = 85

    if numNormal == 0 then
        colSelf:Hide()
        colParty:Hide()
        colTravelers:Hide()
        divider:Hide()
        contentStartY = -35
        baseHeight = 50
    else
        colSelf:Show()
        colParty:Show()
        colTravelers:Show()
        divider:Show()
        contentStartY = -70
        baseHeight = 85
    end

    contentFrame:ClearAllPoints()
    contentFrame:SetPoint("TOPLEFT", 10, contentStartY)
    contentFrame:SetPoint("BOTTOMRIGHT", -10, 10)

    local showDivider = (numNormal > 0 and numSelf > 1)
    local dividerHeight = showDivider and 14 or 0
    local selfSectionHeight = (numSelfRows > 0) and (dividerHeight + (numSelfRows * 44)) or 0

    local newHeight = baseHeight + (numNormal * 46) + selfSectionHeight + 15
    if newHeight % 2 ~= 0 then newHeight = newHeight + 1 end
    f:SetHeight(newHeight)

    local rowUpdaters = {}

    local function DeactivateMutuallyExclusiveCategory(activatedBuff, cat)
        local groups = addonTable.BuffMutuallyExclusive
        if not groups then return end

        for _, group in ipairs(groups) do
            local inGroup = false
            for _, member in ipairs(group) do
                if member == activatedBuff then
                    inGroup = true
                    break
                end
            end

            if inGroup then
                for _, member in ipairs(group) do
                    if member ~= activatedBuff then
                        local otherCfg = QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[member]
                        if otherCfg then
                            local updater = rowUpdaters[member]
                            local isSelfCast = addonTable.IsSelfCastBuff and addonTable.IsSelfCastBuff[member]
                            local isSelfOnly = isSelfCast
                            local canSelf = not isSelfOnly
                            local canParty = not isSelfOnly
                            local canTravelers = not isSelfCast

                            local actIsSelfCast = addonTable.IsSelfCastBuff and addonTable.IsSelfCastBuff[activatedBuff]
                            local actIsSelfOnly = actIsSelfCast

                            if actIsSelfOnly or isSelfOnly then
                                otherCfg.enabled = false
                                otherCfg.self = false
                                if updater and updater.cbSelf then updater.cbSelf:SetChecked(false) end
                            elseif cat then
                                if cat == "self" then
                                    otherCfg.self = false
                                    if updater and updater.cbSelf then updater.cbSelf:SetChecked(false) end
                                elseif cat == "party" then
                                    otherCfg.party = false
                                    if updater and updater.cbParty then updater.cbParty:SetChecked(false) end
                                elseif cat == "travelers" then
                                    otherCfg.travelers = false
                                    if updater and updater.cbTravelers then updater.cbTravelers:SetChecked(false) end
                                end
                            else
                                local actCfg = QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[activatedBuff]
                                if actCfg then
                                    if actCfg.self then
                                        otherCfg.self = false
                                        if updater and updater.cbSelf then updater.cbSelf:SetChecked(false) end
                                    end
                                    if actCfg.party then
                                        otherCfg.party = false
                                        if updater and updater.cbParty then updater.cbParty:SetChecked(false) end
                                    end
                                    if actCfg.travelers then
                                        otherCfg.travelers = false
                                        if updater and updater.cbTravelers then updater.cbTravelers:SetChecked(false) end
                                    end
                                end
                            end

                            local hasRemaining = false
                            if not isSelfOnly then
                                hasRemaining = (canSelf and otherCfg.self) or (canParty and otherCfg.party) or (canTravelers and otherCfg.travelers)
                            end

                            if not hasRemaining then
                                otherCfg.enabled = false
                            end

                            if updater then
                                updater.updateIcon()
                            end
                        end
                    end
                end
            end
        end
    end

    local function SetupBuffItem(buffName, isSelfOnly, xPos, yPos)
        local iconBg = CreateFrame("Button", nil, contentFrame, "BackdropTemplate")
        iconBg:SetSize(36, 36)
        iconBg:SetPoint("TOPLEFT", xPos, yPos)

        iconBg:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })

        local icon = iconBg:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", 3, -3)
        icon:SetPoint("BOTTOMRIGHT", -3, 3)
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        local texture = (addonTable.BuffIcons and addonTable.BuffIcons[buffName]) or (C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(buffName)) or (GetSpellTexture and GetSpellTexture(buffName))
        if texture then
            icon:SetTexture(texture)
        else
            icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end

        local cbSelf, cbParty, cbTravelers

        local function UpdateIconState()
            local isEnabled = true
            if QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
                if QBuffSettingsPerChar.buffs[buffName].enabled ~= nil then
                    isEnabled = QBuffSettingsPerChar.buffs[buffName].enabled
                end
            end

            if isEnabled then
                icon:SetDesaturated(false)
                icon:SetVertexColor(1, 1, 1, 1)
                iconBg:SetBackdropBorderColor(1, 0.8, 0.1, 1)
                if cbSelf then cbSelf:Enable(); cbSelf:SetAlpha(1) end
                if cbParty then cbParty:Enable(); cbParty:SetAlpha(1) end
                if cbTravelers then cbTravelers:Enable(); cbTravelers:SetAlpha(1) end
            else
                icon:SetDesaturated(true)
                icon:SetVertexColor(0.4, 0.4, 0.4, 1)
                iconBg:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
                if cbSelf then cbSelf:Disable(); cbSelf:SetAlpha(0.4) end
                if cbParty then cbParty:Disable(); cbParty:SetAlpha(0.4) end
                if cbTravelers then cbTravelers:Disable(); cbTravelers:SetAlpha(0.4) end
            end
        end

        local isSelfCast = addonTable.IsSelfCastBuff and addonTable.IsSelfCastBuff[buffName]
        local canSelf = not isSelfOnly
        local canParty = not isSelfOnly
        local canTravelers = not isSelfCast

        if not canParty and QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
            QBuffSettingsPerChar.buffs[buffName].party = false
        end
        if not canTravelers and QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
            QBuffSettingsPerChar.buffs[buffName].travelers = false
        end

        local function OnCheckboxChanged(category, isChecked)
            local cfg = QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName]
            if not cfg then return end
            if isChecked then
                if cfg.enabled == false then
                    cfg.enabled = true
                    UpdateIconState()
                end
                DeactivateMutuallyExclusiveCategory(buffName, category)
            else
                local hasAny = (canSelf and cfg.self) or (canParty and cfg.party) or (canTravelers and cfg.travelers)
                if not hasAny then
                    cfg.enabled = false
                    UpdateIconState()
                end
            end
        end

        iconBg:RegisterForClicks("AnyUp")
        iconBg:SetScript("OnShow", UpdateIconState)
        iconBg:SetScript("OnClick", function(self, button)
            if button == "RightButton" then
                if isSelfOnly then
                    if QBuffSelfTimerPopup:IsShown() and QBuffSelfTimerPopup.currentBuff == buffName then
                        QBuffSelfTimerPopup:Hide()
                    else
                        QBuffSelfTimerPopup:OpenForBuff(buffName, self)
                    end
                else
                    if ClassPopupFrame:IsShown() and ClassPopupFrame.currentBuff == buffName then
                        ClassPopupFrame:Hide()
                    else
                        ClassPopupFrame:OpenForBuff(buffName, self)
                    end
                end
                return
            end

            if QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
                local current = QBuffSettingsPerChar.buffs[buffName].enabled
                if current == nil then current = true end
                local newState = not current
                QBuffSettingsPerChar.buffs[buffName].enabled = newState

                if newState then
                    if isSelfOnly then
                        QBuffSettingsPerChar.buffs[buffName].self = true
                        DeactivateMutuallyExclusiveCategory(buffName, "self")
                    else
                        local cfg = QBuffSettingsPerChar.buffs[buffName]
                        local hasAny = (canSelf and cfg.self) or (canParty and cfg.party) or (canTravelers and cfg.travelers)
                        if not hasAny then
                            cfg.self = true
                            if cbSelf then cbSelf:SetChecked(true) end
                        end
                        DeactivateMutuallyExclusiveCategory(buffName, nil)
                    end
                else
                    if isSelfOnly then
                    else
                    end
                end

                UpdateIconState()
                if addonTable.ClearQueue then addonTable.ClearQueue() end

                if GameTooltip:IsOwned(self) then
                    self:GetScript("OnEnter")(self)
                end
            end
        end)

        iconBg:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(buffName, 1, 0.8, 0.1)

            local isEnabled = true
            if QBuffSettingsPerChar and QBuffSettingsPerChar.buffs and QBuffSettingsPerChar.buffs[buffName] then
                if QBuffSettingsPerChar.buffs[buffName].enabled ~= nil then
                    isEnabled = QBuffSettingsPerChar.buffs[buffName].enabled
                end
            end

            if isEnabled then
                GameTooltip:AddLine("Status: |cFF00FF00Active|r", 1, 1, 1)
            else
                GameTooltip:AddLine("Status: |cFFFF0000Inactive|r", 1, 1, 1)
            end

            GameTooltip:AddLine("Left-Click: Toggle this buff On/Off.", 0.8, 0.8, 0.8, true)
            if not isSelfOnly then
                GameTooltip:AddLine("Right-Click: Configure Target Classes & Timer.", 0.1, 0.8, 1, true)
            else
                GameTooltip:AddLine("Right-Click: Configure Rebuff Timer.", 0.1, 0.8, 1, true)
            end
            GameTooltip:Show()
        end)

        iconBg:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
        UpdateIconState()

        if canSelf then
            cbSelf = CreateModernCheckbox(contentFrame, 85, yPos - 5, buffName, "self", OnCheckboxChanged)
        end
        if canParty then
            cbParty = CreateModernCheckbox(contentFrame, 150, yPos - 5, buffName, "party", OnCheckboxChanged)
        end
        if canTravelers then
            cbTravelers = CreateModernCheckbox(contentFrame, 215, yPos - 5, buffName, "travelers", OnCheckboxChanged)
        end

        rowUpdaters[buffName] = {
            updateIcon = UpdateIconState,
            cbSelf = cbSelf,
            cbParty = cbParty,
            cbTravelers = cbTravelers,
        }
    end

    local yOffset = -10
    for _, buffName in ipairs(normalBuffs) do
        SetupBuffItem(buffName, false, 15, yOffset)
        yOffset = yOffset - 46
    end

    if numSelf > 0 then
        if showDivider then
            if not contentFrame.selfDivider then
                contentFrame.selfDivider = contentFrame:CreateTexture(nil, "ARTWORK")
                contentFrame.selfDivider:SetHeight(1)
                contentFrame.selfDivider:SetColorTexture(0.1, 0.7, 1.0, 0.3)
            end
            contentFrame.selfDivider:ClearAllPoints()
            contentFrame.selfDivider:SetPoint("TOPLEFT", 10, yOffset - 2)
            contentFrame.selfDivider:SetPoint("TOPRIGHT", -10, yOffset - 2)
            contentFrame.selfDivider:Show()

            yOffset = yOffset - 14
        elseif contentFrame.selfDivider then
            contentFrame.selfDivider:Hide()
        end

        for idx, buffName in ipairs(selfBuffs) do
            local col = (idx - 1) % 4
            local row = math.floor((idx - 1) / 4)
            local xPos = 15 + (col * 58)
            local currentY = yOffset - (row * 44)
            SetupBuffItem(buffName, true, xPos, currentY)
        end

        yOffset = yOffset - (numSelfRows * 44)
    elseif contentFrame.selfDivider then
        contentFrame.selfDivider:Hide()
    end

    contentFrame:SetHeight(math.abs(yOffset) + 10)
    contentFrame.initialized = true
end)
