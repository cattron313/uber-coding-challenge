require 'bigdecimal'
require 'bigdecimal/util'

class Location < ActiveRecord::Base
	validates :lat, presence: true
	validates :lon, presence: true

	has_many :vehicles

	def self.convert_lat_or_lon_to_d(str)
		#converting to radians
		return (str.to_d * Math::PI / 180).round(6) 
	end
end
