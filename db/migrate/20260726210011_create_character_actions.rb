# frozen_string_literal: true

class CreateCharacterActions < ActiveRecord::Migration[8.1]
  def change
    create_table :character_actions do |t|
      t.references :character, foreign_key: true
      t.references :subject, polymorphic: true
      t.string :key

      t.timestamps
    end
  end
end
