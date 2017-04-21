json.earning do
	json.rating @rating
	json.download_data @download_data
	json.upload_data @upload_data
	json.connections @connection
	json.total_earnings @earn
	
	json.monthly_earning do
		json.array!(@earning) do |month, req|
			json.month month
			json.earning req.pluck(:total_bill).sum.round(2)
		end
	end
end