# frozen_string_literal: true

class ShipActionsController < ApplicationController
  before_action :current_character_set

  def create
    ShipActions::CreateService.call(current_character, undock_params)

    redirect_to events_path
  rescue Locations::MustBeOnShipError
    render_error I18n.t('errors.locations.must_be_on_ship')
  rescue ShipActions::InvalidUndockDirectionError
    render_error I18n.t('errors.ship_actions.invalid_undock_direction')
  end

  private

  def undock_params
    params.require(:ship_action).permit(:direction)
  end

  def check_travel
    return if current_character.travelling? && stop?

    notice = stop? ? I18n.t('flash.notice.character_not_travelling') : I18n.t('flash.notice.character_not_standing')
    redirect_to events_path, notice: notice
  end

  def stop?
    @stop ||= current_character.traveller.speed.zero?
  end
end
