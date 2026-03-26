# frozen_string_literal: true

class AddSpeedToWorkers < ActiveRecord::Migration[8.1]
  def change
    add_column :workers, :speed, :float, default: 1
  end
end
