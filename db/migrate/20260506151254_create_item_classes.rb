# frozen_string_literal: true

class CreateItemClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :item_classes do |t|
      t.string :key
      t.jsonb :metadata

      t.timestamps
    end
  end
end
