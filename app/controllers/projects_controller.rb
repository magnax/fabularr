# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :current_character_set

  def new
    @project_info = Projects::ProjectInfoService.call(project_info_params)
  end

  def create
    Projects::CreateService.call(current_character, project_params)

    redirect_to events_path
  end

  def join
    Projects::JoinService.call(current_character, params[:project_id])

    redirect_to events_path
  end

  def leave
    Projects::LeaveService.call(current_character, params[:project_id])

    redirect_to events_path
  end

  private

  def project_params
    params.require(:project).permit(
      :project_type_id, :amount, :location_resource_id, :recipe_id
    )
  end

  def project_info_params
    params.permit(:location_resource_id, :type)
  end
end
