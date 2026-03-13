# frozen_string_literal: true

class LocationObjectsController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def create
    LocationObjects::CreateService.call(current_character, location_object_params)

    redirect_to events_path
  end

  def take
    @character = current_character
    @location = @character.location
    @location_object = location_object
    @resource = location_object.subject
  end

  private

  def location_object_params
    params.require(:location_object).permit(:subject_id, :subject_type, :amount)
  end

  def location_object
    @location_object ||= LocationObject.find_by(id: params[:location_object_id])
  end
end
