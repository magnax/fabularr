# frozen_string_literal: true

module InventoryObjects
  class IncreaseAmountService < ApplicationService
    def initialize(character, key, amount)
      @character = character
      @key = key
      @amount = amount
    end

    def call
      if @character.carrying_weight + @amount > Character::MAX_CAPACITY
        location_object.update!(amount: location_object.amount + @amount)
      else
        inventory_object.update!(amount: inventory_object.amount + @amount)
      end
    end

    private

    def inventory_object
      @inventory_object ||=
        @character.inventory_objects.resource.find_by(subject_id: resource.id) ||
        @character.inventory_objects.resource.create!(subject: resource, amount: 0)
    end

    def location_object
      @location_object ||=
        location_objects.find_by(subject_id: resource.id) ||
        location_objects.create!(subject: resource, amount: 0)
    end

    def location_objects
      @character.location.location_objects.resource
    end

    def resource
      @resource ||= Resource.find_by(key: @key)
    end
  end
end
