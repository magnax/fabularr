# frozen_string_literal: true

class AddParentItemTypeToItemType < ActiveRecord::Migration[8.1]
  def change
    add_reference :item_types, :parent_item_type, foreign_key: { to_table: 'item_types' }
  end
end
