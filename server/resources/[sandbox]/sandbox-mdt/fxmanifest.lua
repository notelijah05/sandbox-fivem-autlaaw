name("AuthenticRP RP MDT")
description("Mobile Data Terminal Written For AuthenticRP RP")
author("Dr Nick")
version("v1.0.0")
lua54("yes")
fx_version("cerulean")
game("gta5")
client_script("@sandbox-base/exports/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")
server_script("@oxmysql/lib/MySQL.lua")

client_scripts({
    "client/**/*.lua"
})

server_scripts({
    '@oxmysql/lib/MySQL.lua',
    "server/**/*.lua"
})

shared_scripts({
    "shared/*.lua",
})

ui_page("ui/dist/index.html")

files({ "ui/dist/index.html", "ui/dist/*.js" })
