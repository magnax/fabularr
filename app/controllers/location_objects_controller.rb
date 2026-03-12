# frozen_string_literal: true

class LocationObjectsController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def take
    @character = current_character
    @location = @character.location
    @location_object = location_object
    @resource = location_object.subject
  end

  private

  def location_object
    @location_object ||= LocationObject.find_by(id: params[:location_object_id])
  end
end
