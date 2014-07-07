class Vendor < ActiveRecord::Base
	validates :name, :presence => true
	validates :vehicles, :presence => true

	has_many :vehicles
	has_and_belongs_to_many :foods
end
