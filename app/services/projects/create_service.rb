# frozen_string_literal: true

module Projects
  class CreateService < ApplicationService
    class RecipeNotFoundError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise RecipeNotFoundError if recipe_not_found?

      @project = create_project!
      create_project_descriptions!

      create_creator_event!
      body = I18n.t(
        'events.projects.starting_other',
        character_link: "<!--CHARID:#{@character.id}-->"
      )
      Events::CreateEventForAllService.call(location, body, except: @character)
    end

    private

    def recipe_not_found?
      return unless project_type.key == 'build'

      recipe.blank?
    end

    def create_project!
      Project.create!(
        starting_character: @character,
        location: location,
        project_type_id: project_type.id,
        duration: duration,
        amount: amount
      )
    end

    def create_project_descriptions!
      return if project_type.key == 'discover_resource'

      if project_type.key == 'collect'

        ProjectDescription.create!(
          project: @project,
          description_type: ProjectDescription::RESOURCE_OUT,
          subject: resource,
          amount: 0,
          amount_needed: amount,
          unit: resource.unit
        )
      else
        materials.each do |material|
          ProjectDescription.create!(
            project: @project,
            description_type: ProjectDescription::RESOURCE_IN,
            subject: material.subject,
            amount: 0,
            amount_needed: material.amount,
            unit: material.unit
          )
        end
      end
    end

    def materials
      recipe.recipe_instructions.resource
    end

    def create_creator_event!
      location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.projects.starting_me', info: project_info)
      )
    end

    def project_info
      return type_name if location_resource.blank?

      "#{type_name} #{resource_name}"
    end

    def type_name
      I18n.t("project_types.#{project_type.key}")
    end

    def resource_name
      I18n.t("resources.#{resource.key}")
    end

    def location
      @location ||= @character.location
    end

    def duration
      return build_duration if build_project?
      return project_type.base_speed if project_type.fixed?

      amount * project_type.base_speed
    end

    def build_project?
      @build_project ||= project_type.key == 'build'
    end

    def build_duration
      recipe.base_speed
    end

    def recipe
      @recipe ||= Recipe.find_by(id: @params[:recipe_id])
    end

    def amount
      @params[:amount].to_i
    end

    def project_type
      @project_type ||= ProjectType.find_by(id: @params[:project_type_id])
    end

    def resource
      @resource ||= location_resource.resource
    end

    def location_resource
      @location_resource ||= LocationResource.find_by(id: @params[:location_resource_id])
    end
  end
end
