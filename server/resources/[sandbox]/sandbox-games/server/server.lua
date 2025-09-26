local _uircd = {}

AddEventHandler("Core:Shared:Ready", function()
	RegisterChatCommands()
end)

function RegisterChatCommands()
	-- exports["sandbox-chat"]:RegisterAdminCommand("notif", function(source, args, rawCommand)
	-- 	exports['sandbox-hud']:NotifSuccess(source, "This is a test, lul")
	-- end, {
	-- 	help = "Test Notification",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("list", function(source, args, rawCommand)
	-- 	TriggerClientEvent("ListMenu:Client:Test", source)
	-- end, {
	-- 	help = "Test List Menu",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("input", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Input:Client:Test", source)
	-- end, {
	-- 	help = "Test Input",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("confirm", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Confirm:Client:Test", source)
	-- end, {
	-- 	help = "Test Confirm Dialog",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("skill", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Skillbar", source)
	-- end, {
	-- 	help = "Test Skill Bar",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("scan", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Scanner", source)
	-- end, {
	-- 	help = "Test Scanner",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("sequencer", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Sequencer", source)
	-- end, {
	-- 	help = "Test Sequencer",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("keypad", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Keypad", source)
	-- end, {
	-- 	help = "Test Keypad",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("scrambler", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Scrambler", source)
	-- end, {
	-- 	help = "Test Scrambler",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("memory", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Memory", source)
	-- end, {
	-- 	help = "Test Memory",
	-- })
end
