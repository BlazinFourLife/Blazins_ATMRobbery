local QBCore = exports['qb-core']:GetCoreObject()
local lib = exports['ox_lib']

local function hasHackingPhone()
    local hasItem = false
    QBCore.Functions.TriggerCallback('atmrobbery:checkItem', function(result)
        hasItem = result
    end, Config.RequiredItem)
    Wait(200)
    return hasItem
end

local function showNotification(title, message, type)
    if Config.NotificationSystem == '17mov_Hud' then
        TriggerEvent("17mov_Hud:ShowHelpNotificationWhile", message)
    elseif Config.NotificationSystem == 'okokNotify' then
        exports['okokNotify']:Alert(title, message, 5000, type, true)
    elseif Config.NotificationSystem == 'ox_lib' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = title,
            description = message,
            type = type
        })
    else
        QBCore.Functions.Notify(message, type, 5000)
    end
end

CreateThread(function()
    if Config.ATMModels and #Config.ATMModels > 0 then
        exports.ox_target:addModel(Config.ATMModels, {
            {
                name = 'atm_robbery:start',
                icon = 'fas fa-laptop-code',
                label = 'Hack ATM',
                onSelect = function(data)
                    TriggerServerEvent('atm_robbery:start', GetEntityModel(data.entity))
                end,
                canInteract = function(entity, distance, data)
                    return hasHackingPhone()
                end
            }
        }, 2.5)
    end
end)

RegisterNetEvent('atm_robbery:startHacking')
AddEventHandler('atm_robbery:startHacking', function()
    local success = exports.ox_lib:skillCheck({'easy', 'easy', 'medium'}, {'w', 'a', 's', 'd'})
    local function ATMRobberyAlert()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        local streetHash, crossingRoadHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        local streetName = GetStreetNameFromHashKey(streetHash)
        
        local dispatchData = {
            message = ('atm_robbery_in_progress'),
            codeName = 'atmrobberyInProgress',
            code = '10-84',
            icon = 'fas fa-money-check-alt',
            priority = 2,
            coords = coords,
            street = streetName,
            jobs = { 'leo' }
        }
        
        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
    end
    
    exports('ATMRobberyAlert', ATMRobberyAlert)

    if success then
        TriggerEvent('atm_robbery:playAnimation')
        Wait(4000)
        TriggerServerEvent('atm_robbery:success')
        TriggerServerEvent('atm_robbery:removeHackingPhone')
        showNotification('ATM Robbery', 'You successfully hacked the ATM!', 'success')
    else
        showNotification('ATM Robbery', 'You failed the hacking mini-game!', 'error')
    end
end)

RegisterNetEvent('atm_robbery:playAnimation')
AddEventHandler('atm_robbery:playAnimation', function()
    local playerPed = PlayerPedId()

    FreezeEntityPosition(playerPed, true)
    local dict = 'anim@heists@ornate_bank@grab_cash'
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end

    TaskPlayAnim(playerPed, dict, 'grab', 8.0, -8.0, 4000, 1, 0, false, false, false)

    Wait(4000)
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
end)
