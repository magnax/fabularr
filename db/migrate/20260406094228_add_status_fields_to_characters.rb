# frozen_string_literal: true

class AddStatusFieldsToCharacters < ActiveRecord::Migration[8.1]
  def change
    change_table :characters, bulk: true do |t|
      t.float :damage, default: 0
      t.float :hunger, default: 0
      t.float :tiredness, default: 0
    end
  end
end
