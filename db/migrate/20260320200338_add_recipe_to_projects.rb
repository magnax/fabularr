# frozen_string_literal: true

class AddRecipeToProjects < ActiveRecord::Migration[8.1]
  def change
    add_reference :projects, :recipe, foreign_key: true, null: true
  end
end
