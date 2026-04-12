# frozen_string_literal: true

module Travellers
  class UpdateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      traveller.update!(update_params)

      create_event!
    end

    private

    def update_params
      {
        speed: speed,
        direction: direction
      }
    end

    def create_event!
      Event.create!(
        receiver_character: traveller.subject,
        body: I18n.t("events.travel.#{body}")
      )
    end

    def body
      return 'reverse' if reverse?
      return 'stop' if stop?

      'update'
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

    def traveller
      @traveller ||= Traveller.find_by(id: @params[:id])
    end
  end
end
