Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope 'api' do

  	scope 'lender' do

  		post 'signup' => 'api_lender#signup'
  		post 'signin' => 'api_lender#signin'
  		post 'wifi' => 'api_lender#create_wifi'
  		get 'wifi' => 'api_lender#wifis'
      post 'bank_information' => 'api_lender#bank_information'
      post 'withdraw' => 'api_lender#withdraw'
      put 'password' => 'api_lender#update_password'
      get 'wallet' => 'api_lender#wallet'
      get 'earning' => 'api_lender#earning'
      get 'wifis/:id' => 'api_lender#wifi_earning'
      post 'forget_password' => 'api_lender#forget_password'
      post 'image' => 'api_lender#image'

  	end

    scope 'user' do

      post 'signup' => 'api_user#signup'
      post 'signin' => 'api_user#signin'
      put 'password' => 'api_user#update_password'
      post 'forget_password' => 'api_user#forget_password'

      get 'wifis' => 'api_user#nearby_wifis'
      post 'connect' => 'api_user#connect'
      post 'disconnect' => 'api_user#disconnect'
      post 'rate' => 'api_user#rate_wifi'

    end

  end

  scope 'user' do

    get 'reset_password/:token' => 'api_user#reset_password'
    put 'update_password' => 'api_user#update_password_for'

  end

  scope 'lender' do

    get 'signin' => 'lender#signin' , as: 'lender_signin_page'
    post 'approve_signin' => 'lender#approve_signin' , as: 'lender_approve_signin'
    get 'dashboard' => 'lender#index' , as: 'lender_dashboard_index'

    get 'wifi_map_:id' => 'lender#wifi_map' , as: 'lender_wifi_map'
    get 'wifi_detail' => 'lender#wifi_table' , as: 'lender_wifi_table'

    get 'block_wifi/:id' => 'lender#block_wifi' , as: 'lender_block_wifi'
    get 'unblock_wifi/:id' => 'lender#unblock_wifi' , as: 'lender_unblock_wifi'

    get 'connection' => 'lender#connection' , as: 'lender_connection'
    get 'earning' => 'lender#earning' , as: 'lender_earning'
    get 'datausage' => 'lender#datausage' , as: 'lender_datausage'
    
    get 'signout' => 'lender#signout' , as: 'lender_signout'
    post 'withdraw' => 'lender#withdraw_amount' , as: 'lender_withdraw'
    get 'withdraw' => 'lender#withdraw' , as: 'lender_withdraw_s'


    get 'reset_password/:token' => 'api_lender#reset_password'
    put 'update_password' => 'api_lender#update_password_for'

    get 'bank_information' => 'lender#bank_information' , as: 'lender_bank_info'
    patch 'bank_information' => 'lender#update_bank'
    post 'bank_information' => 'lender#add_bank'

  end


  scope 'admin' do

    get 'signin' => 'admin#signin' , as: 'admin_signin_page'
    post 'approve_signin' => 'admin#approve_signin' , as: 'admin_approve_signin'
    get 'signout' => 'admin#signout' , as: 'admin_signout'

    get 'dashboard' => 'admin#index'
    get 'wifi_detail' => 'admin#wifi_table'
    get 'wifi_map' => 'admin#wifi_map'
    get 'users' => 'admin#users'
     get 'lenders' => 'admin#lenders'
    get 'connections' => 'admin#connections'
    get 'earnings' => 'admin#payments'
    get 'block' => 'admin#block'
    get 'statistics' => 'admin#stats'
    get 'stripe' => 'admin#stripe_account_list'
    get 'withdraw_pending' => 'admin#withdraw_pending'
    get 'withdraw_transferred' => 'admin#withdraw_transferred'
    get 'defaulter' => 'admin#term_success_false'
    get 'stripe/refund/:ch_tok' => 'admin#stripe_account_refund' , as: 'refund_stripe'

    get 'defaulter/success/:id' => 'admin#term_success_mark_true' , as: 'successfully_terminated_true'

    get 'block_user/:id' => 'admin#block_user' , as: 'block_user'
    get 'unblock_user/:id' => 'admin#unblock_user' , as: 'unblock_user'

    get 'block_wifi/:id' => 'admin#block_wifi' , as: 'block_wifi'
    get 'unblock_wifi/:id' => 'admin#unblock_wifi' , as: 'unblock_wifi'

    post 'rest_pass/:id' => 'admin#reset_pass' , as: 'reset_password_admin'
    get 'withdraw/pending/:id' => 'admin#mark_withdraw_pending' , as: 'mark_withdraw_pending'

    get 'reports' => 'admin#reports'

    get 'destroy/:id' => 'admin#delete_user' , as: 'user_destroy'

    get 'wifis_:id' => 'admin#lender_wifis' , as: 'lender_wifis'

  end

end
