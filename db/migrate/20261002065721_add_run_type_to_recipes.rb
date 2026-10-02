# frozen_string_literal: true

class AddRunTypeToRecipes < ActiveRecord::Migration[8.1]
  def change
    add_column :recipes, :run_type, :string, default: 'manual'
  end
end
