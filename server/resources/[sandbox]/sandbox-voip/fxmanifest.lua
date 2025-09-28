game("gta5")
fx_version("cerulean")
client_script("@sandbox-base/exports/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

lua54("yes")

client_scripts({
	"client/**/*.lua",
})

server_scripts({
	"server/**/*.lua",
})

shared_scripts({
	"shared/**/*.lua",
})
