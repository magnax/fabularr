# frozen_string_literal: true

class CreateLocationResources < ActiveRecord::Migration[8.1]
  def change
    create_table :location_resources do |t|
      t.integer :location_id
      t.integer :resource_id
      t.integer :amount

      t.timestamps
    end
  end
end
