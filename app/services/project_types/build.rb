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

    def resource
      @resource ||= resource_description.subject
    end

    def resource_description
      @resource_description ||= project.project_descriptions
                                       .where(subject_type: 'Resource')
                                       .last
    end

    def amount
      @amount ||= (resource_description.amount * ((rand * 0.2) + 0.9)).to_i
    end

    def location
      @location ||= project.location
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
