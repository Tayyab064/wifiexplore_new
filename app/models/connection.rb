class Connection < ApplicationRecord
	belongs_to :wifi
	belongs_to :user

	has_one :rating , dependent: :destroy

	def calculate_bill
		self.total_bill = ((self.download_data * self.wifi.price)/100).round(2)
		self.save
	end
end
