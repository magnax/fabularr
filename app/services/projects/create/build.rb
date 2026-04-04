# frozen_string_literal: true

module Projects
  class Create::Build < Projects::Create::Base
    class RecipeNotFoundError < StandardError; end

    def call
      raise RecipeNotFoundError if recipe.blank?

      super

      create_project_descriptions!
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

    def create_project_descriptions!
      materials.each do |material|
        @project.project_descriptions.create!(
          description_type: ProjectDescription::RESOURCE_IN,
          subject: material.subject,
          amount: 0,
          amount_needed: material.amount,
          unit: material.unit
        )
      end
      tools.each do |tool|
        @project.project_descriptions.create!(
          description_type: ProjectDescription::TOOL,
          subject: tool.subject,
          amount: nil,
          amount_needed: nil,
          unit: nil
        )
      end
      create_name_description! if @params[:name]
    end

    def materials
      recipe.recipe_instructions.resource
    end

    def tools
      recipe.recipe_instructions.tool
    end

    def create_name_description!
      @project.project_descriptions.create!(
        description_type: ProjectDescription::SETTINGS,
        subject: nil,
        amount: nil,
        amount_needed: nil,
        unit: nil,
        metadata: { name: @params[:name] }
      )
    end

    def project_info
      @project.short_name
    end

    def duration
      recipe.base_speed
    end

    def recipe
      @recipe ||= Recipe.find_by(id: @params[:recipe_id])
    end
  end
end
