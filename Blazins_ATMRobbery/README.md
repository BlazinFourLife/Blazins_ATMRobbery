
# ATM Robbery Script

This script allows players to rob ATMs in your server using the QB framework, QB Inventory, OX Inventory, OKOKNotify, and OX Lib for the progress bar and mini-game.

## Features

- Supports multiple ATM models
- Configurable inventory type (OX Inventory or QB Inventory)
- Requires a hacking phone to hack the ATM
- Configurable minimum police required on duty
- Notifies police using PS Dispatch
- Includes a hacking mini-game using OX Lib
- Configurable reward range for successful robberies

## Installation

1. Download and place the script in your `resources` folder.
2. Add the following to your `server.cfg`:

    ```plaintext
    ensure atm_robbery
    ```

3. Make sure you have the required dependencies installed:
    - `qb-core`
    - `ox_lib`
    - `ps-dispatch`

## Configuration

Edit the `config.lua` file to customize the script settings:

```lua
Config = {}

-- Set the inventory type: 'ox' for OX Inventory, 'qb' for QB Inventory
Config.InventoryType = 'ox'

-- Set the required item for hacking the ATM
Config.RequiredItem = 'hacking_phone'

-- Set the minimum police required on duty
Config.MinPoliceOnDuty = 2

-- Set the police jobs that are considered for the minimum police on duty check
Config.PoliceJobs = {
    'police',
    'sheriff',
    'statepolice'
}

-- Set the reward range for the ATM robbery
Config.Reward = {
    min = 500,
    max = 1500
}

-- Set the models of ATMs that the script will support
Config.ATMModels = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm
}

## Add to your ps-dipatch/config.lua
    ['atmrobberyInProgress'] = {
    radius = 0,
    sprite = 434,
    color = 1,
    scale = 1.5,
    length = 2,
    sound = 'Lose_1st',
    sound2 = 'GTAO_FM_Events_Soundset',
    offset = false,
    flash = false
    },
## Acknowledgments

Special thanks to Kingy for helping with the target development of this script.