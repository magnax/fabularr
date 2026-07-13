# frozen_string_literal: true

class AddVirtualToItemType < ActiveRecord::Migration[8.1]
  def change
    add_column :item_types, :virtual, :boolean, default: false
  end
end
