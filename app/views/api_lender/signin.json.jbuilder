if @message.present?
	json.message @message
else
	json.lender do
		json.name @lender.name
		json.email @lender.email
		json.mobile_number @lender.mobile_number		
		json.email_verified @lender.email_verified
		json.mobile_number_verified @lender.mobile_number_verified
		json.blocked @lender.blocked
		json.token @lender.token
	end
end