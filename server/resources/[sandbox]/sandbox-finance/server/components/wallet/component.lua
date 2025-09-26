exports("WalletGet", function(source)
	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	if char then
		return char:GetData("Cash") or 0
	end
	return 0
end)

exports("WalletHas", function(source, amount)
	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	if char and amount > 0 then
		local currentCash = char:GetData("Cash") or 0
		if currentCash >= amount then
			return true
		end
	end
	return false
end)

exports("WalletModify", function(source, amount, skipNotify)
	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	if char then
		local currentCash = char:GetData("Cash") or 0
		local newCashBalance = math.floor(currentCash + amount)
		if newCashBalance >= 0 then
			char:SetData("Cash", newCashBalance)

			if not skipNotify then
				if amount < 0 then
					exports['sandbox-hud']:NotifInfo(source,
						string.format("You Paid $%s In Cash", formatNumberToCurrency(math.floor(math.abs(amount))))
					)
				else
					exports['sandbox-hud']:NotifSuccess(source,
						string.format("You Received $%s In Cash", formatNumberToCurrency(math.floor(amount)))
					)
				end
			end
			return newCashBalance
		end
	end
	return false
end)
