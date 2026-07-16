# frozen_string_literal: true

class AddItemClassIdToItemTypes < ActiveRecord::Migration[8.1]
  def change
    add_reference :item_types, :item_class, foreign_key: true
  end
end
