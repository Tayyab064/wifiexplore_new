json.wifis(@wifi) do |wif|
	json.id wif.id
	json.name  wif.name
	json.ssid  wif.ssid
	json.address  wif.address
	json.latitude  wif.latitude
	json.longitude  wif.longitude
	json.security_type  wif.security_type
	json.price  wif.price
	json.avg_speed  wif.avg_speed
	json.connections wif.connections.count
	json.rating wif.rating
end