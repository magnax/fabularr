# frozen_string_literal: true

class CreateResources < ActiveRecord::Migration[8.1]
  def change
    create_table :resources do |t|
      t.string :key

      t.timestamps
    end
  end
end
