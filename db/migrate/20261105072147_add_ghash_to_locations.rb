# frozen_string_literal: true

class AddGhashToLocations < ActiveRecord::Migration[8.1]
  def change
    add_column :locations, :ghash, :string
    add_index :locations, :ghash
  end
end
