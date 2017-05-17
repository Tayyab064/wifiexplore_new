if @message.present?
	json.message @message
else
	json.user do
		json.name @user.name
		json.email @user.email
		json.mobile_number @user.mobile_number		
		json.email_verified @user.email_verified
		json.successfully_terminated @user.successfully_terminated
		json.blocked @user.blocked
		json.token @user.token
		json.image ''
	end
end