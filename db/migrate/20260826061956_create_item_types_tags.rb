# frozen_string_literal: true

class CreateItemTypesTags < ActiveRecord::Migration[8.1]
  def change
    create_table :item_types_tags do |t|
      t.references :item_type, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
