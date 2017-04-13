Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope 'api' do

  	scope 'lender' do

  		post 'signup' => 'api_lender#signup'
  		post 'signin' => 'api_lender#signin'
  		post 'wifi' => 'api_lender#create_wifi'
  		get 'wifi' => 'api_lender#wifis'

  	end

  end

  scope 'lender' do

    get 'signin' => 'lender#signin' , as: 'lender_signin_page'
    post 'approve_signin' => 'lender#approve_signin' , as: 'lender_approve_signin'
    get 'dashboard' => 'lender#index' , as: 'lender_dashboard_index'

    get 'wifi_map' => 'lender#wifi_map' , as: 'lender_wifi_map'
    get 'wifi_detail' => 'lender#wifi_table' , as: 'lender_wifi_table'

    get 'block_wifi/:id' => 'lender#block_wifi' , as: 'lender_block_wifi'
    get 'unblock_wifi/:id' => 'lender#unblock_wifi' , as: 'lender_unblock_wifi'

    get 'connection' => 'lender#connection' , as: 'lender_connection'
    get 'earning' => 'lender#earning' , as: 'lender_earning'
    get 'datausage' => 'lender#datausage' , as: 'lender_datausage'
    
    get 'signout' => 'lender#signout' , as: 'lender_signout'

  end

end
