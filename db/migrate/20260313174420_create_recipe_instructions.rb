# frozen_string_literal: true

class CreateRecipeInstructions < ActiveRecord::Migration[8.1]
  def change
    create_table :recipe_instructions do |t|
      t.references :recipe, foreign_key: true
      t.string :type
      t.integer :subject_id
      t.string :subject_type
      t.integer :amount
      t.string :unit

      t.timestamps
    end
  end
end
