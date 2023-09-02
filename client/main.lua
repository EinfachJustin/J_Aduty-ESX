local playerSkin = nil
local ESX = exports["es_extended"]:getSharedObject()
local isWearingAdminClothing = false
local godModeActive = false

function GetPlayerStats()
    local playerPed = GetPlayerPed(-1)
    local health = GetEntityHealth(playerPed)
    local armor = GetPedArmour(playerPed)
    return health, armor
end


function DrawPlayerStats(health, armor)
    local playerPed = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    z = z + 1.5 
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen and Config.showHealthAndArmor then
        local heartEmote = "❤️" -- 
        local shieldEmote = "🛡️" -- 
        local text = heartEmote .. " " .. health .. "  " .. shieldEmote .. " " .. armor
        SetTextScale(0.0, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y + 0.04)
    end
end

function DrawPlayerInfo(playerId, playerName, jobName)
    local playerPed = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    z = z + 1.5
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then

        local text = ""
        if Config.showPlayerId then
            text = "ID: " .. playerId
        end
        if Config.showPlayerName then
            if Config.showPlayerId then
                text = text .. " | "
            end
            text = text .. playerName
        end
        if Config.showJobName then
            if Config.showPlayerId or Config.showPlayerName then
                text = text .. " | " 
            end
            text = text .. "(" .. jobName .. ")"
        end

        SetTextScale(0.0, 0.40)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x - 0.03, _y)
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if godModeActive then
            local playerId = GetPlayerServerId(PlayerId())
            local playerName = GetPlayerName(PlayerId())
            local jobName = ESX.GetPlayerData().job.label
            local health, armor = GetPlayerStats()
            DrawPlayerInfo(playerId, playerName, jobName)
            DrawPlayerStats(health, armor) 
        end
    end
end)

RegisterNetEvent('adminclothing:equip')
AddEventHandler('adminclothing:equip', function(outfit)
    isWearingAdminClothing = not isWearingAdminClothing

    local playerPed = GetPlayerPed(-1)

    if isWearingAdminClothing then
        SetPedComponentVariation(playerPed, 1, outfit.mask[1], outfit.mask[2], 0)
        SetPedComponentVariation(playerPed, 11, outfit.top[1], outfit.top[2], 0)
        SetPedComponentVariation(playerPed, 4, outfit.pants[1], outfit.pants[2], 0)
        SetPedComponentVariation(playerPed, 6, outfit.shoes[1], outfit.shoes[2], 0)
        SetPedComponentVariation(playerPed, 3, outfit.arms[1], outfit.arms[2], 0)


        godModeActive = true
        SetEntityInvincible(playerPed, true)
    else

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            local model = skin.model
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin)
            godModeActive = false
            SetEntityInvincible(playerPed, false)
        end)
    end
end)
