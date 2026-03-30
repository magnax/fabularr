# frozen_string_literal: true

class EditLocationClassInLocations < ActiveRecord::Migration[8.1]
  def change
    remove_column :locations, :locationclass_id, :integer
    change_table :locations, bulk: true do |t|
      t.references :location_class, foreign_key: true
      t.integer :max_capacity
      t.integer :max_characters
    end
  end
end
