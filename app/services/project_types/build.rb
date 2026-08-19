# frozen_string_literal: true

module ProjectTypes
  class Build < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      InventoryObject.create(character: project.starting_character,
                             subject: created_item)

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

    def created_item
      item_type = ItemType.find_by(key: project.recipe.key)
      Item.create!(item_type: item_type,
                   damage: 0, placeable: project.starting_character)
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
