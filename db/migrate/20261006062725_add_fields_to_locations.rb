# frozen_string_literal: true

class AddFieldsToLocations < ActiveRecord::Migration[8.1]
  def change
    change_table :locations, bulk: true do |t|
      t.boolean :lakeshore, default: false
      t.boolean :seashore, default: false
    end
  end
end
