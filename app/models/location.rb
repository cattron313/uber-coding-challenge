class Location < ActiveRecord::Base
	validates :lat, presence: true
	validates :lon, presence: true

	has_many :vehicles
end
