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
          direction: 100,
          distance: 'nearby',
          name: l.name,
          type: I18n.t('buildings.lighthouse')
        }
      end
    end

    private

    def lighthouses
      Location.lighthouse
              .where(
                "length(
                  lseg(coords::point, point(#{@character.x},#{@character.y}))
                ) <= ? ", Maps::LIGHTHOUSE_DISTANCE
              )
    end
  end
end
