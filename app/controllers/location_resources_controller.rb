# frozen_string_literal: true

class LocationResourcesController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def new
    @location = Location.find_by(id: location_id)
    @project_type_id = ProjectType.find_by(key: 'discover_resource').id
  end

  private

  def location_id
    @location_id ||= params[:location_id] || params[:project][:location_id]
  end
end
