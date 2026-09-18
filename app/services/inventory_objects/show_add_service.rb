# frozen_string_literal: true

module InventoryObjects
  class ShowAddService < ApplicationService
    def initialize(character, inventory_object_id)
      @character = character
      @inventory_object_id = inventory_object_id
    end

    def call
      raise InvalidObjectError if inventory_object.blank?

      {
        amount: inventory_object.amount,
        inventory_object_id: inventory_object.id,
        key: inventory_object.subject.key,
        projects: projects,
        subject_id: inventory_object.subject_id,
        subject_type: inventory_object.subject_type,
        unit: inventory_object.unit || 'grams'
      }
    end

    private

    def projects
      @projects ||= Projects::FilterMissingResourceService.call(
        @character, inventory_object.subject
      )
    end

    def inventory_object
      @inventory_object ||= @character.inventory_objects.find_by(
        id: @inventory_object_id
      )
    end
  end
end
