# frozen_string_literal: true

module Projects
  class Create::Build < ApplicationService
    class RecipeNotFoundError < StandardError; end

    attr_reader :project_type

    def initialize(character, project_type, params)
      @character = character
      @project_type = project_type
      @params = params
    end

    def call
      raise RecipeNotFoundError if recipe.blank?

      @project = create_project!
      create_project_descriptions!

      create_creator_event!
      body = I18n.t(
        'events.projects.starting_other',
        character_link: @character.char_id
      )
      Events::CreateEventForAllService.call(location, body, except: @character)
    end

    private

    def create_project!
      Project.create!(project_base_attributes.merge(recipe: recipe))
    end

    def project_base_attributes
      {
        starting_character: @character,
        location: location,
        project_type_id: project_type.id,
        duration: duration,
        amount: nil,
        ready: false
      }
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
    end

    def materials
      recipe.recipe_instructions.resource
    end

    def tools
      recipe.recipe_instructions.tool
    end

    def create_creator_event!
      location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.projects.starting_me', info: project_info)
      )
    end

    def project_info
      I18n.t("project_types.#{project_type.key}")
    end

    def location
      @location ||= @character.location
    end

    def duration
      recipe.base_speed
    end

    def recipe
      @recipe ||= Recipe.find_by(id: @params[:recipe_id])
    end
  end
end
