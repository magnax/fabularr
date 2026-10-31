# frozen_string_literal: true

module Maps
  class NearbyObjectsService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      return unless @character.travelling?

      lighthouses.map do |l|
        {
          id: l.id,
          direction: Maps.direction(@character.location.coords, l.coords).round(0),
          distance: I18n.t("distances.#{distance(l.distance)}"),
          name: l.distance <= 60 ? l.name : nil,
          type: I18n.t('buildings.lighthouse')
        }
      end
    end

    private

    def lighthouses
      Location.lighthouse
              .where(
                "#{length_query} <= ? ", Maps::LIGHTHOUSE_DISTANCE_LIT
              )
              .select("locations.id, coords, name, #{length_query} as distance")
    end

    def length_query
      "length(lseg(coords::point, point(#{@character.x},#{@character.y})))"
    end

    def distance(value)
      return 'very_far' if value > 120
      return 'far' if value > 60
      return 'close' if value > 20

      'very_close'
    end
  end
end
