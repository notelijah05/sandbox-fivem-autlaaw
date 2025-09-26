fx_version("cerulean")
games({ "gta5" })
lua54("yes")
client_script("@sandbox-base/exports/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"client/**/*.lua",
})

server_scripts({
	"server/**/*.lua",
})

shared_scripts({
	"@ox_lib/init.lua",
	"shared/config.lua",
})

ui_page("ui/dist/index.html")

files({ "ui/dist/index.html", "ui/dist/*.png", "ui/dist/*.js" })
