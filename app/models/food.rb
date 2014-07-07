class Food < ActiveRecord::Base
	has_and_belongs_to_many :vendors

	validates :name, :presence => true
end
