# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :current_character_set

  def enter
    current_character.update!(location: location)

    redirect_to events_path
  end

  private

  def location
    @location ||= Location.find_by(id: params[:location_id])
  end
end
