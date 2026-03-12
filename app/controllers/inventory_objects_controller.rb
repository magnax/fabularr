# frozen_string_literal: true

class InventoryObjectsController < ApplicationController
  before_action :signed_in_user
  before_action :current_character_set

  def create
    InventoryObjects::CreateService.call(current_character, inventory_object_params)

    redirect_to events_path
  end

  private

  def inventory_object_params
    params.require(:inventory_object).permit(:subject_id, :subject_type, :amount)
  end
end
