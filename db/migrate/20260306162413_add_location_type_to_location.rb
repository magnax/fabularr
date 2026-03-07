# frozen_string_literal: true

class AddLocationTypeToLocation < ActiveRecord::Migration[8.1]
  def change
    rename_column :locations, :locationtype_id, :location_type_id
  end
end
