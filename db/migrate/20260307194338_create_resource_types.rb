# frozen_string_literal: true

class CreateResourceTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :resource_types do |t|
      t.string :key

      t.timestamps
    end
  end
end
