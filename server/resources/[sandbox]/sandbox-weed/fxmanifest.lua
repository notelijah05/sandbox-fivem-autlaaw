fx_version("cerulean")
client_script("@sandbox-base/exports/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

game("gta5")
lua54("yes")

client_scripts({
	"config/cl_*.lua",
	"client/**/*.lua",
})

shared_scripts({
	"config/sh_*.lua",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"config/sv_*.lua",
	"server/**/*.lua",
})
