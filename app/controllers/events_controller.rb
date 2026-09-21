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
        redirect_to events_path
      end
      format.json do
        render json: {}
      end
    end
  end

  def point
    Events::PointService.call(current_character, point_params)

    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(:body, :receiver_character_id)
  end

  def point_params
    params.permit(:id, :type)
  end
end
