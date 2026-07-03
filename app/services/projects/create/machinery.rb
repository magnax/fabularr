# frozen_string_literal: true

module Projects
  class Create::Machinery < Projects::Create::Base
    def call
      raise Projects::InvalidMachineError if machine.blank?
      raise Projects::RecipeNotFoundError if recipe.blank?

      @project = create_project!

      create_project_descriptions!

      create_creator_event!
      create_others_events!
    end

    private

    def project_attributes
      project_base_attributes.merge(
        {
          duration: duration,
          amount: nil,
          ready: false,
          recipe: recipe
        }
      )
    end

    def duration
      ratio * GameTime::DAY
    end

    def project_info
      @project.short_name
    end

    def create_project_descriptions!
      # what to produce
      @project.project_descriptions.create!(
        description_type: ProjectDescription::RESOURCE_OUT,
        subject: resource_out,
        amount: amount,
        unit: 'grams'
      )
      # what to add:
      resources_in.each do |resource|
        @project.project_descriptions.create!(
          description_type: ProjectDescription::RESOURCE_IN,
          subject: resource[:resource],
          amount_needed: resource[:needed],
          amount: resource[:added],
          unit: 'grams'
        )
      end
    end

    def amount
      @params[:amount]
    end

    def resources_in
      recipe.recipe_instructions.resource.map do |instruction|
        {
          resource: instruction.subject,
          needed: calculate_needed_amount(instruction),
          added: 0
        }
      end
    end

    def calculate_needed_amount(instruction)
      (instruction.amount * ratio).ceil
    end

    def ratio
      @ratio ||= @params[:amount].to_f / instruction_out.amount
    end

    def resource_out
      instruction_out.subject
    end

    def instruction_out
      @instruction_out ||= recipe.recipe_instructions.resource_out.sole
    end

    def recipe
      Recipe.find_by(id: @params[:recipe_id])
    end

    def machine
      location.machines.find_by(id: @params[:machine_id])
    end
  end
end
