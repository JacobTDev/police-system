--[[

Department IDs:

Civilian = 0
CFD = 1
CPD = 2
CCSO = 3

]]

local serviceListStatus = {}
local serviceListBlips = {}
local playersList = {}
local currentDepartmentID = nil
local hasReceivedDepartmentID = false
local isPolice = false
local inService = false
local hasReceivedPlayersList = false
local currentlyGrabbing = false
local grabbedPed = nil
local pedToGrab = nil

local policeStations = { vector3(1857.01, 3689.56, 34.2671) }

exports("IsPlayerInService", function() 
  return inService
end)

RegisterNetEvent("ps:GetPlayersList")
AddEventHandler("ps:GetPlayersList", function(list) 
  playersList = list
  hasReceivedPlayersList = true
end)

-- Get current department
AddEventHandler("onClientResourceStart", function()
  TriggerServerEvent("ps:SendCurrentDepartmentID")

  while not hasReceivedDepartmentID do
    Citizen.Wait(0)
  end

  if currentDepartmentID == 2 or currentDepartmentID == 3 then
    isPolice = true
    hasReceivedDepartmentID = true
  end
end)

RegisterNetEvent("ps:GetCurrentDepartmentID")
AddEventHandler("ps:GetCurrentDepartmentID", function(departmentID) 
  currentDepartmentID = departmentID
  hasReceivedDepartmentID = true
end) 

-- draw markers for stations and check if player is on them
Citizen.CreateThread(function() 
  while true do 
    Citizen.Wait(0)
    if isPolice then
      DrawServiceMarkers()
      IsPlayerOnServiceMarker()
    end
  end
end)

function DrawServiceMarkers() 
  for i, s in ipairs(policeStations) do
    DrawMarker(1, s.x, s.y, s.z - 1, 
    0.0, 0.0, 0.0, 0, 0.0, 0.0, 
    0.75, 0.75, 0.75, 17, 103, 177, 255, 
    false, true, 2, false, false, false, false)
  end
end 

function IsPlayerOnServiceMarker() 
  local pos = GetEntityCoords(PlayerPedId())

  for i, s in ipairs(policeStations) do
    if #(pos - s) <= 2 then
      if inService then
        DisplayHelpText("Press ~INPUT_VEH_HORN~ to go off duty")
      else
        DisplayHelpText("Press ~INPUT_VEH_HORN~ to go on duty")
      end
      
      if IsControlJustReleased(1, 86) then
        PlayerToggleService()
      end
    end
  end
end

function PlayerToggleService()
  inService = not inService

  if inService then
    serviceListStatus = {}
    serviceListBlips = {}
    TriggerServerEvent("ps:SendInitialServiceListStatus")
    Citizen.Wait(10)
    TriggerServerEvent("ps:InService", PlayerPedId())
  else
    TriggerServerEvent("ps:NotInService", PlayerPedId())
    RemoveServiceBlips()
  end    
end 

function IsPlayerInService() 
  return inService
end

-- Add blip for all officers on duty
RegisterNetEvent("ps:GetInitialServiceListStatus")
AddEventHandler("ps:GetInitialServiceListStatus", function(list) 
  serviceListStatus = list
  AddServiceBlips()
end)

function AddServiceBlips() 
  for i, p in pairs(serviceListStatus) do
    if p == 1 then
      local blip = AddBlipForEntity(tonumber(i))
      serviceListBlips[i] = blip
      SetBlipOptions(i)
    end
  end
end

RegisterNetEvent("ps:GetChangeInServiceListStatus")
AddEventHandler("ps:GetChangeInServiceListStatus", function(_playerPedId, newStatus) 
  serviceListStatus[_playerPedId] = newStatus

  if inService then
    if newStatus == 0 then
      RemoveServiceBlip(_playerPedId)
    else
      AddServiceBlip(_playerPedId)
    end
  end
end)

function AddServiceBlip(_playerPedId) 
  if serviceListBlips[_playerPedId] == nil then
    local blip = AddBlipForEntity(tonumber(_playerPedId))
    serviceListBlips[_playerPedId] = blip
    SetBlipOptions(_playerPedId)
  end
end 

function SetBlipOptions(blipId)
  local blip = serviceListBlips[blipId]

  --blip options here
  SetBlipSprite(blip, 148)
  SetBlipDisplay(blip, 2)
  SetBlipScale(blip, 1.0)
  SetBlipColour(blip, 12) 
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(GetPlayerName(blipId))
  EndTextCommandSetBlipName(blip)
end

function RemoveServiceBlip(_playerPedId)
  local blip = serviceListBlips[_playerPedId]

  if blip ~= nil then
    if DoesBlipExist(blip) then
      RemoveBlip(blip)
      blip = nil
    else
      blip = nil
    end
  end
end

function RemoveServiceBlips() 
  for i, blip in pairs(serviceListBlips) do
    if blip ~= nil then
      if DoesBlipExist(blip) then
        RemoveBlip(blip)
        blip = nil
      else
        blip = nil
      end
    end
  end
end

-- Utility Functions
function DisplayHelpText(text)
  BeginTextCommandDisplayHelp("STRING");  
  AddTextComponentSubstringPlayerName(text);  
  EndTextCommandDisplayHelp(0, 0, 1, -1);
end

function FindClosestPlayer()
  playersList = {}
  hasReceivedPlayersList = false
  TriggerServerEvent("ps:SendPlayersList")

  local playerPos = GetEntityCoords(PlayerPedId())

  while not hasReceivedPlayersList do
    Citizen.Wait(0)
  end

  local closestPlayer = nil
  local minValue = 1000000

  for i, player in ipairs(players) do
    local playerId = GetPlayerFromServerId(player)
    
    if not playerId == PlayerPedId() then
      local otherPos = GetEntityCoords(playerId)
      local distance = #(playerPos - otherPos)

      if distance < minValue then
        minValue = distance
        closestPlayer = playerId
      end
    end
  end

  return closestPlayer
end