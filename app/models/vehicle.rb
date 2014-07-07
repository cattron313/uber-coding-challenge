class Vehicle < ActiveRecord::Base
  belongs_to :vendor
  has_many :locations

  validates :datasf_object_id, :presence => true
  validates :locations, :presence => true
end
