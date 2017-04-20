class LenderController < ApplicationController
	skip_before_action :verify_authenticity_token , only: [:approve_signin]
	layout 'lender'
    before_action :is_lender , except: [:signin , :approve_signin]

	def signin
		render :layout => false
	end

	def approve_signin
		p params
		if user = Lender.find_by(email: params[:email]).try(:authenticate, params[:password]) 
			if user.blocked == false
				session[:lender] = params[:email]
				redirect_to '/lender/dashboard' , notice: 'Successfully SignedIn!'
			else
				redirect_to :back , notice: 'Error: Dont have access to signin'
			end
		else
			redirect_to :back , notice: 'Error: Check Email/Password'
		end
	end

	def index
		@wifis = @lender.wifis
	end

	def wifi_map
		@wifi = @lender.wifis
	end

	def wifi_table
		@wifi = @lender.wifis
	end

	def block_wifi
		wifi = @lender.wifis.find(params[:id])
		wifi.update(blocked: true)
		redirect_to :back
	end

	def unblock_wifi
		wifi = @lender.wifis.find(params[:id])
		wifi.update(blocked: false)
		redirect_to :back
	end

	def connection
		@wifi = @lender.wifis

		conne = Connection.where(wifi_id: @wifi.pluck(:id))

		@connect_count = conne.count
		@connect_connected = conne.where(disconnected_at: nil).count
		@connect_disconnected = conne.where.not(disconnected_at: nil).count
	end

	def earning
		@wifi = @lender.wifis
		@wifi_earning = ''
		@wifi_conn = ''
		@total_earning = 0
		wifcon = 0
		
		@wifi.order(updated_at: 'DESC').each do |wif|
			
			temp_wifi_earning = ''
			wif.connections.each do |coni|
				wifcon += 1
				@total_earning = @total_earning + coni.total_bill
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
		@avg_con = ( wifcon / @wifi.count ).round
	end

	def datausage
		@wifis = @lender.wifis
		@connection = Connection.where(wifi_id: @wifis.pluck(:id))
	end

	def signout
		session[:lender] = nil
		redirect_to '/lender/signin' , notice: 'Successfully SignedOut!'
	end
end
