class Lender < ApplicationRecord
	has_secure_password
	has_secure_token :token
	has_secure_token :password_reset_token
	has_secure_token :email_verify_token

	before_create :generate_mobile_number_code

	##Validation
	validates_uniqueness_of :email
	validates_uniqueness_of :mobile_number
	validates :name , length: {within: 2..15}
	validates :password , length: {within: 6..16} , on: :create
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }

	has_many :wifis , dependent: :destroy
	has_many :withdraws , dependent: :destroy
	has_one :bank_information , dependent: :destroy


	private

	def generate_mobile_number_code
		begin
		  self.mobile_verify_token = rand(1000 .. 9999).to_s
		end while self.class.exists?(mobile_verify_token: mobile_verify_token)
	end

end
