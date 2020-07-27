local serviceListStatus = {}

RegisterNetEvent("ps:SendCurrentDepartmentID")
AddEventHandler("ps:SendCurrentDepartmentID", function() 
    --[[Department IDs:
    Civilian = 0
    CFD = 1
    CPD = 2
    CCSO = 3]]

    local _source = source

    if IsPlayerAceAllowed(_source, "group.cfd") then
        TriggerClientEvent("ps:GetCurrentDepartmentID", _source, 1)
    elseif IsPlayerAceAllowed(_source, "group.cpd") then
        TriggerClientEvent("ps:GetCurrentDepartmentID", _source, 2)
    elseif IsPlayerAceAllowed(_source, "group.ccso") then
        TriggerClientEvent("ps:GetCurrentDepartmentID", _source, 3)
    else
        TriggerClientEvent("ps:GetCurrentDepartmentID", _source, 0)
    end
end)

RegisterNetEvent("ps:SendInitialServiceListStatus")
AddEventHandler("ps:SendInitialServiceListStatus", function() 
   local _source = source
   TriggerClientEvent("ps:GetInitialServiceListStatus", _source, serviceListStatus)
end)

RegisterNetEvent("ps:NotInService")
AddEventHandler("ps:NotInService", function(playerPedId)
    local newStatus = 0
    
    _playerPedId = tostring(playerPedId)
    serviceListStatus[_playerPedId] = status

    TriggerClientEvent("ps:GetChangeInServiceListStatus", -1, _playerPedId, newStatus)
end) 