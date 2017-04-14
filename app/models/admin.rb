class Admin < ApplicationRecord
	has_secure_password
	has_secure_token :password_reset_token

	##Validation
	validates_uniqueness_of :email
	validates :password , length: {within: 6..16} , on: :create
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
end
