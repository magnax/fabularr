# frozen_string_literal: true

class RenameFieldInTravellers < ActiveRecord::Migration[8.1]
  def change
    reversible do |direction|
      direction.up do
        remove_column :travellers, :end_location_id
        add_reference :travellers, :road, foreign_key: true
      end

      direction.down do
        remove_column :travellers, :road_id
        add_reference :travellers, :end_location, foreign_key: { to_table: :locations }
      end
    end
  end
end
