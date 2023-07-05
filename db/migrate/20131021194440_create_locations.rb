class CreateLocations < ActiveRecord::Migration[4.2]
  def change
    create_table :locations do |t|
      t.integer :locationtype_id
      t.integer :locationclass_id
      t.string :name
      t.integer :parent_location_id

      t.timestamps
    end
  end
end
