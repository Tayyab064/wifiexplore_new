class Wifi < ApplicationRecord
	belongs_to :lender
	validates_presence_of :avg_speed
	validates_presence_of :latitude
	validates_presence_of :latitude
	validates_presence_of :name
	validates_presence_of :password
	validates_presence_of :ssid
	validates_presence_of :security_type
	
	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode

	has_many :connections , dependent: :destroy
	has_many :reports , dependent: :destroy


	def rating
		rat = 0
		rat_coun = 0
		self.connections.each do |con|
			if con.rating.present?
				rat = rat + con.rating.rate
				rat_coun += 1
			end
		end
		if rat > 0 && rat_coun > 0
			rat = (rat / rat_coun).round
		end
		rat
	end
end