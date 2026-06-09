# frozen_string_literal: true

class AddSortingToLocationResources < ActiveRecord::Migration[8.1]
  def change
    add_column :location_resources, :sorting, :integer, default: 0
  end
end
