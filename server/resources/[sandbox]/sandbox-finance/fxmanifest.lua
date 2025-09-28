fx_version("cerulean")
game("gta5")
lua54("yes")
client_script("@sandbox-base/exports/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")
server_script("@oxmysql/lib/MySQL.lua")

client_scripts({
	"client/**/*.lua",
})

server_scripts({
	"server/**/*.lua",
})

shared_scripts({
	"shared/**/*.lua",
})

ui_page("ui/dist/index.html")

files({ "ui/dist/index.html", "ui/dist/*.js", "ui/dist/*.png", "ui/dist/*.webp" })
