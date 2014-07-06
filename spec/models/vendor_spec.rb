require 'rails_helper'

RSpec.describe Vendor, :type => :model do
  it "only allows creation of vendors with names" do
  	vendor = Vendor.new(name: "Al's BBQ")
  	vendor.vehicles << Vehicle.create!(datasf_object_id: 4)
  	vendor.save!
  	expect(vendor.name).to eq("Al's BBQ")

  	expect {Vendor.create! }.to raise_error
  end
end
