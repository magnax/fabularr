# frozen_string_literal: true

class AddSpeedToRecipeInstructions < ActiveRecord::Migration[8.1]
  def change
    add_column :recipe_instructions, :speed, :float
  end
end
