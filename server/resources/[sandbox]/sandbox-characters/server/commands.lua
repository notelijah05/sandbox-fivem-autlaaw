function RegisterCommands()
	exports["sandbox-chat"]:RegisterStaffCommand("logout", function(source, args, rawCommand)
		TriggerClientEvent("Characters:Client:Logout:Event", source)
	end, {
		help = "Logout",
	}, 0)
	exports["sandbox-chat"]:RegisterStaffCommand("logoutsid", function(source, args, rawCommand)
		local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
		if char ~= nil then
			TriggerClientEvent("Characters:Client:Logout:Event", char:GetData("Source"))
		end
	end, {
		help = "Force logs out another player by State ID",
		params = {
			{
				name = "Target",
				help = "State ID of who you want to force logout",
			},
		},
	}, 1)
	exports["sandbox-chat"]:RegisterStaffCommand("logoutsource", function(source, args, rawCommand)
		TriggerClientEvent("Characters:Client:Logout:Event", tonumber(args[1]))
	end, {
		help = "Force logs out another player by Source",
		params = {
			{
				name = "Target",
				help = "Source of who you want to force logout",
			},
		},
	}, 1)
	exports["sandbox-chat"]:RegisterAdminCommand("logoutall", function(source, args, rawCommand)
		for k, v in pairs(exports['sandbox-base']:FetchAll()) do
			TriggerClientEvent("Characters:Client:Logout:Event", v:GetData("Source"))
		end
	end, {
		help = "Force logs out all players",
	}, 0)

	exports["sandbox-chat"]:RegisterAdminCommand("addrep", function(source, args, rawCommand)
		local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
		if char ~= nil then
			Reputation.Modify:Add(char:GetData("Source"), args[2], tonumber(args[3]))
			exports["sandbox-chat"]:SendSystemSingle(
				source,
				string.format("%s Rep Added For %s To State ID %s", args[3], args[2], args[1])
			)
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Target")
		end
	end, {
		help = "Add Specified Reputation To Specified Player",
		params = {
			{
				name = "Target",
				help = "State ID of who you want to give the reputation to",
			},
			{
				name = "ID",
				help = "ID of the reputation you want to give",
			},
			{
				name = "Amount",
				help = "Amount of reputation to give",
			},
		},
	}, 3)

	exports["sandbox-chat"]:RegisterAdminCommand("remrep", function(source, args, rawCommand)
		local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
		if char ~= nil then
			Reputation.Modify:Remove(char:GetData("Source"), args[2], tonumber(args[3]))
			exports["sandbox-chat"]:SendSystemSingle(
				source,
				string.format("%s Rep Removed For %s From State ID %s", args[3], args[2], args[1])
			)
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Target")
		end
	end, {
		help = "Remove Specified Reputation To Specified Player",
		params = {
			{
				name = "Target",
				help = "State ID of who you want to remove the reputation from",
			},
			{
				name = "ID",
				help = "ID of the reputation you want to take",
			},
			{
				name = "Amount",
				help = "Amount of reputation to take",
			},
		},
	}, 3)

	exports["sandbox-chat"]:RegisterAdminCommand("getrep", function(source, args, rawCommand)
		local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
		if char ~= nil then
			local repLevel = Reputation:GetLevel(char:GetData("Source"), args[2])
			exports["sandbox-chat"]:SendSystemSingle(
				source,
				string.format("%s Rep Level For %s To State ID %s", repLevel, args[2], args[1])
			)
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Target")
		end
	end, {
		help = "Get Specified Reputation for Specified Player",
		params = {
			{
				name = "Target",
				help = "State ID of who you want to get the reputation of",
			},
			{
				name = "ID",
				help = "ID of the reputation you want to get",
			},
		},
	}, 2)

	exports["sandbox-chat"]:RegisterAdminCommand("phoneperm", function(source, args, rawCommand)
		local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
		local app, perm = args[2], args[3]

		if char ~= nil then
			local phonePermissions = char:GetData("PhonePermissions")
			if phonePermissions[app] then
				if phonePermissions[app][perm] ~= nil then
					if phonePermissions[app][perm] then
						phonePermissions[app][perm] = false
						exports["sandbox-chat"]:SendSystemSingle(source, "Disabled Permission")
					else
						phonePermissions[app][perm] = true
						exports["sandbox-chat"]:SendSystemSingle(source, "Enabled Permission")
					end

					char:SetData("PhonePermissions", phonePermissions)
				else
					exports["sandbox-chat"]:SendSystemSingle(source, "Permission Doesn't Exist")
				end
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "App Doesn't Exist")
			end
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Target")
		end
	end, {
		help = "Add Specified App Permission",
		params = {
			{
				name = "Target",
				help = "State ID",
			},
			{
				name = "App ID",
				help = "ID of the app",
			},
			{
				name = "Perm ID",
				help = "Permission",
			},
		},
	}, 3)

	exports["sandbox-chat"]:RegisterAdminCommand("laptopperm", function(source, args, rawCommand)
		local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
		local app, perm = args[2], args[3]

		if char ~= nil then
			local laptopPermissions = char:GetData("LaptopPermissions")
			if laptopPermissions[app] then
				if laptopPermissions[app][perm] ~= nil then
					if laptopPermissions[app][perm] then
						laptopPermissions[app][perm] = false
						exports["sandbox-chat"]:SendSystemSingle(source, "Disabled Permission")
					else
						laptopPermissions[app][perm] = true
						exports["sandbox-chat"]:SendSystemSingle(source, "Enabled Permission")
					end

					char:SetData("LaptopPermissions", laptopPermissions)
				else
					exports["sandbox-chat"]:SendSystemSingle(source, "Permission Doesn't Exist")
				end
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "App Doesn't Exist")
			end
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Target")
		end
	end, {
		help = "Add Specified App Permission",
		params = {
			{
				name = "Target",
				help = "State ID",
			},
			{
				name = "App ID",
				help = "ID of the app",
			},
			{
				name = "Perm ID",
				help = "Permission",
			},
		},
	}, 3)
end
