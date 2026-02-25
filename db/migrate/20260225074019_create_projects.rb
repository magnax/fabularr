class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.integer :starting_character_id
      t.integer :location_id
      t.integer :amount
      t.string :unit

      t.timestamps
    end
  end
end
