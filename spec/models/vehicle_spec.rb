require 'rails_helper'

RSpec.describe Vehicle, :type => :model do
  it "only allows creation of vendors with names" do
  	truck = Vehicle.create!(vehicle_type: "TRUCK", status: "APPROVED", datasf_object_id: 1)
  	expect(truck.vehicle_type).to eq("TRUCK")
  	expect(truck.status).to eq("APPROVED")
  	expect(truck.datasf_object_id).to eq(1)

  	expect {Vehicle.create!(vehicle_type: "TRUCK", status: "APPROVED")}.to raise_error
  end
end
