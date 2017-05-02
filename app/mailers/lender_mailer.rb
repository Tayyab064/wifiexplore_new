class LenderMailer < ApplicationMailer
	def reset_password(user)
		@user = user
    	@url  = 'https://wifiexplore.herokuapp.com'
    	mail(to: @user.email, subject: 'WifiExplore', body: 'Welcome again '+ @user.name + '. Please click on link to reset password: https://wifiexplore.herokuapp.com/lender/reset_password/'+ @user.password_reset_token )
	end
end
