# frozen_string_literal: true

class AddFieldsToResources < ActiveRecord::Migration[8.1]
  def change
    change_table :resources, bulk: true do |t|
      t.references :skill, foreign_key: true
      t.integer :eaten, :integer
      t.integer :heal, default: 0
    end
  end
end
