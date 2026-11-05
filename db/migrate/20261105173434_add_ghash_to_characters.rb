# frozen_string_literal: true

class AddGhashToCharacters < ActiveRecord::Migration[8.1]
  def change
    add_column :characters, :ghash, :string
    add_index :characters, :ghash
  end
end
