# frozen_string_literal: true

class LocationResourcesController < ApplicationController
  before_action :current_character_set

  def new
    render locals: LocationResources::ShowDiscoverService.call(
      current_character
    )
  rescue LocationResources::InvalidLocationError
    render_error(I18n.t('errors.location_resources.invalid_location'))
  end
end
