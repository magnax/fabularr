# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :current_character_set
  before_action :check_travel, only: :examine

  def enter
    Locations::EnterLocationService.call(current_character, params[:location_id])

    redirect_to events_path
  end

  def examine
    render locals: Locations::ExamineShowService.call(current_character)
  end

  def name
    @location = Location.find(params[:location_id])
    @character = current_character
    @name = @location.location_name_or_build(current_character)
  end

  private

  def check_travel
    return if current_character.travelling? && stop?

    notice = stop? ? I18n.t('flash.notice.character_not_travelling') : I18n.t('flash.notice.character_not_standing')
    redirect_to events_path, notice: notice
  end

  def stop?
    @stop ||= current_character.traveller.speed.zero?
  end
end
