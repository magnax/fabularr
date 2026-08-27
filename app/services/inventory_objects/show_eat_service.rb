# frozen_string_literal: true

module InventoryObjects
  class ShowEatService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      {
        food: food_info,
        heal: heal_info
      }
    end

    private

    def food_info
      return unless resource.edible?

      {
        max_amount: inventory_object.amount,
        needed_amount: needed_full,
        rate_1: eaten_rate_1.round(2),
        rate_100: (500.0 / daily_eaten).round(2)
      }
    end

    def heal_info
      return unless resource.healing?

      {
        max_amount: inventory_object.amount,
        needed_amount: needed_full_heal,
        rate_1: resource.heal,
        rate_100: (100.0 / resource.heal).round(2)
      }
    end

    def needed_full
      (@character.hunger * eaten_rate_1).ceil
    end

    def needed_full_heal
      (@character.damage * resource.heal).ceil
    end

    def eaten_rate_1
      @eaten_rate_1 ||= daily_eaten / 5.0
    end

    def daily_eaten
      @daily_eaten ||= resource.eaten
    end

    def resource
      @resource ||= inventory_object.subject
    end

    def inventory_object
      @inventory_object ||= @character.inventory_objects.find_by(
        id: @params[:inventory_object_id]
      )
    end
  end
end
