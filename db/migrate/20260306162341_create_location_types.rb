# frozen_string_literal: true

class CreateLocationTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :location_types do |t|
      t.string :key

      t.timestamps
    end
  end
end
