# frozen_string_literal: true

module Projects
  class Info::Machine < ApplicationService
    class InvalidMachineError < StandardError; end
    class InvalidRecipeError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
      @machine_id = params[:project][:machine_id]
    end

    def call
      raise InvalidMachineError if machine.blank?
      raise InvalidRecipeError unless valid_recipe?

      true
    end

    private

    def valid_recipe?
      recipe.present?
    end

    def recipe
      @recipe = Recipe.find_by(id: @params[:recipe_id])
    end

    def machine
      LocationObject.find_by(
        id: @machine_id,
        subject_type: 'Machinery',
        location_id: @character.location_id
      )
    end
  end
end
