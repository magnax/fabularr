# frozen_string_literal: true

module Attacks
  class Character < ApplicationService
    include Attacks::AttackHelper

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      apply_damage!
      apply_items_rot!

      if slap?
        create_slap_events!
      else
        create_hit_events!
      end
    end

    private

    def apply_damage!
      target_character.update!(damage: target_character.damage + total_damage)
    end

    def apply_items_rot!
      Items::ApplyUseDamageService.call(weapon.subject) if weapon.present?
      Items::ApplyUseDamageService.call(protection.subject) if protection.present?
    end

    def create_hit_events!
      if target_character == @character
        Event.create!(body: body_hit_self, receiver_character: @character)
      else
        Event.create!(body: body_hit_other, receiver_character: @character)

        Events::CreateAndBroadcastService.call(target_character, body_hit_by)
      end

      create_location_events!
    end

    def create_slap_events!
      if target_character == @character
        Event.create!(
          body: body_slap('self').upcase_first,
          receiver_character: @character
        )
      else
        Event.create!(body: body_slap('other'), receiver_character: @character)

        Events::CreateAndBroadcastService.call(target_character, body_slap('by'))
      end

      create_location_events!('events.hit.character.slap')
    end

    def create_location_events!(key = 'events.hit.character.hit')
      Events::CreateEventForAllService.call(
        @character.location.visible_characters, body_spectators(key),
        except: [@character, target_character]
      )
    end

    def body_hit_other
      I18n.t('events.hit.character.hit_other',
             skill: skill, character_link: target_character.char_id,
             weapon: weapon_key, lose: total_damage.round(0), pronoun: target_pronoun)
    end

    def body_hit_self
      [hit_self, defend].map(&:upcase_first).compact.join(' ')
    end

    def body_hit_by
      [hit_by, defend].compact.join(' ')
    end

    def body_slap(who)
      I18n.t("events.hit.character.slap_#{who}", skill: skill)
    end

    def body_spectators(key)
      I18n.t(
        key,
        character_link_1: @character.char_id,
        character_link_2: target_character.char_id,
        skill: skill,
        weapon: weapon_key,
        pronoun: target_pronoun
      )
    end

    def hit_self
      I18n.t('events.hit.character.hit_self',
             skill: skill, weapon: weapon_key,
             lose: total_damage.round(0))
    end

    def hit_by
      I18n.t('events.hit.character.hit_by',
             character_link: @character.char_id, skill: skill,
             weapon: weapon_key, lose: total_damage.round(0))
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

    def skill
      key = Skill::MAP_LEVELS[@character.fighting.level.floor]
      I18n.t("skills.#{key}")
    end

    def target_character
      @target_character ||= ::Character.find_by(id: @params[:target_id])
    end
  end
end
