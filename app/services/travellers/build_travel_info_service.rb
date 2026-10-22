# frozen_string_literal: true

module Travellers
  class BuildTravelInfoService < ApplicationService
    def initialize(character, traveller)
      @character = character
      @traveller = traveller
    end

    def call
      return if @traveller.blank?

      {
        location: travel_location_hash(start_location),
        dest_location: travel_location_hash(destination_location),
        traveller_id: @traveller.id,
        speed: @traveller.speed.to_i,
        direction: @traveller.direction.to_i,
        percent: percent,
        subject: subject_hash
      }
    end

    private

    def subject_hash
      {
        id: @traveller.subject_id,
        name: @traveller.subject.name,
        type: @traveller.traveller_type,
        class: location_class
      }
    end

    def location_class
      @location_class ||= begin
        return if @traveller.subject.is_a?(Character)

        @traveller.subject.location_type.key
      end
    end

    def travel_location_hash(location)
      return {} if location.blank?

      {
        id: location.id,
        name: location.display_name(@character, parent: true)
      }
    end

    def percent
      return if @traveller.road.blank?

      Maps.calculate_percent(@traveller, @traveller.road).round(1)
    end

    def start_location
      @start_location ||= @traveller.start_location
    end

    def destination_location
      @destination_location ||= @traveller.destination_location
    end
  end
end
