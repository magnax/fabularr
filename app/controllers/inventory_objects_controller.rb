# frozen_string_literal: true

class InventoryObjectsController < ApplicationController
  before_action :current_character_set

  def index
    render locals: InventoryObjects::ShowService.call(current_character)
  end

  def create
    InventoryObjects::CreateService.call(
      current_character, inventory_object_params
    )

    redirect_to events_path
  end

  def drop
    render locals: InventoryObjects::ShowDropService.call(
      current_character, params[:inventory_object_id]
    )
  rescue InventoryObjects::InvalidObjectError
    render_error I18n.t('errors.inventory_objects.invalid')
  end

  def drop_item
    LocationObjects::CreateService.call(
      current_character, params.permit(:inventory_object_id)
    )

    redirect_to events_path
  end

  def eat
    render locals: InventoryObjects::ShowEatService.call(
      current_character, params.permit(:inventory_object_id)
    )
  end

  def consume
    InventoryObjects::ConsumeService.call(current_character, inventory_object_params)

    redirect_to events_path
  end

  def add
    render locals: InventoryObjects::ShowAddService.call(
      current_character, params[:inventory_object_id]
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
end
