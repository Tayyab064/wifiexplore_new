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

	def withdraw
		earning = Connection.where(wifi_id: @current_lender.wifis.pluck(:id)).pluck(:total_bill).sum
		withdraw = @current_lender.withdraws.pluck(:amount).sum
		max_with = earning - withdraw
		if params[:lender][:amount].to_i < max_with
			Withdraw.create(amount: params[:lender][:amount], lender_id: @current_lender.id)
			render json: {'message' => 'Successfully submitted'} , status: 200
		else
			message = 'Maximum withdraw amount is ' + max_with.to_s
			render json: {'message' => message } , status: 422
		end
	end

	def update_password
		if @current_lender.try(:authenticate, params[:lender][:old_password] )
			if c = @current_lender.update(password: params[:lender][:password])
				render json: {'message' => 'Password Updated' } , status: 200
			else
				render json: {'message' => c.errors } , status: 422
			end	
		else
			render json: {'message' => 'Invalid Password' } , status: 422
		end
	end

	def wallet
		@earning = Connection.where(wifi_id: @current_lender.wifis.pluck(:id)).for_year.order(created_at: 'ASC').group_by(&:month)
		@withdraw = @current_lender.withdraws.for_year.order(created_at: 'ASC').group_by(&:month)
	end

	def earning
		conn = Connection.where(wifi_id: @current_lender.wifis.pluck(:id))
		@earning = conn.for_year.order(created_at: 'ASC').group_by(&:month)
		@rating = 0
		@download_data = conn.pluck(:download_data).sum.round(2)
		@upload_data = conn.pluck(:upload_data).sum.round(2)
		@connection = conn.count
		@earn = conn.pluck(:total_bill).sum.round(2)
		rat = 0
		rat_coun = 0
		conn.each do |conni|
			if conni.rating.present?
				rat = rat + conni.rating.rate
				rat_coun += 1
			end
		end
		if rat > 0 && rat_coun > 0
			@rating = (rat / rat_coun).round
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

	def withdrawparams
		params.require(:lender).permit( :amount)
	end

end
