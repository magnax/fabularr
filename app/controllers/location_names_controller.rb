# frozen_string_literal: true

class LocationNamesController < ApplicationController
  def create
    LocationNames::UpsertService.call(current_character, location_name_params)

    redirect_to events_path
  end

  private

  def location_name_params
    params.require(:location_name).permit(:character_id, :location_id, :name)
  end
end
