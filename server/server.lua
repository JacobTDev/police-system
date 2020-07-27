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