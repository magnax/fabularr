# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :current_character_set

  def index
    render locals: Events::ShowService.call(current_character)
  end

  def create
    Events::CreateService.call(current_character, event_params)

    respond_to do |format|
      format.html do
        redirect_to asasevents_path
      end
      format.json do
        render json: {}
      end
    end
  end

  private

  def event_params
    params.require(:event).permit(:body, :receiver_character_id)
  end
end
