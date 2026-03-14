# frozen_string_literal: true

class AddReadyToProject < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :ready, :boolean, default: false
  end
end
