RegisterNUICallback("Loans:GetData", function(data, cb)
	exports["sandbox-base"]:ServerCallback('Loans:GetLoans', {}, function(characterLoansData)
		cb(characterLoansData)
	end)
end)

RegisterNUICallback("Loans:Payment", function(data, cb)
	exports["sandbox-base"]:ServerCallback('Loans:Payment', data, function(res, updatedCharacterLoansData)
		if res and res.success and updatedCharacterLoansData then
			Phone.Data:Set('bankLoans', updatedCharacterLoansData)
		end

		cb(res)
	end)
end)
