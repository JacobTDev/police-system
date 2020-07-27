--[[

Department IDs:

Civilian = 0
CFD = 1
CPD = 2
CCSO = 3

]]

local currentDepartmentID = nil
local hasReceivedDepartmentID = false
local isPolice = false
local inService = false

local policeStations = { vector3(1857.01, 3689.56, 34.2671) }

-- Get current department
AddEventHandler("onClientResourceStart", function()
    TriggerServerEvent("ps:SendCurrentDepartmentID")

    while not hasReceivedDepartmentID do
        Citizen.Wait(0)
    end

    if currentDepartmentID == 2 or currentDepartmentID == 3 then
        isPolice = true
        inService = false
        hasReceivedDepartmentID = true
    end
end)

RegisterNetEvent("ps:GetCurrentDepartmentID")
AddEventHandler("ps:GetCurrentDepartmentID", function(departmentID) 
    currentDepartmentID = departmentID
    hasReceivedDepartmentID = true
end) 

-- draw marker for station
Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(0)
        if isPolice then
            DrawServiceMarkers()
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