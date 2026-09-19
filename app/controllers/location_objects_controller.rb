# frozen_string_literal: true

class LocationObjectsController < ApplicationController
  before_action :current_character_set

  def create
    LocationObjects::CreateService.call(current_character, location_object_params)

    redirect_to events_path
  end

  def take
    render locals: LocationObjects::ShowTakeService.call(
      current_character, params[:location_object_id]
    )
  rescue LocationObjects::InvalidObjectError
    render_error(I18n.t('errors.location_objects.invalid'))
  end

  def take_item
    InventoryObjects::CreateService.call(
      current_character, params.permit(:location_object_id)
    )

    redirect_to events_path
  end

  private

  def location_object_params
    params.require(:location_object).permit(:subject_id, :subject_type, :amount)
  end
end
