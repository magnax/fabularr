# frozen_string_literal: true

module InventoryObjects
  class ShowEatService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      {}
    end
  end
end
