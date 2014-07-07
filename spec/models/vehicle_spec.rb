require 'rails_helper'

RSpec.describe Vehicle, :type => :model do
  it "only allows creation of vendors with names" do
  	truck = Vehicle.new(vehicle_type: "TRUCK", status: "APPROVED", datasf_object_id: 1)
  	truck.locations << Location.create!(lon: 3.4543, lat: 45.35435)
  	truck.save!
  	expect(truck.vehicle_type).to eq("TRUCK")
  	expect(truck.status).to eq("APPROVED")
  	expect(truck.datasf_object_id).to eq(1)

  	expect {Vehicle.create!(vehicle_type: "TRUCK", status: "APPROVED", datasf_object_id: 9)}.to raise_error
  	expect {
  		t = Vehicle.new(vehicle_type: "TRUCK", status: "APPROVED").locations << Location.create!(lon: 3.4543, lat: 45.35435)
  		t.save!
  	}.to raise_error
  end
end
