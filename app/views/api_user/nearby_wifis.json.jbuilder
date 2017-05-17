if @message.present?
	json.message @message
else

	json.wifis(@wifi) do |wif|
		json.id wif.id
		json.name  wif.name
		json.ssid  wif.ssid
		json.address  wif.address
		json.password wif.password
		json.latitude  wif.latitude
		json.longitude  wif.longitude
		json.security_type  wif.security_type
		json.price  wif.price
		json.avg_speed  wif.avg_speed
		json.connections wif.connections.count
		c = wif.connections.pluck(:download_data).sum + wif.connections.pluck(:upload_data).sum
		json.data_usage (c/1024).round
		json.rating wif.rating
		json.lender_name wif.lender.name
	end

end