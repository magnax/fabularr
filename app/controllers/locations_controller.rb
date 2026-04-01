# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :current_character_set

  def enter
    Locations::EnterLocationService.call(current_character, params[:location_id])

    redirect_to events_path
  end
end
