# frozen_string_literal: true

class AddResourceTypeToResource < ActiveRecord::Migration[8.1]
  def change
    change_table :resources, bulk: true do |t|
      t.column :resource_type_id, :integer, array: true
      t.column :material, :boolean, default: true
      t.column :unit, :string, default: 'grams'
    end
  end
end
