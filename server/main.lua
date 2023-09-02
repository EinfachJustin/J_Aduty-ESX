ESX = nil
ESX = exports["es_extended"]:getSharedObject()

RegisterCommand(Config.commandName, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    local allowed = false
    for group, outfit in pairs(Config.outfits) do
        if xPlayer and xPlayer.getGroup() == group then
            allowed = true
            TriggerClientEvent('adminclothing:equip', source, outfit)
            break
        end
    end

    if not allowed then
        TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, Config.noPermissionMessage)
    end
end, true, {help = 'Admin-Kleidung anziehen'})

RegisterNetEvent('adminclothing:toggleGodMode')
AddEventHandler('adminclothing:toggleGodMode', function(playerId, enable)
    local playerPed = GetPlayerPed(playerId)

    if enable then
        SetEntityInvincible(playerPed, true)
    else
        SetEntityInvincible(playerPed, false)
    end
end)


RegisterNetEvent('adminclothing:equip')
AddEventHandler('adminclothing:equip', function()
end)
