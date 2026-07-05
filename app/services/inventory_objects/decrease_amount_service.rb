# frozen_string_literal: true

module InventoryObjects
  class DecreaseAmountService < ApplicationService
    def initialize(character, resource, amount)
      @character = character
      @resource = resource
      @amount = amount
    end

    def call
      if @amount >= inventory_object.amount
        inventory_object.destroy
      else
        inventory_object.update!(amount: inventory_object.amount - @amount)
      end
    end

    private

    def inventory_object
      @inventory_object ||= @character.inventory_objects.resource.find_by(
        subject_id: @resource.id
      )
    end
  end
end
