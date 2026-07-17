# frozen_string_literal: true

class AddSkillToRecipe < ActiveRecord::Migration[8.1]
  def change
    add_reference :recipes, :skill, foreign_key: true
  end
end
