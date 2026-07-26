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
        animal = pack.animal
        points = pack.points - damage
        amount = (points.to_i / animal.health.to_i) + 1
        if amount < pack.amount
          drop_resources!(animal)
          create_kill_events!(animal.key)
        else
          create_events!(animal.key, damage)
        end

        pack.update!(points: points, amount: amount)
      end
    end

    def drop_resources!(animal)
      animal.animal_resources.hunt.each do |res|
        amount = (res.min_amount..res.max_amount).to_a.sample
        InventoryObjects::IncreaseAmountService.call(
          @character, res.resource.key, amount
        )
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

    def create_kill_events!(key)
      event = Event.create!(
        body: I18n.t('events.hit.animal_kill', key: key, skill: skill,
                                               weapon: weapon_key),
        receiver_character: @character
      )
      Events::BroadcastService.call(@character.id, event.id)

      create_location_kill_events!(key)
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

    def create_location_kill_events!(key)
      @character.location.visible_characters.each do |char|
        next if char == @character

        event = Event.create!(
          body: I18n.t(
            'events.hit.animal_kill_other',
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
