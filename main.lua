local api = require("api")
local settingsPage = require('automatic_raid_roles/settings_page')


local automatic_raid_roles = {
  name = "Automatic Raid Roles",
  author = "Winterflame",
  desc = "Automatically sets your raid role.",
  version = "1.0"
}

local function OnRoleChanged(role)
  api.File:Write("automatic_raid_roles/settings.txt", { role = role})
end

local function OnTeamChanged()
  local savedRole = api.File:Read("automatic_raid_roles/settings.txt")
  api.Team:SetRole(savedRole.role)
end


local function OnLoad() 
  api.On("raid_role_changed", OnRoleChanged)
  api.On("TEAM_MEMBERS_CHANGED", OnTeamChanged)
  
  CANVAS = api.Interface:CreateEmptyWindow("AutomaticRaidRoles")
  CANVAS:Show(true)
  CANVAS.OnSettingsSaved = OnSettingsSaved
  
  -- Load other dependencies
  --   Create Settings UI
  settingsPage.init(CANVAS)

  -- Log current saved role as an welcome info message
  local playerId = api.Unit:GetUnitId("player")
  local playerInfo = api.Unit:GetUnitInfoById(playerId)
  local savedRole = api.File:Read("automatic_raid_roles/settings.txt")
  local roleNames = {
    [1] = "Tank (Green)",
    [2] = "Healer (Pink)",
    [3] = "DPS (Red)",
    [4] = "None (Blue)"
  }

  local playerName = playerInfo and playerInfo.name or "Unknown"
  local roleNumber = savedRole and savedRole.role or nil
  local roleName = roleNumber and roleNames[roleNumber] or nil

  if roleName then
    api.Log:Info("[Automatic Raid Roles] Welcome " .. playerName .. "! Your current saved role is [" .. roleName .. "].")
  else
    api.Log:Info("[Automatic Raid Roles] Welcome " .. playerName .. "! You currently have no saved role. You can change it at addon settings if preferred, or just set it in a raid.")
  end
end

local function OnUnload()
  settingsPage.unload()
  api.Log:Info("[Automatic Raid Roles] Unloaded.")
end

automatic_raid_roles.OnLoad = OnLoad
automatic_raid_roles.OnUnload = OnUnload
automatic_raid_roles.OnSettingToggle = settingsPage.open
return automatic_raid_roles
