class SendMobileVerifyTokenJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    user = args.first
    to = user.mobile_number

	account_sid = ENV['TW_SID']
	auth_token = ENV['TW_TOKEN']

	@twilio_client = Twilio::REST::Client.new account_sid, auth_token
	@twilio_client.account.sms.messages.create(
	:from => "+12019774712", #TODO: change this number
	:to => to,
	:body => "Your verification code is #{user.mobile_verify_token}."
	)

  end
end
