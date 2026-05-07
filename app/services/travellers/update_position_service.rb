# frozen_string_literal: true

module Travellers
  class UpdatePositionService < ApplicationService
    def initialize(traveller)
      @traveller = traveller
    end

    def call
      subject_update_coords!

      check_arrive_to_location if @traveller.road.present?

      @traveller.update!(checked_at: current_time)
    end

    private

    def subject_update_coords!
      updated_coords = new_coords(subject.coords, distance)
      if location_type(updated_coords).is_a?(LocationType)
        subject.update!(coords: updated_coords)
      elsif distance < 1
        stop_travel!
      else
        update_coords_in_steps!(distance)
      end
    end

    def update_coords_in_steps!(distance)
      (1..distance.floor).each do |min_distance|
        updated_coords = new_coords(subject.coords, min_distance)
        next if location_type(updated_coords).is_a?(LocationType)

        subject.update!(coords: new_coords(subject.coords, min_distance - 1))
        stop_travel!
        break
      end
    end

    def location_type(coords)
      Maps.location_type(coords[:x], coords[:y])
    end

    def stop_travel!
      @traveller.update!(speed: 0)
      create_event!
    end

    def create_event!
      Event.create!(
        receiver_character: subject,
        body: I18n.t('events.travel.forced_stop')
      )
    end

    def subject
      @subject ||= @traveller.subject
    end

    def check_arrive_to_location
      return unless @traveller.distance >= @traveller.road.distance

      @traveller.subject.update!(
        location: @traveller.destination_location, coords: nil
      )
      @traveller.update!(status: false)
      create_events!
    end

    def create_events!
      create_traveller_event!
    end

    def create_traveller_event!
      Event.create!(
        receiver_character: @traveller.subject, # TO DO: adjust when travelling in vehicle
        body: I18n.t('events.travel.arrive', location_link: @traveller.subject.location.loc_id)
      )
    end

    def radians
      @radians ||= @traveller.direction * Math::PI / 180.0
    end

    def new_coords(coords, distance)
      {
        x: coords.x + (distance * Math.sin(radians)),
        # graphics coordinate system has (0,0) in upper left corner
        # so vertical coordinate is always negated
        y: coords.y - (distance * Math.cos(radians))
      }
    end

    def distance
      @distance ||= real_speed * (time_elapsed / 60.0)
    end

    # TODO: temporarily hardcoded 3 x base speed (so for characters without any load)
    def real_speed
      @real_speed ||= 3 * base_speed * (@traveller.speed / 100.0)
    end

    def time_elapsed
      @time_elapsed ||= current_time.to_f - (@traveller.checked_at&.to_f || @traveller.created_at.to_f)
    end

    def current_time
      @current_time ||= DateTime.current
    end

    # TODO: temporarily hardcoded and only for characters
    # vehicles will be added with more complex configuration
    def base_speed
      0.01736 # pixels for 1 minute (60 sec.)
    end
  end
end
