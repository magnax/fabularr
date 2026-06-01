# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :current_character_set

  def index
    render locals: Recipes::ShowService.call.merge(expanded: params[:expanded])
  end
end
