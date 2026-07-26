# frozen_string_literal: true

module Animals
  class AttackInfoService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      {
        animals: animals,
        force: force,
        target_id: nil,
        weapons: weapons.sort { |w| w[1] }
      }
    end

    private

    def animals
      location.animal_packs.includes(:animal).map do |pack|
        {
          id: pack.animal.id,
          name: pack.animal.key
        }
      end
    end

    # TODO: duplicate code!
    def weapons
      [bare_fist]
    end

    def bare_fist
      [I18n.t('items.bare_fist'), 4]
    end

    def force
      (0..10).map do |i|
        OpenStruct.new(id: i, tag: i)
      end
    end

    def location
      @location ||= @character.location
    end
  end
end
