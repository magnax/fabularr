# frozen_string_literal: true

module Projects
  class Finish::Building < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project)
      @project = project
    end

    def call
      create_building!

      update_workers!

      notify_starting_character
    end

    private

    def create_building!
      building = Location.create!(
        Definitions::LocationTypes::CONFIG_BUILDINGS[location_type.key].merge(
          location_type: location_type,
          location_class: LocationClass.find_by(key: recipe.recipe_type),
          parent_location: location,
          coords: location.coords,
          name: name
        )
      )
      return if name.blank?

      building.signboards.create!(text: name)
    end

    def body
      I18n.t('events.projects.end.item', **project_info)
    end

    def project_info
      {
        item: I18n.t("#{@project.recipe.recipe_type.pluralize}.#{@project.recipe.key}")
      }
    end

    def location_type
      @location_type ||= LocationType.find_by(key: recipe.key)
    end

    def name
      @project.settings['name']
    end

    def recipe
      @recipe ||= @project.recipe
    end

    def location
      @location ||= @project.location
    end
  end
end
