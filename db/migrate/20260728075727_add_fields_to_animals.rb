# frozen_string_literal: true

class AddFieldsToAnimals < ActiveRecord::Migration[8.1]
  def change
    change_table :animals, bulk: true do |t|
      t.integer :pack_size
      t.integer :armour
    end
  end
end
