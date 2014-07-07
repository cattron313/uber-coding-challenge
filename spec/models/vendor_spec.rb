require 'rails_helper'

RSpec.describe Vendor, :type => :model do
  it "only allows creation of vendors with names" do
  	vendor = Vendor.new(name: "Al's BBQ")
  	truck = Vehicle.new(datasf_object_id: 4)
  	truck.locations << Location.create!(lat: 1.5, lon: 4.7)
  	vendor.vehicles << truck
  	truck.save!
  	vendor.save!
  	expect(vendor.name).to eq("Al's BBQ")

  	expect {Vendor.create! }.to raise_error
  end
end
