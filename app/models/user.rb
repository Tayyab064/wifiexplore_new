class User < ApplicationRecord
	has_secure_password
	has_secure_token :token
	has_secure_token :password_reset_token
	has_secure_token :email_verify_token

	##Validation
	validates_uniqueness_of :email
	validates_uniqueness_of :mobile_number
	validates :name , length: {within: 2..15}
	validates :password , length: {within: 6..16} , on: :create
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }

	has_many :connections , dependent: :destroy
end
