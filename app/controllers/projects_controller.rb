# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :current_character_set

  def new
    render locals: Projects::ProjectInfoService.call(
      current_character, project_info_params
    ).merge(type: params[:type])
  end

  def create
    Projects::CreateService.call(current_character, project_params)

    redirect_to events_path
  rescue Projects::OnlyOutsideError
    render_error I18n.t('errors.projects.only_outside')
  end

  def show
    render locals: Projects::ShowService.call(current_character, params[:id])
  end

  def join
    Projects::JoinService.call(current_character, params[:project_id])

    redirect_to events_path
  end

  def leave
    Projects::LeaveService.call(current_character)

    redirect_to events_path
  end

  private

  def project_params
    params.require(:project).permit(
      :project_type_id, :amount, :repeat,
      :location_resource_id, :recipe_id, :location_id
    )
  end

  def project_info_params
    params.permit(:type, :location_id, :location_resource_id, :recipe_id)
  end
end
