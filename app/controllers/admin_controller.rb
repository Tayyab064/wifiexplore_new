class AdminController < ApplicationController
	skip_before_action :verify_authenticity_token , only: [:approve_signin]
	layout 'admin'
    before_action :is_admin, except: [:signin , :approve_signin]

    def signin
    	if session[:admin].present?
    		redirect_to '/admin/dashboard', notice: 'Already SignedIn!'
    	else
			render :layout => false
		end
	end

	def approve_signin
		if user = Admin.find_by(email: params[:email]).try(:authenticate, params[:password]) 
			session[:admin] = params[:email]
			redirect_to '/admin/dashboard' , notice: 'Successfully SignedIn!'
		else
			redirect_to :back , notice: 'Error: Check Email/Password'
		end
	end

	def index
		@wifis = Wifi.all
		@thisyear = Report.all.for_year.order(created_at: 'ASC').group_by(&:month)
		con = Connection.all
		@act_conn = con.where(disconnected_at: nil).count
		@non_act = con.count - @act_conn

		@earning = con.for_year.order(created_at: 'ASC').group_by(&:month)
		@withdraws = Withdraw.all.for_year.order(created_at: 'ASC').group_by(&:month)
	end

	def wifi_table
		@wifi = Wifi.all.order(updated_at: 'DESC')
	end

	def wifi_map
		@wifi = Wifi.all
	end

	def lenders
		@lender = Lender.all
	end

	def users
		@user = User.all.order(updated_at: 'DESC')
	end

	def connections
		@connection = Connection.all.order(updated_at: 'DESC')
		@total_earning = 0
		@download_data = 0
		@upload_data = 0
		@connection.each do |conn|
			@total_earning = @total_earning + conn.total_bill
			@download_data = @download_data + conn.download_data
			@upload_data = @upload_data + conn.upload_data
		end

		rat = Rating.all
		@star_1 = rat.where(rate: 1).count
		@star_2 = rat.where(rate: 2).count
		@star_3 = rat.where(rate: 3).count
		@star_4 = rat.where(rate: 4).count
		@star_5 = rat.where(rate: 5).count

		@connect_count = @connection.count
		@connect_connected = @connection.where(disconnected_at: nil).count
		@connect_disconnected = @connection.where.not(disconnected_at: nil).count
	end

	def payments
		@wifi = Wifi.all
		@wifi_earning = ''
		@wifi_conn = ''
		@total_earning = 0
		connection = Connection.all

		@wifi.order(updated_at: 'DESC').limit(50).each do |wif|
			
			temp_wifi_earning = ''
			wif.connections.each do |coni|
				if(temp_wifi_earning == '')
					temp_wifi_earning = ((coni.total_bill)/1000).round(2).to_s
				else
					temp_wifi_earning = temp_wifi_earning + ","+ ((coni.total_bill)/1000).round(2).to_s
				end
			end
			if(@wifi_earning == '' || @wifi_conn)
				@wifi_earning = temp_wifi_earning
				@wifi_conn = wif.connections.count.to_s
			else
				@wifi_earning = @wifi_earning + ","+ temp_wifi_earning
				@wifi_conn = @wifi_conn + "," + wif.connections.count.to_s
			end
		end

		wifiis = connection.order(created_at: 'DESC').pluck(:wifi_id)
		@recent_wifi = Wifi.where(id: wifiis).limit(10)

	end

	def redir_dash
		redirect_to dashboard_path
	end

	def block_user
		user = User.find(params[:id])
		user.update(blocked: true , token: nil)
		redirect_to :back
	end

	def unblock_user
		user = User.find(params[:id])
		user.update(blocked: false)
		redirect_to :back
	end

	def block_wifi
		wifi = Wifi.find(params[:id])
		wifi.update(blocked: true)
		redirect_to :back
	end

	def unblock_wifi
		wifi = Wifi.find(params[:id])
		wifi.update(blocked: false)
		redirect_to :back
	end

	def reset_pass
		p params
		if params[:password] == params[:c_password]
			user = User.find(params[:id])
			user.update(password: params[:password])
		end
		redirect_to :back
	end

	def block
		@user = User.all
		@user_block = User.where(blocked: true)
		@wifi = Wifi.all
		@wifi_block = Wifi.where(blocked: true)
	end

	def stats
		@connections = Connection.where.not(disconnected_at: nil).order(updated_at: 'DESC').limit(10)
		@wifis = []
		id_chk = []
		Connection.all.order(updated_at: 'DESC').each do |conn|
			if id_chk.include? conn.wifi_id

			else
				if id_chk.count < 30
					if conn.wifi.present?
						@wifis.push(conn.wifi)
					end
					id_chk.push(conn.wifi_id)
				else
					break
				end
			end
		end
	end

	def stripe_account_list
		#require "stripe"
		#Stripe.api_key = "sk_test_9VYi8WoB1EmZIrmrdNLgXR6U"

		@str =  Withdraw.where(transfered: false).order(created_at: 'DESC')
		@report = Withdraw.all.order(created_at: 'DESC')
		@thisyear = @report.for_year.order(created_at: 'ASC').group_by(&:month)
	end

	def stripe_account_refund
		require "stripe"
		Stripe.api_key = "sk_test_9VYi8WoB1EmZIrmrdNLgXR6U"

		re = Stripe::Refund.create(
		  charge: params[:ch_tok]
		)
		redirect_to :back
	end

	def term_success_false
		@user = User.where(successfully_terminated: false)
		@per = (@user.count/User.all.count)*100
	end

	def term_success_mark_true
		user = User.find(params[:id])
		user.update(successfully_terminated: true)
		redirect_to :back
	end

	def withdraw_pending
		@withdraw = Withdraw.where(transfered: false)
		@withdraws = @withdraw.for_year.order(created_at: 'ASC').group_by(&:month)
	end

	def withdraw_transferred
		@withdraw = Withdraw.where(transfered: true)
		@withdraws = @withdraw.for_year.order(created_at: 'ASC').group_by(&:month)
	end

	def mark_withdraw_pending
		c = Withdraw.find(params[:id])
		c.update(transfered: true)
		redirect_to :back
	end

	def delete_user
		user = User.find(params[:id])
		
		redirect_to :back
	end

	def signout
		session[:admin] = nil
		redirect_to '/admin/signin' , notice: 'Successfully SignedOut!'
	end

	def lender_wifis
		@wifis = Wifi.where(lender_id: params[:id])
	end

	def reports
		@report = Report.all.order(created_at: 'DESC')
		@thisyear = @report.for_year.order(created_at: 'ASC').group_by(&:month)
	end
end
