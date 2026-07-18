# frozen_string_literal: true

module Attacks
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      apply_damage!

      if slap?
        create_slap_events!
      else
        create_events!
      end
    end

    private

    def apply_damage!
      target_character.update!(damage: target_character.damage + damage)
    end

    def create_events!
      if target_character == @character
        create_hit_self_event!
      else
        Event.create!(
          body: hit_other_body,
          receiver_character: @character
        )
        event = Event.create!(
          body: [hit_by, defend].compact.join(' '),
          receiver_character: target_character
        )
        Events::BroadcastService.call(target_character.id, event.id)
      end

      create_location_events!
    end

    def create_hit_self_event!
      Event.create!(
        body: [hit_self, defend].map(&:upcase_first).compact.join(' '),
        receiver_character: @character
      )
    end

    def hit_other_body
      I18n.t('events.hit.character.hit_other',
             skill: skill, character_link: target_character.char_id,
             weapon: weapon_key, lose: damage.round(0), pronoun: target_pronoun)
    end

    def create_slap_events!
      if target_character == @character
        Event.create!(
          body: I18n.t('events.hit.character.slap_self', skill: skill).upcase_first,
          receiver_character: @character
        )
      else
        Event.create!(
          body: I18n.t('events.hit.character.slap_other', skill: skill),
          receiver_character: @character
        )
        event = Event.create!(
          body: I18n.t('events.hit.character.slap_by', skill: skill),
          receiver_character: target_character
        )
        Events::BroadcastService.call(target_character.id, event.id)
      end

      create_location_events!('events.hit.character.slap')
    end

    def create_location_events!(key = 'events.hit.character.hit')
      @character.location.visible_characters.each do |char|
        next if char == @character || char == target_character

        event = create_event!(key, char)

        Events::BroadcastService.call(char.id, event.id)
      end
    end

    def create_event!(key, char)
      Event.create!(
        body: I18n.t(
          key,
          character_link_1: @character.char_id,
          character_link_2: target_character.char_id,
          skill: skill,
          weapon: weapon_key,
          pronoun: target_pronoun
        ),
        receiver_character: char
      )
    end

    def target_pronoun
      return I18n.t(target_pronoun_key) if slap?

      I18n.t(target_pronoun_key).upcase_first
    end

    def target_pronoun_key
      return target_character.male? ? 'genders.himself' : 'genders.herself' if slap?

      target_character.male? ? 'genders.he' : 'genders.she'
    end

    def slap?
      weapon.blank? && @params[:force].to_i.zero?
    end

    def hit_self
      I18n.t('events.hit.character.hit_self',
             skill: skill, weapon: weapon_key,
             lose: damage.round(0))
    end

    def hit_by
      I18n.t('events.hit.character.hit_by',
             character_link: @character.char_id, skill: skill,
             weapon: weapon_key, lose: damage.round(0))
    end

    def defend
      if protection.present?
        I18n.t('events.hit.character.defend', skill: skill,
                                              saved: saved,
                                              protection: protection)
      else
        I18n.t('events.hit.character.defend_no_protection')
      end
    end

    def protection
      nil
    end

    def skill
      key = Skill::MAP_LEVELS[@character.fighting.level.floor]
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

    def saved
      23
    end

    def target_character
      @target_character ||= Character.find_by(id: @params[:target_id])
    end
  end
end
