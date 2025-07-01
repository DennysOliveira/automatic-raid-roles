local api = require("api")
local settingsWindow
local settings
local settingsControls = {}

local function createLabel(id, parent, text, offsetX, offsetY, fontSize)
  local labelHeight = 20

  local label = api.Interface:CreateWidget('label', id, parent)
  label:AddAnchor("TOPLEFT", offsetX, offsetY)
  label:SetExtent(255, labelHeight)
  label:SetText(text)
  label.style:SetColor(FONT_COLOR.TITLE[1], FONT_COLOR.TITLE[2],
                       FONT_COLOR.TITLE[3], 1)
  label.style:SetAlign(ALIGN.LEFT)
  label.style:SetFontSize(fontSize or 18)

  return label
end

local function createComboBox(parent, values, x, y)
  local dropdownBtn = W_CTRL.CreateComboBox(parent)
  dropdownBtn:AddAnchor("TOPLEFT", parent, x, y)
  dropdownBtn:SetExtent(200, 24)
  dropdownBtn.dropdownItem = values
  return dropdownBtn
end

local function createButton(id, parent, text, x, y)
  local button = api.Interface:CreateWidget('button', id, parent)
  button:AddAnchor("TOPLEFT", x, y)
  button:SetExtent(55, 26)
  button:SetText(text)
  api.Interface:ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
  return button
end

local function saveSettings()
  settings = api.GetSettings("automatic_raid_roles/settings.txt")

  local selectedUserRole = settingsControls.selectRoleCombo:GetSelectedIndex()
  api.File:Write("automatic_raid_roles/settings.txt", { role = selectedUserRole })
  api.Team:SetRole(selectedUserRole)

  api.Log:Info('Automatic Raid Roles settings saved.')
end


local function createSettingsPage()
  settings = api.GetSettings("automatic_raid_roles/settings.txt")
  settingsWindow = api.Interface:CreateWindow("ARRSettings", "Automatic Raid Roles Settings", 600, 300)

  settingsWindow:AddAnchor("CENTER", "UIParent", 0, 0)
  local wW, wH = settingsWindow:GetExtent()

  local leftPadding = 25
  local dynamicVerticalOffset = 60

  createLabel('selectRoleLabel', settingsWindow, 'Role Desired', leftPadding,  dynamicVerticalOffset, 14)
  dynamicVerticalOffset = dynamicVerticalOffset + 25
  
  local selectRoleCombo = createComboBox(settingsWindow, {'Tank (Green)', 'Healer (Pink)', 'DPS (Red)', 'Undecided (Blue)'}, leftPadding, dynamicVerticalOffset)
  selectRoleCombo:Select(settings.role)
  settingsControls.selectRoleCombo = selectRoleCombo

  dynamicVerticalOffset = dynamicVerticalOffset + 30

  local saveButton = createButton('saveButton', settingsWindow, 'Save Settings', leftPadding, dynamicVerticalOffset)

  saveButton:SetHandler("OnClick", saveSettings)

  return settingsWindow
end

local function Unload()
  if settingsWindow ~= nil then
    settingsWindow:Show(false)
    settingsWindow = nil
  end
end

local function openSettingsWindow() settingsWindow:Show(true) end

local settings_page = {
  init = createSettingsPage,
  unload = Unload,
  open = openSettingsWindow,
}

return settings_page
