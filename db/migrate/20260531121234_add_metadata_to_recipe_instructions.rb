# frozen_string_literal: true

class AddMetadataToRecipeInstructions < ActiveRecord::Migration[8.1]
  def change
    add_column :recipe_instructions, :metadata, :jsonb
  end
end
