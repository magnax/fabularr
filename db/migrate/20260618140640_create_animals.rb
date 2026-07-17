# frozen_string_literal: true

class CreateAnimals < ActiveRecord::Migration[8.1]
  def change
    create_table :animals do |t|
      t.string :key
      t.boolean :tamable, default: false
      t.boolean :mountable, default: false
      t.integer :attack
      t.integer :health
      t.integer :agression

      t.timestamps
    end
  end
end
