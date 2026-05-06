# frozen_string_literal: true

class AddItemClassToItem < ActiveRecord::Migration[8.1]
  def change
    add_reference :items, :item_class, foreign_key: true
  end
end
