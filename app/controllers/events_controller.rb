# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :current_character_set

  def index
    @character = current_character
    @location = @character.location
    @events = Events::FetchEvents.call(@character)
    @items = {
      resources: @location.location_objects.resource,
      items: @location.location_objects.item
    }
    @location_resources = @location.location_resources
    @projects = @location.projects.pending.includes(:starting_character, :project_type)
  end

  def create
    Events::CreateService.call!(event_params)

    render json: {}, status: :no_content
  end

  private

  def event_params
    params.permit(:body, :location_id, :character_id, :receiver_character_id)
  end
end
