Config = {
    -- Set the inventory type: 'ox' for OX Inventory, 'qb' for QB Inventory
    InventoryType = 'qb',

        -- Set the notification system: '17mov_Hud', 'okokNotify', 'qb'
    NotificationSystem = '17mov_Hud',

    -- Set the required item for hacking the ATM
    RequiredItem = 'hacking_phone',

    -- Enable or disable detailed debug logs
    Debug = true,

    -- Set the minimum police required on duty
    MinPoliceOnDuty = 0,

    -- Cooldown time between ATM robberies (in seconds)
    CooldownTime = 300,  -- Default 5 minutes

    -- Set the police jobs that are considered for the minimum police on duty check
    PoliceJobs = {
        'police',
        'sheriff',
        'statepolice'
    },

    -- Set the reward range for the ATM robbery
    Reward = {
        min = 500,
        max = 1500
    },

    -- List of ATM models that can be hacked
    ATMModels = {
        -870868698,  -- ATM Model 1
        -1126237515, -- ATM Model 2
        506770882,   -- ATM Model 3
        -1364697528  -- ATM Model 4
    },

}
