# frozen_string_literal: true

module ProjectTypes
  class Machinery < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project)
      @project = project
    end

    def call
      if created_item.portable && creator_present?
        @project.starting_character.inventory_objects.create!(
          subject: created_item
        )
      else
        location.location_objects.create(subject: created_item)
      end

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

    def creator_present?
      @project.location == @project.starting_character&.location
    end

    def created_item
      ::Machinery.find_by(key: recipe.key)
    end

    def location
      @location ||= @project.location
    end

    def recipe
      @recipe ||= @project.recipe
    end
  end
end
