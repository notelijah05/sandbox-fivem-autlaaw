local hiddenRoute = 1
local globalRoute = 0
local routeId = 2

local _routes = {}

COMPONENTS.Routing = {
    _name = "base",
    GetPlayerRoute = function(self, source)
        local playerState = Player(source).state
        return {
            state = playerState["currentRoute"],
            oldRoute = playerState["oldRoute"],
            route = GetPlayerRoutingBucket(source)
        }
    end,
    AddPlayerToRoute = function(self, source, route, force)
        local playerState = Player(source).state
        if playerState["currentRoute"] == route and not force then
            exports['sandbox-base']:LoggerTrace("Routing",
                tostring(source) .. " is already routed to " .. tostring(route))
            return
        end
        local currentRoute = GetPlayerRoutingBucket(source)
        playerState["oldRoute"] = currentRoute
        SetPlayerRoutingBucket(source, route)
        playerState["currentRoute"] = route
        TriggerClientEvent("Routing:Client:NewRoute", source, route)
        exports['sandbox-base']:LoggerTrace("Routing",
            "Routed " .. tostring(source) .. " from " .. tostring(currentRoute) .. " to " .. tostring(route))

        local ped = GetPlayerPed(source)
        if ped then
            for k, v in ipairs(GetAllObjects()) do
                if DoesEntityExist(v) and GetEntityAttachedTo(v) == ped then
                    SetEntityRoutingBucket(v, route)
                end
            end
        end
    end,
    RoutePlayerToHiddenRoute = function(self, source)
        COMPONENTS.Routing:AddPlayerToRoute(source, hiddenRoute, true)
    end,
    RoutePlayerToGlobalRoute = function(self, source)
        COMPONENTS.Routing:AddPlayerToRoute(source, globalRoute, true)
    end,
    --Get or Create
    RequestRouteId = function(self, name, population)
        if _routes[name] then
            exports['sandbox-base']:LoggerTrace("Routing",
                "Returning Route " .. name .. " as " .. _routes[name])
            return _routes[name]
        end
        return COMPONENTS.Routing:CreateRouteId(name, population)
    end,
    --Explicit Create
    CreateRouteId = function(self, name, population)
        --This is a race condition I KNOW
        routeId = routeId + 1
        exports['sandbox-base']:LoggerTrace("Routing",
            "Creating new Route with name: " .. name .. " with id " .. tostring(routeId))
        _routes[name] = routeId
        SetRoutingBucketPopulationEnabled(routeId, population)
        return routeId
    end,
    --Explicit Get
    GetRouteId = function(self, name, population)
        if _routes[name] then
            exports['sandbox-base']:LoggerTrace("Routing",
                "Returning Route " .. name .. " as " .. tostring(_routes[name]))
            return _routes[name]
        end
        exports['sandbox-base']:LoggerError("Routing", "Getting non-existing Route with name " .. name)
    end,
    --Use sparingly since recreating will eventually cause integer overflow
    RemoveRouteId = function(self, name)
        if _routes[name] then
            _routes[name] = nil
            exports['sandbox-base']:LoggerWarn("Routing", "Removed Routing to " .. name)
            return
        end
        exports['sandbox-base']:LoggerError("Routing", "Attempting to remove invalid Route with name " .. name)
    end,
    MoveEntityToGlobalRoute = function(self, entityId)
        SetEntityRoutingBucket(entityId, globalRoute)
    end
}
