# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :current_character_set

  def index
    @recipes = Recipe.by_type([Recipe::ITEM, Recipe::BUILDING, Recipe::VEHICLE]).all
    @project_type_id = ProjectType.find_by(key: 'build')
  end
end
