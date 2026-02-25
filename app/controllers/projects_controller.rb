# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def create
    Projects::CreateService.call(current_character, project_params)

    redirect_to events_path
  end

  private

  def project_params
    params.require(:project).permit(:location_id, :project_type)
  end
end
