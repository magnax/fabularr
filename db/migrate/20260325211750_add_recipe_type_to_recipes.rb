# frozen_string_literal: true

class AddRecipeTypeToRecipes < ActiveRecord::Migration[8.1]
  def change
    add_column :recipes, :recipe_type, :string
  end
end
