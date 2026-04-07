# frozen_string_literal: true

class TravellersController < ApplicationController
  def new; end

  def create
    Travellers::StartService.call(current_character, traveller_params)
  end

  private

  def traveller_params
    params.require(:traveller).permit(:direction)
  end
end
