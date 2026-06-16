# frozen_string_literal: true

class CreateCharacterSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :character_skills do |t|
      t.references :character, foreign_key: true
      t.references :skill, foreign_key: true
      t.float :level
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
