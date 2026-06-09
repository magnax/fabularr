# frozen_string_literal: true

class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :skills do |t|
      t.string :key

      t.timestamps
    end
  end
end
