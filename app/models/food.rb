class Food < ActiveRecord::Base
	has_and_belongs_to_many :vendors

	validates :name, :presence => true, :uniqueness => true

	def self.parse_string(str)
		if !str
			return []
		elsif str.downcase["everything"]
			return [] << "everything"
		else
			return str.split(":")
		end 
	end
end
