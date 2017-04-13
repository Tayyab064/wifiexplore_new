class LenderController < ApplicationController
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
		@wifis = @lender.wifis.all
		@connections = 0
		@total_earning = 0
		@download_data = 0
		@upload_data = 0
		@connected_user = 0
		@wifis.each do |wif|
			@connected_user = @connected_user + wif.connections.where(disconnected_at: nil).count
			wif.connections.each do |conn|
				@connections = @connections + 1
				@total_earning = @total_earning + conn.total_bill
				@download_data = @download_data + conn.download_data
				@upload_data = @upload_data + conn.upload_data
			end
		end
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
		@total_earning = 0
		@download_data = 0
		@upload_data = 0
		Connection.where(wifi_id: @wifi.pluck(:id)).order(updated_at: 'DESC').limit(50).each do |conn|
			@total_earning = @total_earning + conn.total_bill
			@download_data = @download_data + conn.download_data
			@upload_data = @upload_data + conn.upload_data
		end
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
