# frozen_string_literal: true

module InventoryObjects
  class ConsumeService < ApplicationService
    class InvalidResourceError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise InvalidResourceError if resource.blank? || inventory_object.blank?

      update_character_damage!
      @amount_left = InventoryObjects::DecreaseAmountService.call(
        @character, resource, amount
      )

      Events::CreateAndBroadcastService.call(@character, body)
    end

    private

    def update_character_damage!
      return if @character.damage.zero?

      new_damage = @character.damage - (resource.rate_1g * amount)
      new_damage = 0 if new_damage.negative?

      @character.update!(damage: new_damage)
    end

    def body
      return I18n.t('events.eaten_all', res: resource_key) if @amount_left.zero?

      I18n.t('events.eaten', amount: amount, res: resource_key)
    end

    def amount
      @amount ||= [@params[:amount].to_i, inventory_object.amount].min
    end

    def resource_key
      I18n.td("resources.#{resource.key}")
    end

    def inventory_object
      @inventory_object ||= @character.inventory_objects.find_by(
        subject_id: resource.id
      )
    end

    def resource
      @resource ||= Resource.find_by(id: @params[:subject_id])
    end
  end
end
