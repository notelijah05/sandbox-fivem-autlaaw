BED_LIMIT = #Config.Beds
_inBed = {}
_inBedChar = {}

local _medsForSale = {
	{ item = "firstaid", coin = "MALD", price = 20,  qty = -1, vpn = false, requireCurrency = false },
	{ item = "ifak",     coin = "MALD", price = 100, qty = -1, vpn = false, requireCurrency = true },
}


AddEventHandler("Damage:Shared:DependencyUpdate", HospitalComponents)
function HospitalComponents()
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	Billing = exports["sandbox-base"]:FetchComponent("Billing")
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Handcuffs = exports["sandbox-base"]:FetchComponent("Handcuffs")
	Ped = exports["sandbox-base"]:FetchComponent("Ped")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
	Banking = exports["sandbox-base"]:FetchComponent("Banking")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hospital", {
		"Damage",
		"Hospital",
		"Crypto",
		"Billing",
		"Labor",
		"Jobs",
		"Handcuffs",
		"Ped",
		"Pwnzor",
		"Banking",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		HospitalComponents()
		HospitalCallbacks()
		HospitalMiddleware()

		GlobalState["HiddenHospital"] = {
			coords = vector3(2810.023, 5977.588, 349.919),
			heading = 146.641,
		}

		exports['sandbox-pedinteraction']:VendorCreate("BlackmarketMeds", "ped", "Medical Supplies", `S_M_M_Paramedic_01`,
			{
				coords = vector3(2815.044, 5980.179, 349.928),
				heading = 277.889,
				scenario = "WORLD_HUMAN_CLIPBOARD",
			}, _medsForSale, "pump-medical", "View Supplies", false, false, true)

		exports["sandbox-chat"]:RegisterAdminCommand("clearbeds", function(source, args, rawCommand)
			_inBed = {}
		end, {
			help = "Force Clear All Hospital Beds",
			params = {},
		}, -1)
	end)
end)

HOSPITAL = {
	RequestBed = function(self, source)
		--return math.random(#Config.Beds)
		for k, v in ipairs(Config.Beds) do
			if _inBed[k] == nil then
				return k
			end
		end
		return nil
	end,
	FindBed = function(self, source, location)
		for k, v in ipairs(Config.Beds) do
			if (#(vector3(v.x, v.y, v.z) - vector3(location.x, location.y, location.z)) <= 2.0) and not _inBed[k] then
				return k
			end
		end
		return nil
	end,
	OccupyBed = function(self, source, bedId)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char and Config.Beds[bedId] ~= nil then
			if _inBed[bedId] == nil then
				_inBedChar[char:GetData("ID")] = bedId
				_inBed[bedId] = char:GetData("ID")
				return true
			else
				return false
			end
		else
			return false
		end
	end,
	LeaveBed = function(self, source)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			local inBedId = _inBedChar[char:GetData("ID")]
			if inBedId ~= nil then
				_inBed[inBedId] = nil
				_inBedChar[char:GetData("ID")] = nil
				return true
			end
		end
		return false
	end,
	ICU = {
		Send = function(self, target)
			local char = exports['sandbox-characters']:FetchCharacterSource(target)
			if char ~= nil then
				if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
					return false
				end

				Labor.Jail:Sentenced(target)

				Player(target).state.ICU = true
				char:SetData("ICU", {
					Released = false,
				})

				CreateThread(function()
					Jobs.Duty:Off(target, Player(target).state.onDuty)
					Handcuffs:UncuffTarget(-1, target)
					Ped.Mask:UnequipNoItem(target)
					exports['sandbox-inventory']:HoldingPut(target)
				end)

				Pwnzor.Players:TempPosIgnore(target)
				TriggerClientEvent("Hospital:Client:ICU:Sent", target)
				TriggerClientEvent("Hospital:Client:ICU:Enter", target)
				exports['sandbox-base']:ExecuteClient(target, "Notification", "Info", "You Were Admitted To ICU")
			else
				return false
			end
		end,
		Release = function(self, target)
			local char = exports['sandbox-characters']:FetchCharacterSource(target)
			if char ~= nil then
				Player(target).state.ICU = false
				char:SetData("ICU", {
					Released = true,
					Items = false,
				})
				exports['sandbox-base']:ExecuteClient(target, "Notification", "Info", "You Were Released From ICU")
			else
				return false
			end
		end,
		GetItems = function(self, target)
			local char = exports['sandbox-characters']:FetchCharacterSource(target)
			if char ~= nil then
				Player(target).state.ICU = false
				char:SetData("ICU", {
					Released = true,
					Items = true,
				})
				exports['sandbox-inventory']:HoldingTake(target)
			else
				return false
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Hospital", HOSPITAL)
end)
