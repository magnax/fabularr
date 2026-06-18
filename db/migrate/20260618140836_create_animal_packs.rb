class CreateAnimalPacks < ActiveRecord::Migration[8.1]
  def change
    create_table :animal_packs do |t|
      t.references :location, foreign_key: true
      t.references :animal, foreign_key: true
      t.integer :amount
      t.integer :points

      t.timestamps
    end
  end
end
