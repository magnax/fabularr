# frozen_string_literal: true

module Projects
  class ProjectInfoService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      return Projects::Info::Road.call(@character, @params) if @params[:type] == 'road'

      {
        location_resource: location_resource,
        location: location_resource.location,
        project_type_id: project_type.id,
        amount: amount,
        tools: tools
      }
    end

    private

    def amount
      @amount ||= 86_400.0 / location_resource.resource.base_speed_per_unit
    end

    def tools
      return [] if recipe.blank?

      recipe.recipe_instructions.map do |tool|
        {
          key: I18n.t("items.#{tool.subject.key}"),
          amount: tool.speed * amount
        }
      end
    end

    def recipe
      @recipe ||= Recipe.by_type(Recipe::COLLECT).find_by(key: location_resource.resource.key)
    end

    def location_resource
      @location_resource ||= LocationResource.find_by(id: @params[:location_resource_id])
    end

    def project_type
      @project_type ||= ProjectType.find_by(key: @params[:type])
    end
  end
end
