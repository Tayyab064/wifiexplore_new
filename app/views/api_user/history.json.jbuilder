json.history(@conn) do |coni|
	json.id coni.id
	json.download_data coni.download_data
	json.upload_data coni.upload_data
	json.total_bill coni.total_bill
	json.wifi_name coni.wifi.name
	json.wifi_address coni.wifi.address
	json.connected_at coni.created_at.strftime("%d-%m-%Y %H:%M")
end