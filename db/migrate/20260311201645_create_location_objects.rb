# frozen_string_literal: true

class CreateLocationObjects < ActiveRecord::Migration[8.1]
  def change
    create_table :location_objects do |t|
      t.references :location, foreign_key: true
      t.integer :subject_id
      t.string :subject_type
      t.float :amount
      t.string :unit
      t.float :damage, default: 0

      t.timestamps
    end
  end
end
