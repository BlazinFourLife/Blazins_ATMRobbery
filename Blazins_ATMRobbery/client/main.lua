local QBCore = exports['qb-core']:GetCoreObject()

-- Function to check if the player has the hacking phone
local function hasHackingPhone()
    local hasItem = false
    QBCore.Functions.TriggerCallback('atmrobbery:checkItem', function(result)
        hasItem = result
    end, Config.RequiredItem)
    Wait(200) -- Ensure we wait for the callback result
    return hasItem
end

-- Ensure ATM Models exist and add ox_target interactions
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
                    return hasHackingPhone() -- Only allow interaction if the player has the item
                end
            }
        }, 2.5) -- Distance parameter outside the table
    end
end)

-- Start hacking event
RegisterNetEvent('atm_robbery:startHacking')
AddEventHandler('atm_robbery:startHacking', function()
    local success = exports.ox_lib:skillCheck({'easy', 'easy', 'medium'}, {'w', 'a', 's', 'd'})

    if success then
        TriggerEvent('atm_robbery:playAnimation') -- Play animation
        Wait(4000) -- Freeze for 4 seconds
        TriggerServerEvent('atm_robbery:success') -- Give reward
        TriggerServerEvent('atm_robbery:removeHackingPhone') -- Remove item
    else
        TriggerEvent('QBCore:Notify', 'You failed the hacking mini-game!', 'error')
    end
end)

-- Play ATM Robbery Animation
RegisterNetEvent('atm_robbery:playAnimation')
AddEventHandler('atm_robbery:playAnimation', function()
    local playerPed = PlayerPedId()

    -- Freeze Player
    FreezeEntityPosition(playerPed, true)

    -- Load animation dictionary
    local dict = 'anim@heists@ornate_bank@grab_cash'
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end

    -- Play animation
    TaskPlayAnim(playerPed, dict, 'grab', 8.0, -8.0, 4000, 1, 0, false, false, false)

    -- Wait for animation to finish
    Wait(4000)

    -- Stop animation and unfreeze player
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
end)