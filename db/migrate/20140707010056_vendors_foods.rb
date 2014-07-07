class VendorsFoods < ActiveRecord::Migration
  def change
  	create_table :foods_vendors, id: false do |t|
      t.references :vendor, index: true
      t.references :food, index: true

      t.timestamps
    end
  end
end
