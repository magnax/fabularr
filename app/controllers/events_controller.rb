# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def index
    @character = current_character
    @location = @character.location
    @events = Events::FetchEvents.call!(@character)
    @items = @location.items
    @resources = @location.location_resources.includes(:resource)
    @projects = @location.projects.pending.includes(:starting_character, :project_type)
  end

  def create
    Events::CreateService.call!(event_params)

    # redirect_to events_path
    render json: {}, status: :no_content
  end

  private

  def event_params
    params.permit(:body, :location_id, :character_id, :receiver_character_id)
  end
end
