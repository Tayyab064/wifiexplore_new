class Connection < ApplicationRecord
	belongs_to :wifi
	belongs_to :user

	has_one :rating , dependent: :destroy

	def calculate_bill
		self.total_bill = (((self.download_data + self.upload_data) * self.wifi.price)/100).round(2)
		self.save
	end

	scope :for_year, lambda {where("created_at >= ? and created_at <= ?", "#{Date.today.year}-01-01", "#{Date.today.year}-12-31")}

	def week
		self.created_at.strftime('%W')
	end

	def month
		self.created_at.strftime('%m')
	end

	def daily
		self.created_at.strftime('%d')
	end
end
