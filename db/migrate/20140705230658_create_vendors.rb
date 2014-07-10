class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.text :name
      t.text :food_description

      t.timestamps
    end
    add_index :vendors, :name, unique: true
  end
end
