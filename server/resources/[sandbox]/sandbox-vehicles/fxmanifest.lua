fx_version("cerulean")
games({ "gta5" })
lua54("yes")
client_script("@sandbox-base/exports/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	'@sandbox-polyzone/client.lua',
	'@sandbox-polyzone/BoxZone.lua',
	'@sandbox-polyzone/EntityZone.lua',
	"client/**/*.lua",
})

server_scripts({
	"server/**/*.lua",
})

shared_scripts({
	"shared/**/*.lua",
})
