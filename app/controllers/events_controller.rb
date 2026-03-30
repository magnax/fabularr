# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :current_character_set

  def index
    @character = current_character
    @location = @character.location
    @events = Events::FetchEvents.call(@character)
    @items = {
      resources: @location.location_objects.includes(:subject).resource,
      items: @location.location_objects.item
    }
    @location_resources = @location.location_resources
    @projects = @location.projects.pending.includes(:starting_character, :project_type)
  end

  def create
    Events::CreateService.call(current_character, event_params)

    if params[:event][:reload]
      redirect_to events_path
    else
      render json: {}, status: :no_content
    end
  end

  private

  def event_params
    params.require(:event).permit(:body, :receiver_character_id)
  end
end
