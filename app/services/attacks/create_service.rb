# frozen_string_literal: true

module Attacks
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      apply_damage!
      create_events!
    end

    private

    def apply_damage!
      target_character.update!(damage: target_character.damage + damage)
    end

    def damage
      4
    end

    def create_events!
      if target_character == @character
        Event.create!(
          body: [hit_self, defend_self].map(&:upcase_first).compact.join(' '),
          receiver_character: @character
        )
      else
        Event.create!(
          body: I18n.t('events.hit.character.hit_other'),
          receiver_character: @character
        )
        Event.create!(
          body: I18n.t('events.hit.character.hit_by'),
          receiver_character: target_character
        )
      end

      create_location_events!
    end

    def create_location_events!
      @character.location.visible_characters.each do |char|
        next if char == @character

        event = Event.create!(
          body: I18n.t(
            'events.hit.hit',
            char_name_1: @character.char_id,
            char_name_2: target_character.char_id
          ),
          receiver_character: char
        )

        Events::BroadcastService.call(char.id, event.id)
      end
    end

    def hit_self
      I18n.t('events.hit.character.hit_self',
             skill: skill, weapon: weapon_key,
             lose: lose)
    end

    def defend_self
      if protection.present?
        I18n.t('events.hit.character.defend_self', skill: skill,
                                                   saved: saved,
                                                   protection: protection)
      else
        I18n.t('events.hit.character.defend_self_no_protection')
      end
    end

    def protection
      nil
    end

    def skill
      key = Skill::MAP_LEVELS[@character.fighting.level.floor]
      I18n.t("skills.#{key}")
    end

    def lose
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

    def saved
      23
    end

    def target_character
      @target_character ||= Character.find_by(id: @params[:target_id])
    end
  end
end
