class AddBaseSpeedToLocationTypes < ActiveRecord::Migration[8.1]
  def change
    add_column :location_types, :base_speed, :integer, null: true
  end
end
