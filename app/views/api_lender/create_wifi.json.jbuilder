if @message.present?
	json.message @message
	json.errors @wifi.errors
else
	json.wifi do
		json.name  @wifi.name
		json.ssid  @wifi.ssid
		json.password  @wifi.password
		json.address  @wifi.address
		json.latitude  @wifi.latitude
		json.longitude  @wifi.longitude
		json.security_type  @wifi.security_type
		json.price  @wifi.price
		json.avg_speed  @wifi.avg_speed
	end
end