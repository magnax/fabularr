# frozen_string_literal: true

require 'ostruct'

module Characters
  class AttackInfoService < ApplicationService
    include Attacks::Info

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise Characters::InvalidCharacterError if invalid_character?
      raise Attacks::Characters::NotEnoughTimeError unless can_attack?

      {
        force: force,
        target_id: target_character.id,
        weapons: weapons.sort { |w| w[1] }
      }
    end

    private

    def invalid_character?
      target_character.blank? || !same_location_or_vehicle?
    end

    def same_location_or_vehicle?
      target_character.location == @character.location || visible?
    end

    def visible?
      return false if @character.location.building? || target_character.location.building?

      target_character.toplevel_location == @character.toplevel_location
    end

    def can_attack?
      action.blank? || time_diff >= GameTime::DAY
    end

    def time_diff
      return if action.blank?

      DateTime.current.to_i - action.updated_at.to_i
    end

    def action
      @action ||= @character.character_actions.find_by(
        key: CharacterAction::ATTACK,
        subject: target_character
      )
    end

    def target_character
      @target_character ||= Character.find_by(id: @params[:character_id])
    end
  end
end
