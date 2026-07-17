# frozen_string_literal: true

module Recipes
  class MachineService < ApplicationService
    class InvalidMachineError < StandardError; end
    class MachineInUseError < StandardError; end

    def initialize(character, machine_id)
      @character = character
      @machine_id = machine_id
    end

    def call
      raise InvalidMachineError if machine.blank?

      raise MachineInUseError if machine_in_use?

      {
        count: all_recipes.length,
        machine_id: @machine_id,
        name: name,
        recipes: recipes
      }
    end

    private

    def machine_in_use?
      ProjectDescription.machine.find_by(subject_id: machine.id).present?
    end

    def name
      I18n.t("machineries.#{machine.subject.key}")
    end

    def recipes
      obj = {}
      all_recipes.each do |recipe|
        recipe_instructions = recipe.recipe_instructions

        variant = {
          id: recipe.id,
          resource_instructions: map_resources(recipe_instructions),
          key: recipe.key,
          recipe_type: I18n.t("#{recipe.recipe_type.pluralize}.#{recipe.key}").downcase
        }

        obj = add_or_merge_variant(obj, variant, recipe_instructions)
      end

      obj
    end

    def add_or_merge_variant(obj, variant, instructions)
      key = instructions.resource_out.first.subject.key
      if obj[key].present?
        obj[key] << variant
      else
        obj = obj.merge(key => [variant])
      end

      obj
    end

    def map_resources(recipe_instructions)
      recipe_instructions.resource.map do |ri|
        key = I18n.td("resources.#{ri.subject.key}")
        key = "<b>#{key}</b>" if ri.subject.id.in?(inventory_resources)

        "<span>#{key}</span>"
      end
    end

    def inventory_resources
      @inventory_resources ||= @character.inventory_objects.resource.pluck(:subject_id)
    end

    def all_recipes
      RecipeInstruction.where(
        instruction_type: 'machinery', subject: machine.subject
      ).map(&:recipe)
    end

    def machine
      @machine ||= LocationObject.find_by(id: @machine_id)
    end
  end
end
