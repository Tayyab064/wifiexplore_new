class ApiLenderController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :restrict_lender , except: [:signup , :signin]

	def signup
		em = params[:lender][:email].downcase
		@lender = Lender.new signup_params
		@lender.email = em
		if @lender.save
			render status: 201
		else
			@message = 'Error occured while signing up!'
			render status: 422
		end
	end

	def signin
		em = params[:lender][:email].downcase
		if @lender = Lender.find_by(email: em).try(:authenticate, params[:lender][:password] )
			@lender.regenerate_token
			render status: 200
		else
			@message = 'Invalid email/password'
			render status: 401
		end
	end

	def create_wifi
		@wifi = Wifi.new wifi_params
		@wifi.lender_id = @current_lender.id
		if @wifi.save
			render status: 201
		else
			@message = 'Error occured while creating wifi!'
			render status: 422
		end
	end

	def wifis
		@wifi = @current_lender.wifis
	end

	def bank_information
		if @current_lender.bank_information.present?
			@bank_information = @current_lender.bank_information
			@bank_information.update bank_params
		else
			@bank_information = BankInformation.new bank_params
			@bank_information.lender_id = @current_lender.id
			@bank_information.save
		end
	end

	private
	def signup_params
		params.require(:lender).permit(:name , :email , :mobile_number , :password)
	end

	def signin_params
		params.require(:lender).permit( :email , :password)
	end

	def wifi_params
		params.require(:wifi).permit( :latitude , :longitude , :name , :password , :ssid , :security_type , :price , :avg_speed)
	end

	def bank_params
		params.require(:lender).permit( :currency , :country , :name , :routing_number , :account_number)
	end
end
