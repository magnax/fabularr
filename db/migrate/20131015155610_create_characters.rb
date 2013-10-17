class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.string :gender
      t.integer :location_id
      t.integer :spawn_location_id
      t.integer :user_id

      t.timestamps
    end
  end
end
