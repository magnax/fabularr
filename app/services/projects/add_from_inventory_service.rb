# frozen_string_literal: true

module Projects
  class AddFromInventoryService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      form.update!(@params)

      add_resource_to_project!
      Projects::CheckRequirementsService.call(form.project.id)
    end

    private

    def form
      @form ||= Projects::AddResourceForm.new(character_id: @character.id)
    end

    def add_resource_to_project!
      new_amount = inventory_object.amount - transferred_amount
      new_req_amount = description_object.amount + transferred_amount
      inventory_object.update!(amount: new_amount)
      description_object.update!(amount: new_req_amount)
    end

    def transferred_amount
      amount = needed_by_product_amount
      amount = form.amount if amount > form.amount
      amount = inventory_object.amount if amount > inventory_object.amount
      amount
    end

    def needed_by_product_amount
      description_object.amount_needed - description_object.amount
    end

    def inventory_object
      @inventory_object ||= form.inventory_object
    end

    def description_object
      @description_object ||= form.project_description_object
    end
  end
end
