# frozen_string_literal: true

module Attacks
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise InvalidWeaponError unless valid_weapon?

      service_name.call(@character, attack_params)
    end

    private

    def service_name
      "Attacks::#{@params[:target_type].camelize}".constantize
    end

    def attack_params
      @params.except(:weapon).merge(inventory_object_id: weapon&.id)
    end

    def valid_weapon?
      @params[:weapon].to_s == '0' || weapon.present?
    end

    def weapon
      @weapon ||= begin
        return unless weapons.any?

        weapons.min_by { |w| w.item.damage }
      end
    end

    def weapons
      @character.inventory_objects.weapon
    end
  end
end
