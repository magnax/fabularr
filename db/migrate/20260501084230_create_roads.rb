# frozen_string_literal: true

class CreateRoads < ActiveRecord::Migration[8.1]
  def change
    create_table :roads do |t|
      t.references :location_1, foreign_key: { to_table: :locations }
      t.references :location_2, foreign_key: { to_table: :locations }
      t.string :road_type

      t.timestamps
    end
  end
end
