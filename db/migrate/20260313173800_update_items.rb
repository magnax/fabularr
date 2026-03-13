# frozen_string_literal: true

class UpdateItems < ActiveRecord::Migration[8.1]
  def change
    rename_column :items, :itemtype_id, :item_type_id
    rename_column :items, :location_id, :placeable_id
    change_table :items, bulk: true do |t|
      t.column :placeable_type, :string
      t.column :damage, :float, default: 0
    end
  end
end
