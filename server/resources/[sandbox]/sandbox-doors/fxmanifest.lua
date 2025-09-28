fx_version("cerulean")
game("gta5")
lua54("yes")
client_script("@sandbox-base/exports/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"config.lua",
	"utils.lua",
	"client/*.lua",
})

server_scripts({
	"config.lua",
	"utils.lua",
	"server/*.lua",
})

shared_scripts({
	"shared/elevatorConfig.lua",
	"shared/doorConfig/**/*.lua",
})
