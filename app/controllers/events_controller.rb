# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :current_character_set

  def index
    render locals: Events::ShowService.call(current_character)
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
