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

-- Get current department
AddEventHandler("onClientResourceStart", function()
    TriggerServerEvent("ps:SendCurrentDepartmentID")

    while not hasReceivedDepartmentID do
        Citizen.Wait(0)
    end

    if currentDepartmentID == 2 or currentDepartmentID == 3 then
        isPolice = true
        inService = false
        
    end
end)

RegisterNetEvent("ps:GetCurrentDepartmentID")
AddEventHandler("ps:GetCurrentDepartmentID", function(departmentID) 
    currentDepartmentID = departmentID
    hasReceivedDepartmentID = true
end) 

