# frozen_string_literal: true

class AddMetadataToLocations < ActiveRecord::Migration[8.1]
  def change
    add_column :locations, :metadata, :jsonb
  end
end
