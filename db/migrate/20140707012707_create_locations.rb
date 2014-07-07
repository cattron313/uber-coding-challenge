class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.decimal :lon, precision: 10, scale: 6
      t.decimal :lat, precision: 10, scale: 6
      t.text :description
      t.text :address
      t.references :vehicle, index: true

      t.timestamps
    end
  end
end
