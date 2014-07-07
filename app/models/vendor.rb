class Vendor < ActiveRecord::Base
	validates :name, :presence => true, :uniqueness => true
	validates :vehicles, :presence => true

	has_many :vehicles, dependent: :destroy
	has_and_belongs_to_many :foods
end
