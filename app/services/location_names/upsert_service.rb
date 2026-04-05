# frozen_string_literal: true

module LocationNames
  class UpsertService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      if @params[:name].blank? && location_name.persisted?
        location_name.destroy
      else
        location_name.update!(name: @params[:name])
      end
    end

    private

    def location_name
      @location_name ||= location.location_name_or_build(@character)
    end

    def location
      @location ||= Location.find_by(id: @params[:location_id])
    end
  end
end
