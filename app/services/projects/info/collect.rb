# frozen_string_literal: true

module Projects
  class Info::Collect < ApplicationService
    class InvalidResourceError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise InvalidResourceError unless location_resource.status

      result
    end

    private

    def result
      {
        amount: resource.daily_rate,
        key: location_resource.resource.key,
        location_resource: location_resource,
        location: location_resource.location,
        project_type_id: project_type.id,
        skill: skill_key,
        skill_name: skill_name,
        tools: tools
      }
    end

    def tools
      return [] if recipe.blank?

      recipe.recipe_instructions.map do |tool|
        {
          key: I18n.t("items.#{tool.subject.key}"),
          amount: tool.speed * resource.daily_rate
        }
      end
    end

    def skill_key
      I18n.t("views.skills.#{resource.skill.key}")
    end

    def skill_name
      I18n.t("views.skills.#{resource.skill.key}_perf")
    end

    def recipe
      @recipe ||= Recipe.by_type(Recipe::COLLECT).find_by(key: resource.key)
    end

    def resource
      @resource ||= location_resource.resource
    end

    def location_resource
      @location_resource ||= LocationResource.find_by(id: @params[:location_resource_id])
    end

    def project_type
      @project_type ||= ProjectType.find_by(key: @params[:type])
    end
  end
end
