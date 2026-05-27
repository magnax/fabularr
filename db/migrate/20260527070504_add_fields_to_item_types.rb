# frozen_string_literal: true

class AddFieldsToItemTypes < ActiveRecord::Migration[8.1]
  def change
    change_table :item_types, bulk: true do |t|
      t.integer :attack, default: 0
      t.integer :defense, default: 0
      t.integer :skill, default: 50
      t.integer :rot, default: 10
      t.integer :rot_use, default: 100
      t.integer :repair, default: 0
      t.boolean :visible, default: false
    end
  end
end
