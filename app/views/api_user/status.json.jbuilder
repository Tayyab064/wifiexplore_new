json.user do
	json.total_bill @bill
	json.paid_bill @tra
	json.payable_bill (@bill-@tra)
	json.message @message
	json.transactions(@trans.order(created_at: 'DESC').limit(10)) do |transaction|
		json.id transaction.id
		json.amount transaction.amount
		json.time transaction.created_at.strftime("%d-%m-%Y %H:%M")
	end
end