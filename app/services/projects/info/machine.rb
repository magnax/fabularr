# frozen_string_literal: true

module Projects
  class Info::Machine < ApplicationService
    class InvalidMachineError < StandardError; end
    class MachineInUseError < StandardError; end
    class InvalidRecipeError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
      @machine_id = params[:project][:machine_id]
    end

    def call
      raise InvalidMachineError if machine.blank?
      raise MachineInUseError if machine.in_use?
      raise InvalidRecipeError unless valid_recipe?

      {
        daily_amount: daily_amount,
        machine_id: machine.id,
        max_amount: max_amount,
        project_type_id: project_type.id,
        recipe_id: recipe.id,
        resource_out: resource_out,
        resources_in: resources_in
      }
    end

    private

    def valid_recipe?
      recipe.present?
    end

    def daily_amount
      resource_out_instruction.amount
    end

    def max_amount
      max_amount_instruction.amount
    end

    def resource_out
      I18n.td("resources.#{resource_out_instruction.subject.key}")
    end

    def resources_in
      resources_in_instructions.map do |ri|
        {
          amount_needed: ri.amount,
          key: ri.subject.key,
          needed: needed_resource_string(ri),
          having: inventory_resource_amount(ri.subject_id)
        }
      end
    end

    def needed_resource_string(resource_instruction)
      resource = I18n.td("resources.#{resource_instruction.subject.key}")
      I18n.t('views.projects.machine.needed', amount: resource_instruction.amount,
                                              resource: resource)
    end

    def inventory_resource_amount(resource_id)
      inventory_resources.find_by(subject_id: resource_id)&.amount || 0
    end

    def inventory_resources
      @inventory_resources = @character.inventory_objects.resource
    end

    def resources_in_instructions
      @resources_in_instructions ||= instructions.resource
    end

    def max_amount_instruction
      @max_amount_instruction ||= instructions.find_by(
        instruction_type: RecipeInstruction::MAX_AMOUNT
      )
    end

    def resource_out_instruction
      @resource_out_instruction ||= instructions.find_by(
        instruction_type: RecipeInstruction::RESOURCE_OUT
      )
    end

    def instructions
      @instructions ||= recipe.recipe_instructions
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

    def project_type
      @project_type ||= ProjectType.find_by(key: ProjectType::MACHINERY)
    end
  end
end
