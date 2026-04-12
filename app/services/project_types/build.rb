# frozen_string_literal: true

module ProjectTypes
  class Build < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      InventoryObject.create(character: project.starting_character,
                             subject: created_item)
    end

    private

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
