# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.text :body
      t.integer :location_id
      t.integer :character_id
      t.integer :receiver_character_id

      t.timestamps
    end
  end
end
