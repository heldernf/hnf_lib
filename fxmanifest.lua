fx_version "cerulean"
lua54 "yes"
game "gta5"

author "heldernf"
description "Library for FiveM"

shared_scripts {
    "imports/main.lua",
    "imports/**/shared.lua",
    "main/init.lua",
}

server_scripts {
    "imports/**/server.lua",
}

client_scripts {
    "imports/**/client.lua",
}