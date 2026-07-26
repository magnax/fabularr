# frozen_string_literal: true

class CreateAnimalResources < ActiveRecord::Migration[8.1]
  def change
    create_table :animal_resources do |t|
      t.references :animal, foreign_key: true
      t.references :resource, foreign_key: true
      t.integer :min_amount
      t.integer :max_amount
      t.string :key

      t.timestamps
    end
  end
end
