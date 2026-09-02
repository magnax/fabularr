# frozen_string_literal: true

class AddFieldsToCharacters < ActiveRecord::Migration[8.1]
  def change
    change_table :characters, bulk: true do |t|
      t.boolean :status, default: true
      t.integer :weight
    end
  end
end
