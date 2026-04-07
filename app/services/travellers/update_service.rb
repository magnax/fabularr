# frozen_string_literal: true

module Travellers
  class UpdateService < ApplicationService
    def initialize(traveller)
      @traveller = traveller
    end

    def call
      x = subject.x
      y = subject.y

      subject.update!(
        coords: {
          x: new_x(x),
          y: new_y(y)
        }
      )
      @traveller.update!(checked_at: current_time)
    end

    private

    def subject
      @subject ||= @traveller.subject
    end

    def radians
      @radians ||= @traveller.direction * Math::PI / 180.0
    end

    def new_x(val)
      val + (distance * Math.sin(radians))
    end

    def new_y(val)
      # graphics coordinate system has (0,0) in upper left corner
      # so vertical coordinate is always negated
      val - (distance * Math.cos(radians))
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
