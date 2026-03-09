# frozen_string_literal: true

class Api::EventsController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def show
    render json: {
      event: Events::ParseService.call(event, character, parsed: true).as_json
    }
  end

  private

  def event
    @event ||= Event.find_by(id: params[:id])
  end

  def character
    @character = Character.find_by(id: params[:character_id])
  end
end
