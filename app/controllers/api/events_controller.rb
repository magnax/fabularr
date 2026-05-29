# frozen_string_literal: true

class Api::EventsController < ApplicationController
  before_action :current_character_set

  def show
    render json: {
      event: Events::ParseService.call(event, character).as_json
    }
  end

  def unread
    render json: Events::UnreadService.call(params[:user_id])
  end

  private

  def event
    @event ||= Event.find_by(id: params[:id])
  end

  def character
    @character = Character.find_by(id: params[:character_id])
  end
end
