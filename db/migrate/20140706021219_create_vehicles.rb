class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :vehicle_type
      t.integer :datasf_object_id
      t.string :status
      t.references :vendor, index: true
      t.references :location, index: true

      t.timestamps
    end
    add_index :vehicles, :datasf_object_id, unique: true
  end
end
