# frozen_string_literal: true

module Travellers
  class StartService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
      @town = @character.toplevel_location
      @location = @character.location
    end

    def call
      subject_update!

      Traveller.create!(
        direction: direction,
        road: road,
        start_location: @town,
        subject: subject
      )

      create_event!
    end

    private

    def subject_update!
      if subject.is_a?(Character)
        subject.update!(coords: @town.coords, location: nil)
      else
        subject.update!(coords: @town.coords, parent_location: nil)
      end
    end

    def subject
      @subject ||= @location.moveable? ? @location : @character
    end

    def direction
      @direction ||= road.present? ? road_direction : @params[:direction]
    end

    def road_direction
      @road_direction ||= Maps.road_direction(road, @town)
    end

    def create_event!
      Event.create!(
        body: body,
        receiver_character: @character
      )
    end

    def body
      if road.present?
        if subject.is_a?(Character)
          body_road
        else
          body_road_vehicle
        end
      else
        I18n.t('events.travel.start', location_link: @town.loc_id,
                                      direction: @params[:direction])
      end
    end

    def body_road
      I18n.t('events.travel.start_road', location_from_link: @town.loc_id,
                                         location_to_link: dest_location.loc_id,
                                         type: I18n.t("roads.types.#{road.road_type}"))
    end

    def body_road_vehicle
      I18n.t('events.travel.start_road_vehicle', location_from_link: @town.loc_id,
                                                 location_to_link: dest_location.loc_id,
                                                 vehicle_link: subject.loc_id,
                                                 type: I18n.t("roads.types.#{road.road_type}"))
    end

    def dest_location
      @dest_location ||=
        road.location_1 == @town ? road.location_2 : road.location_1
    end

    def road
      @road ||= @params[:road_id].present? ? Road.find_by(id: @params[:road_id]) : nil
    end
  end
end
