# frozen_string_literal: true

module ProjectTypes
  class Building < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      Location.create!(
        Definitions::LocationTypes::CONFIG_BUILDINGS[location_type.key].merge(
          location_type: location_type,
          location_class: LocationClass.find_by(key: recipe.recipe_type),
          parent_location: location,
          coords: location.coords,
          name: name
        )
      )

      update_workers!

      notify_starting_character
    end

    private

    def body
      I18n.t('events.projects.end.item', **project_info)
    end

    def project_info
      {
        item: I18n.t("#{project.recipe.recipe_type.pluralize}.#{project.recipe.key}")
      }
    end

    def location_type
      @location_type ||= LocationType.find_by(key: recipe.key)
    end

    def name
      project.settings['name']
    end

    def recipe
      @recipe ||= project.recipe
    end

    def location
      @location ||= project.location
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
