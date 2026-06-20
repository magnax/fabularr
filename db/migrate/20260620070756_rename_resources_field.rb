# frozen_string_literal: true

class RenameResourcesField < ActiveRecord::Migration[8.1]
  def change
    rename_column :resources, :base_speed_per_unit, :daily_rate
  end
end
