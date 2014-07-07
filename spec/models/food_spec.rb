require 'rails_helper'

RSpec.describe Food, :type => :model do
  it "only creates foods with names" do
  	hotdog = Food.create!(name: "Hot dog")
  	expect(hotdog.name).to eq("Hot dog")

  	expect { Food.create! }.to raise_error
  end
end
