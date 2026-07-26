# frozen_string_literal: true

module Attacks
  class Animal < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      apply_damage!
    end

    private

    def apply_damage!
      target_packs.each do |pack|
        pack.update!(points: pack.points - damage)

        create_events!(pack.animal.key, damage)
      end
    end

    def create_events!(key, damage)
      event = Event.create!(
        body: I18n.t('events.hit.animal', key: key, damage: damage.to_i,
                                          skill: skill, weapon: weapon_key),
        receiver_character: @character
      )
      Events::BroadcastService.call(@character.id, event.id)

      create_location_events!(key)
    end

    def create_location_events!(key)
      @character.location.visible_characters.each do |char|
        next if char == @character

        event = Event.create!(
          body: I18n.t(
            'events.hit.animal_other',
            key: key, skill: skill,
            weapon: weapon_key, character_link: @character.char_id
          ),
          receiver_character: char
        )

        Events::BroadcastService.call(char.id, event.id)
      end
    end

    def skill
      key = Skill::MAP_LEVELS[@character.hunting.level.floor]
      I18n.t("skills.#{key}")
    end

    def damage
      damage_points * (@params[:force].to_i / 10.0)
    end

    def damage_points
      return 4 if weapon.blank?

      10
    end

    def weapon_key
      key = if weapon.blank?
              'bare_fist'
            else
              'stone_knife'
            end

      I18n.t("items.#{key}")
    end

    def weapon
      nil
    end

    def target_packs
      @target_packs ||= location.animal_packs.where(animal_id: @params[:target_id])
    end

    def location
      @location ||= @character.location
    end
  end
end
