# frozen_string_literal: true

module Animals
  class AttackInfoService < ApplicationService
    include Attacks::Info

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
          can_attack: can_attack?(pack),
          id: pack.animal.id,
          name: pack.animal.key
        }
      end
    end

    def can_attack?(pack)
      !pack.id.in?(last_attacked_packs_ids)
    end

    def last_attacked_packs_ids
      @last_attacked_packs_ids ||=
        @character.character_actions.hunting.recent.pluck(:subject_id)
    end

    def location
      @location ||= @character.location
    end
  end
end
