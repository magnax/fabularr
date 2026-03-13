# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def index
    @recipes = Recipe.all
  end
end
