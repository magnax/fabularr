# frozen_string_literal: true

module Travellers
  class UpdatePositionService < ApplicationService
    def initialize(traveller)
      @traveller = traveller
    end

    def call
      subject_update_coords!

      check_arrive_to_location

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
      receiver_characters.each do |receiver_character|
        Event.create!(
          receiver_character: receiver_character,
          body: I18n.t('events.travel.forced_stop')
        )
      end
    end

    def receiver_characters
      return [subject] if subject.is_a?(Character)

      subject.characters
    end

    def subject
      @subject ||= @traveller.subject
    end

    def check_arrive_to_location
      if @traveller.road.present?
        Travellers::ArriveToLocationService.call(@traveller) if nearby?
      elsif nearby_location.present?
        Travellers::ArriveToLocationService.call(@traveller, nearby_location)
      end
    end

    def nearby?
      @traveller.distance >= @traveller.road.distance
    end

    def nearby_location
      @nearby_location ||= Location.town.where(
        'length('\
          'lseg('\
            "coords::point, point(#{subject.x}, #{subject.y})"\
          ')'\
        ') <= ?', Location::ARRIVE_DISTANCE
      ).first
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
      @real_speed ||= @traveller.speed_factor * base_speed * (@traveller.speed / 100.0)
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
