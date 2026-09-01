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

    # TODO: duplicate code!
    def weapons
      [bare_fist] + inventory_weapons
    end

    def bare_fist
      [I18n.t('items.bare_fist'), 4]
    end

    def inventory_weapons
      @character.inventory_objects.weapon.map do |weapon|
        [weapon.subject.key, weapon.subject.item_type.attack]
      end
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
