# frozen_string_literal: true

class CreateLocationClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :location_classes do |t|
      t.string :key
      t.boolean :moveable

      t.timestamps
    end
  end
end
