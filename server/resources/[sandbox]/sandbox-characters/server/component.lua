ONLINE_CHARACTERS = {}

AddEventHandler("Core:Shared:Ready", function()
	RegisterCallbacks()
	RegisterMiddleware()
	Startup()
	RegisterCommands()
	_spawnFuncs = {}
end)

exports("GetLastLocation", function(source)
	return _tempLastLocation[source] or false
end)

local TablesToDecode = {
	"Origin",
	"Apps",
	"Wardrobe",
	"Jobs",
	"Addiction",
	"PhoneSettings",
	"Crypto",
	"Licenses",
	"Alias",
	"PhonePermissions",
	"LaptopApps",
	"LaptopSettings",
	"LaptopPermissions",
	"Animations",
	"InventorySettings",
	"States",
	"MDTHistory",
	"MDTSuspension",
	"Qualifications",
	"LastClockOn",
	"Salary",
	"TimeClockedOn",
	"Reputations",
	"GangChain",
	"Jailed",
	"ICU",
	"Status",
	"Parole",
	"LSUNDGBan",
	"PhonePosition",
	-- Maybe more to be added 
}
