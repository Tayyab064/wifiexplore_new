class ApiUserController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :restrict_user , except: [:signup , :signin , :forget_password , :reset_password , :update_password_for]

	def signup
		em = params[:user][:email].downcase
		@user = User.new signup_params
		@user.email = em
		if @user.save
			render status: 201
		else
			@message = 'Error occured while signing up!'
			render status: 422
		end
	end

	def signin
		em = params[:user][:email].downcase
		if @user = User.find_by(email: em).try(:authenticate, params[:user][:password] )
			@user.regenerate_token
			render status: 200
		else
			@message = 'Invalid email/password'
			render status: 401
		end
	end

	def update_password
		if @current_user.try(:authenticate, params[:user][:old_password] )
			if c = @current_user.update(password: params[:user][:password])
				render json: {'message' => 'Password Updated' } , status: 200
			else
				render json: {'message' => c.errors } , status: 422
			end	
		else
			render json: {'message' => 'Invalid Password' } , status: 422
		end
	end

	def forget_password
		if len = User.find_by_email(params[:email])
			len.regenerate_password_reset_token
			UserMailer.reset_password(len).deliver_later
			render json: {'message' => 'Kindly check your email'} , status: 200
		else
			render json: {'message' => 'Invalid email address'} , status: 404
		end
	end

	def reset_password
		if token = User.find_by_password_reset_token(params[:token])
			addre = '/user_reset_password.html?token=' + params[:token]
			redirect_to addre
		else
			render json: {'message' => "Invalid forgot password token"}, status: :unauthorized
		end
	end

	def update_password_for
		if user = User.find_by_password_reset_token(params[:token])
			user.update(password: params[:password] , password_reset_token: nil)
			render json: {'message' => "Successfully Updated"}, status: 200
		else
			render json: {'message' => "Invalid forgot password token"}, status: :unauthorized
		end
	end

	def nearby_wifis
		if params[:latitude].present? && params[:longitude].present?
			@wifi = Wifi.where(blocked: false).near([params[:latitude], params[:longitude]], 2, :units => :km)
		else
			@message = 'Lat/Long missing'
			render status: 422
		end
	end

	def connect
		if Wifi.exists?(id: params[:wifi]) && (Wifi.find(params[:wifi]).blocked == false)
			if @current_user.successfully_terminated
				c = Connection.create(connected_at: Time.now , wifi_id: params[:wifi] , user_id: @current_user.id)
				@current_user.update(successfully_terminated: false)
				render json: {message: 'Enjoy Wifi' , connection_id: c.id } , status: 200
			else
				render json: {message: 'Clear previous bill' } , status: 422
			end
		else
			render json: {message: 'Cannot connect to that wifi' } , status: 422
		end
	end

	def disconnect
		if @current_user.connections.exists?(id: params[:connection_id]) && (conn = @current_user.connections.find(params[:connection_id]))
			conn.update(disconnected_at: Time.now , download_data: params[:download_data], upload_data: params[:upload_data])
			conn.calculate_bill
			@current_user.update(successfully_terminated: true)
			render json: {bill: conn.total_bill , time: ((conn.disconnected_at - conn.connected_at)/60).round } , status: 200
		else
			render json: {messsage: 'Invalid connection id'} , status: 422
		end
	end

	def rate_wifi
		if @current_user.connections.exists?(id: params[:connection_id]) && (conn = @current_user.connections.find(params[:connection_id]))
			if conn.disconnected_at.present? && conn.rating.nil?
				Rating.create(rate: params[:rate] , connection_id: conn.id)
				render json: {message: 'Successfully Rated'} , status: 200
			else
				render json: {message: 'Either you are still connected to wifi or you have already rated wifi'} , status: 422
			end
		else
			render json: {messsage: 'Invalid connection id'} , status: 422
		end
	end


	private
	def signup_params
		params.require(:user).permit(:name , :email , :mobile_number , :password)
	end
end
