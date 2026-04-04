# frozen_string_literal: true

class CreateLocationName < ActiveRecord::Migration[8.1]
  def change
    create_table :location_names do |t|
      t.references :character, foreign_key: true
      t.references :location, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
