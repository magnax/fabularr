# frozen_string_literal: true

module InventoryObjects
  class ShowService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      {
        resources: resources,
        items: items
      }
    end

    private

    def resources
      inventory_objects.resource.map do |res|
        {
          amount: res.amount,
          edible: res.subject.edible?,
          healing: res.subject.healing?,
          id: res.id,
          key: res.subject.key,
          unit: res.subject.unit
        }
      end
    end

    def items
      inventory_objects.item.map do |item|
        {
          id: item.id,
          damage: item.subject.damage_key,
          key: item.subject.item_type.key
        }
      end
    end

    def inventory_objects
      @inventory_objects ||= @character.inventory_objects
    end
  end
end
