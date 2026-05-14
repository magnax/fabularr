# frozen_string_literal: true

class CreateMachineries < ActiveRecord::Migration[8.1]
  def change
    create_table :machineries do |t|
      t.string :key
      t.string :placement, array: true
      t.boolean :portable, default: false

      t.timestamps
    end
  end
end
