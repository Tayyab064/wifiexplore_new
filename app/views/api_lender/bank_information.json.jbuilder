json.bank_information do
	json.currency  @bank_information.currency
	json.country  @bank_information.country
	json.bank_name  @bank_information.name
	json.routing_number  @bank_information.routing_number
	json.account_number  @bank_information.account_number
end