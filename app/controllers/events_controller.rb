# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def index
    @character = current_character
    @location = @character.location
    @events = @location.events.includes(:character).newest
  end

  def create
    Events::CreateService.call!(event_params)

    redirect_to events_path
  end

  private

  def event_params
    params.permit(:body, :location_id, :character_id)
  end
end
