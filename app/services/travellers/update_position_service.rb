# frozen_string_literal: true

module Travellers
  class UpdatePositionService < ApplicationService
    def initialize(traveller)
      @traveller = traveller
    end

    def call
      subject.update!(coords: new_coords(subject.coords))

      @traveller.update!(checked_at: current_time)
    end

    private

    def subject
      @subject ||= @traveller.subject
    end

    def radians
      @radians ||= @traveller.direction * Math::PI / 180.0
    end

    def new_coords(coords)
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
