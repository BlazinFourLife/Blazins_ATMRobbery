fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Blaze Scripts'
description 'ATM Robbery Script'
version '1.0.1'

shared_scripts {
    'config.lua'  -- Ensure this path is correct
}

client_scripts {
    'client/main.lua'  -- Ensure this path is correct
}

server_scripts {
    'server/config.lua',  -- Ensure this path is correct
    'server/main.lua'
}

dependencies {
    'qb-core',
    'ox_lib',  -- Ensure ox_lib is listed as a dependency
   --'okokNotify',
    --'ps-dispatch'
}