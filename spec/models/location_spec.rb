require 'rails_helper'

RSpec.describe Location, :type => :model do
  it "has to have a lat and log upon creation" do
  	Location.create!(lat: 42.2341, lon: 124.654312, description: "Oh! This is a random place.", address: "123 Seasame Street")

  	expect {Location.create!(lon: 124.654312, description: "Oh! This is a random place.", address: "123 Seasame Street")}.to raise_error
  	expect {Location.create!(lat: 124.654312, description: "Oh! This is a random place.", address: "123 Seasame Street")}.to raise_error
  end
end
