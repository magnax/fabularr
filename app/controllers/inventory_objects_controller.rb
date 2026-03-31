# frozen_string_literal: true

class InventoryObjectsController < ApplicationController
  before_action :current_character_set

  def index
    @resources = current_character.inventory_objects.resource
    @items = current_character.inventory_objects.item
  end

  def create
    InventoryObjects::CreateService.call(current_character, inventory_object_params)

    redirect_to events_path
  end

  def drop
    @character = current_character
    @location = @character.location
    @inventory_object = inventory_object
    @resource = inventory_object.subject
  end

  def drop_item
    LocationObjects::CreateService.call(
      current_character, params.permit(:inventory_object_id)
    )

    redirect_to events_path
  end

  def add
    @inventory_object = current_character.inventory_objects.find_by(id: params[:inventory_object_id])
    @resource = inventory_object.subject
    @projects = Projects::FilterMissingResourceService.call(
      current_character, @inventory_object.subject
    )
  end

  def update
    Projects::AddFromInventoryService.call(current_character, add_params)

    redirect_to events_path
  end

  private

  def inventory_object_params
    params.require(:inventory_object).permit(:subject_id, :subject_type, :amount)
  end

  def add_params
    params.permit(:amount, :subject_id, :subject_type, :project_id)
  end

  def inventory_object
    @inventory_object ||= InventoryObject.find_by(id: params[:inventory_object_id])
  end
end
