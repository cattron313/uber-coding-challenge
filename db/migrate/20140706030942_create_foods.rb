class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name

      t.timestamps
    end
    add_index :foods, :name, unique: true
  end
end
