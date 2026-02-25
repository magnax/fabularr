# frozen_string_literal: true

class LocationResourcesController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def new
    @location = Location.find_by(id: params[:location_id])
  end
end
