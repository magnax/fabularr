# frozen_string_literal: true

module Projects
  class Finish::Vehicle < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project)
      @project = project
    end

    def call
      Location.create!(
        location_definitions.merge(
          coords: location.coords,
          location_type: location_type,
          location_class: LocationClass.find_by(key: recipe.recipe_type),
          metadata: { base_speed: all_definitions[:base_speed] },
          name: name,
          parent_location: location
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
        item: I18n.t("#{@project.recipe.recipe_type.pluralize}.#{@project.recipe.key}")
      }
    end

    def location_definitions
      @location_definitions ||= all_definitions.except(:base_speed)
    end

    def all_definitions
      @all_definitions ||= Definitions::LocationTypes::CONFIG_VEHICLES[location_type.key]
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
