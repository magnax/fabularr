# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.integer :starting_character_id
      t.integer :location_id
      t.integer :project_type_id
      t.integer :amount
      t.string :unit
      t.integer :duration, default: 0
      t.integer :elapsed, default: 0
      t.datetime :checked_at

      t.timestamps
    end
  end
end
