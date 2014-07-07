class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.decimal :lon, precision: 10, scale: 6
      t.decimal :lat, precision: 10, scale: 6
      t.text :description
      t.text :address

      t.timestamps
    end

    add_index :locations, [:lat, :lon], unique: true
  end
end
