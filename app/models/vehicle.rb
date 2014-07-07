class Vehicle < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :location

  validates :datasf_object_id, :presence => true, :uniqueness => true
  validates :location, :presence => true
end
