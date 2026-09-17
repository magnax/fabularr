# frozen_string_literal: true

module InventoryObjects
  class ShowDropService < ApplicationService
    def initialize(character, inventory_object_id)
      @character = character
      @inventory_object_id = inventory_object_id
    end

    def call
      raise InvalidObjectError if inventory_object.blank?

      {
        amount: inventory_object.amount,
        unit: inventory_object.unit || 'grams',
        key: inventory_object.subject.key,
        subject_id: inventory_object.subject_id,
        subject_type: 'Resource'
      }
    end

    private

    def inventory_object
      @inventory_object ||= @character.inventory_objects.find_by(
        id: @inventory_object_id
      )
    end
  end
end
