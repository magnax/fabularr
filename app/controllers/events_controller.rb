# frozen_string_literal: true

class EventsController < ApplicationController
	before_action :signed_in_user
	before_action :current_character_set

  def index
  	@character = current_character
  	@location = @character.location
  end
end
