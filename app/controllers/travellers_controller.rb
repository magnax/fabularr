# frozen_string_literal: true

class TravellersController < ApplicationController
  def new; end

  def create
    Travellers::StartService.call(current_character, traveller_params)

    redirect_to events_path
  end

  def update
    Travellers::UpdateService.call(current_character, traveller_params.merge(id: params[:id]))

    redirect_to events_path
  end

  def stop
    Travellers::UpdateService.call(current_character, { id: params[:traveller_id], order: 'stop' })

    redirect_to events_path
  end

  def reverse
    Travellers::UpdateService.call(current_character, { id: params[:traveller_id], order: 'reverse' })

    redirect_to events_path
  end

  private

  def traveller_params
    params.require(:traveller).permit(:direction, :speed)
  end
end
