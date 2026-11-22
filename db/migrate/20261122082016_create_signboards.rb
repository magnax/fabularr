# frozen_string_literal: true

class CreateSignboards < ActiveRecord::Migration[8.1]
  def change
    create_table :signboards do |t|
      t.references :location, foreign_key: true
      t.string :text
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
