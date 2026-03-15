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
      new_amount = form.inventory_object.amount - transferred_amount
      new_req_amount = form.project_description_object.amount + transferred_amount
      form.inventory_object.update!(amount: new_amount)
      form.project_description_object.update!(amount: new_req_amount)
    end

    def transferred_amount
      amount = needed_by_product_amount
      amount = form.amount if amount > form.amount
      amount = form.inventory_object.amount if amount > form.inventory_object.amount
      amount
    end

    def needed_by_product_amount
      form.project_description_object.amount_needed - form.project_description_object.amount
    end

    def project
      @project ||= Project.find_by(id: @params[:project_id])
    end
  end
end
