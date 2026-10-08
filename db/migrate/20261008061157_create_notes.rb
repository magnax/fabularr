# frozen_string_literal: true

class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.references :character, foreign_key: true
      t.string :title
      t.string :body
      t.boolean :editable, default: true

      t.timestamps
    end
  end
end
