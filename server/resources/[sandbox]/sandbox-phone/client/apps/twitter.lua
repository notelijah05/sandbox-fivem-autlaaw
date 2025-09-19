RegisterNetEvent("Phone:Client:Twitter:Notify", function(tweet)
	SendNUIMessage({
		type = "RECEIVED_NEW_TWEET",
		data = tweet,
	})

	if Phone == nil then
		return
	end

	if tweet.source ~= GetPlayerServerId(PlayerId()) then
		Wait(1000)
		Phone.Notification:Add(tweet.author.name, tweet.content, tweet.time, 6000, "twitter", {
			view = "#",
		}, nil)
	end
end)

RegisterNetEvent("Phone:Client:Twitter:RemoveAccount", function(a)
	SendNUIMessage({
		type = "REMOVE_ACCOUNT_TWEETS",
		data = a,
	})
end)

RegisterNetEvent("Phone:Client:Twitter:ClearTweets", function()
	SendNUIMessage({
		type = "CLEAR_TWEETS",
	})
end)

RegisterNUICallback("Twitter:GetCount", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Phone:Twitter:GetCount", data, cb)
end)

RegisterNUICallback("Twitter:GetTweets", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Phone:Twitter:GetTweets", data, cb)
end)

RegisterNUICallback("SendTweet", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Phone:Twitter:CreateTweet", data, cb)
end)
