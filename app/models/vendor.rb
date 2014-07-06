class Vendor < ActiveRecord::Base
	validates :name, :presence => true
	validates :vehicles, :presence => true

	has_many :vehicles
end
