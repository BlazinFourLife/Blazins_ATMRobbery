fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Blaze Scripts'
description 'ATM Robbery Script'
version '1.0.1'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qb-core',
    'ox_lib',
    'ps-dispatch'
}