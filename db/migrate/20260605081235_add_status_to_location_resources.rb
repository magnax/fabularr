# frozen_string_literal: true

class AddStatusToLocationResources < ActiveRecord::Migration[8.1]
  def change
    add_column :location_resources, :status, :boolean, default: false
  end
end
