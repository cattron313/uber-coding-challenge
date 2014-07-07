class Location < ActiveRecord::Base
	validates :lat, presence: true
	validates :lon, presence: true

	belongs_to :vehicle
end
