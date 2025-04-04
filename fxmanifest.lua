fx_version "cerulean"
lua54 "yes"
game "gta5"

author "heldernf"
description "Library for FiveM"

files {
    "imports/init.lua",
    "imports/**/shared.lua",
    "imports/**/client.lua",
}

shared_scripts {
    "core/global/shared.lua"
}

server_scripts {
    "core/**/server.lua"
}