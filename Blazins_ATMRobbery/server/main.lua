local QBCore = exports['qb-core']:GetCoreObject()
local cooldowns = {}

local function debugLog(message)
    if Config.Debug then
        print('[ATM Robbery Debug] ' .. message)
    end
end

-- Function to show notifications based on the configured system
local function showNotification(source, title, message, type)
    if Config.NotificationSystem == 'okokNotify' then
        TriggerClientEvent('okokNotify:Alert', source, title, message, 5000, type, true)
    else
        QBCore.Functions.Notify(message, type, 5000)
    end
end

RegisterNetEvent('atm_robbery:start')
AddEventHandler('atm_robbery:start', function(atmModel)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return debugLog('Player not found') end

    local playerId = player.PlayerData.citizenid
    local currentTime = os.time()

    -- Check for cooldown
    if cooldowns[playerId] and currentTime < cooldowns[playerId] then
        local remainingTime = cooldowns[playerId] - currentTime
        debugLog('Player is on cooldown for ' .. remainingTime .. ' seconds')
        showNotification(src, 'Cooldown', 'You must wait ' .. remainingTime .. ' seconds before robbing another ATM!', 'error')
        return
    end

    -- Validate ATM model
    local isValidATM = false
    for _, model in ipairs(Config.ATMModels) do
        if model == atmModel then
            isValidATM = true
            break
        end
    end
    
    if not isValidATM then
        debugLog('Invalid ATM model: ' .. atmModel)
        showNotification(src, 'Error', 'This ATM cannot be hacked!', 'error')
        return
    end

    -- Check for minimum police on duty
    local policeCount = 0
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local officer = QBCore.Functions.GetPlayer(playerId)
        if officer and Config.PoliceJobs[officer.PlayerData.job.name] and officer.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end

    if policeCount < Config.MinPoliceOnDuty then
        showNotification(src, 'Error', 'Not enough police on duty!', 'error')
        return
    end

    -- Notify police using PS Dispatch
    TriggerEvent('ps-dispatch:client:atmRobbery', player.PlayerData.coords)

    -- Check for required hacking item
    if Config.InventoryType == 'qb' and not player.Functions.HasItem(Config.RequiredItem) then
        showNotification(src, 'Error', 'You need a hacking phone to hack the ATM!', 'error')
        return
    elseif Config.InventoryType == 'ox' and not exports.ox_inventory:Search(src, 'count', Config.RequiredItem) then
        showNotification(src, 'Error', 'You need a hacking phone to hack the ATM!', 'error')
        return
    end

    -- Start hacking mini-game
    TriggerClientEvent('atm_robbery:startHacking', src)
end)

RegisterNetEvent('atm_robbery:success')
AddEventHandler('atm_robbery:success', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end

    local reward = math.random(Config.Reward.min, Config.Reward.max)
    player.Functions.AddMoney('cash', reward)
    showNotification(src, 'ATM Robbery', 'You successfully hacked the ATM and got $' .. reward .. '!', 'success')

    -- Set cooldown
    cooldowns[player.PlayerData.citizenid] = os.time() + Config.CooldownTime
end)

-- Callback to check if the player has the required item
QBCore.Functions.CreateCallback('atmrobbery:checkItem', function(source, cb, itemName)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local hasItem = Player.Functions.GetItemByName(itemName)
        cb(hasItem ~= nil)
    else
        cb(false)
    end
end)

-- Remove hacking phone after successful hack
RegisterNetEvent('atm_robbery:removeHackingPhone')
AddEventHandler('atm_robbery:removeHackingPhone', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        if Player.Functions.RemoveItem("hacking_phone", 1) then
            showNotification(src, 'Success', 'You used 1 hacking phone!', 'success')
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["hacking_phone"], "remove")
        else
            showNotification(src, 'Error', 'You do not have a hacking phone!', 'error')
        end
    end
end)