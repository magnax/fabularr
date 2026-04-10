# frozen_string_literal: true

module Travellers
  class UpdateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      traveller.update!(update_params)
    end

    private

    def traveller
      @traveller ||= Traveller.find_by(id: @params[:id])
    end

    def update_params
      {
        speed: speed,
        direction: direction
      }
    end

    def speed
      return 0 if stop?
      return traveller.speed if @params[:speed].blank?

      s = @params[:speed].to_f
      s >= 0 && s <= 100 ? s : traveller.speed
    end

    def direction
      return reversed_direction if reverse?
      return traveller.direction if @params[:direction].blank?

      dir = @params[:direction].to_f
      dir >= 0 && dir <= 360 ? dir : traveller.direction
    end

    def stop?
      @params[:order] == 'stop'
    end

    def reverse?
      @params[:order] == 'reverse'
    end

    def reversed_direction
      rev = traveller.direction - 180
      rev.negative? ? rev + 360 : rev
    end
  end
end
