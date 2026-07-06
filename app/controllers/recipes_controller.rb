# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :current_character_set

  def index
    render locals: Recipes::ShowService.call.merge(expanded: params[:expanded])
  end

  def machine
    render locals: Recipes::MachineService.call(current_character, params[:id])
  rescue Recipes::MachineService::MachineInUseError
    render_error I18n.t('errors.projects.machine_in_use')
  end
end
