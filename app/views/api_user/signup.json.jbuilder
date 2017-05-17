if @message.present?
	json.message @message
	json.errors @user.errors
else
	json.user do
		json.name @user.name
		json.email @user.email
		json.mobile_number @user.mobile_number		
		json.email_verified @user.email_verified
		json.blocked @user.blocked
		json.token @user.token
		json.image ''
	end
end