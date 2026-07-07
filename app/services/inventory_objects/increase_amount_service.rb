# frozen_string_literal: true

module InventoryObjects
  class IncreaseAmountService < ApplicationService
    def initialize(character, key, amount)
      @character = character
      @key = key
      @amount = amount
    end

    def call
      inventory_object.update!(amount: inventory_object.amount + @amount)
    end

    private

    def inventory_object
      @inventory_object ||=
        @character.inventory_objects.resource.find_by(subject_id: resource.id) ||
        @character.inventory_objects.resource.create!(subject: resource, amount: 0)
    end

    def resource
      @resource ||= Resource.find_by(key: @key)
    end
  end
end
