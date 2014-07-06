class Vehicle < ActiveRecord::Base
  belongs_to :vendor

  validates :datasf_object_id, :presence => true
end
