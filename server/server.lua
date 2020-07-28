local serviceListStatus = {}

RegisterNetEvent("ps:SendCurrentDepartmentID")
AddEventHandler("ps:SendCurrentDepartmentID", function() 
    --[[Department IDs:
    Civilian = 0
    CFD = 1
    CPD = 2
    CCSO = 3]]

    local _source = source

    if exports.discord_perms:IsRolePresent(_source, 737687318592225300) then
        TriggerClientEvent("ps:GetCurrentDepartmentID", _source, 1)
    elseif exports.discord_perms:IsRolePresent(_source, 737687140355539064) then
        TriggerClientEvent("ps:GetCurrentDepartmentID", _source, 2)
    elseif exports.discord_perms:IsRolePresent(_source, 737687425945567243) then
        TriggerClientEvent("ps:GetCurrentDepartmentID", _source, 3)
    else
        TriggerClientEvent("ps:GetCurrentDepartmentID", _source, 0)
    end
end)

RegisterNetEvent("ps:InService")
AddEventHandler("ps:InService", function(playerPedId)
    local newStatus = 1
    
    _playerPedId = tostring(playerPedId)
    serviceListStatus[_playerPedId] = newStatus

    TriggerClientEvent("ps:GetChangeInServiceListStatus", -1, _playerPedId, newStatus)
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
    serviceListStatus[_playerPedId] = newStatus

    TriggerClientEvent("ps:GetChangeInServiceListStatus", -1, _playerPedId, newStatus)
end) 



