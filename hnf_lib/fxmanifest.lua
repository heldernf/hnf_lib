fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'heldernf'
description 'Library for FiveM'
version 'b.1.0.0'

files {
    'locales/*.json',
    'imports/init.lua',
    'imports/**/shared.lua',
    'imports/**/client.lua',
}

shared_scripts {
    '@ox_lib/init.lua',

    'core/shared/setup.lua',
    'imports/**/helper/__shared.lua',
}

server_scripts {
    'imports/**/helper/__server.lua'
}

client_scripts {
    'imports/**/helper/__client.lua'
}

dependencies {
    'ox_lib'
}
