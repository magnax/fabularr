class CreateInventoryObjects < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_objects do |t|
      t.references :character, foreign_key: true
      t.integer :subject_id
      t.string :subject_type
      t.float :amount
      t.string :unit

      t.timestamps
    end
  end
end
