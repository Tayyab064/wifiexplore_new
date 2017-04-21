json.wallet do
	tot_earn = 0
	tot_with = 0
	
	json.earning do
		json.array!(@earning) do |month, req|
			json.month month
			json.earning req.pluck(:total_bill).sum.round(2)
			tot_earn = tot_earn + req.pluck(:total_bill).sum.round(2)
		end
	end

	json.withdraw do
		json.array!(@withdraw) do |month, req|
			json.month month
			json.earning req.pluck(:amount).sum.round(2)
			tot_with = tot_with + req.pluck(:amount).sum.round(2)
		end
	end

	json.balance (tot_earn - tot_with)
end