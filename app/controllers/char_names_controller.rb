# frozen_string_literal: true

class CharNamesController < ApplicationController
  before_action :update_blank_name

  def create
    CharNames::UpsertService.call(current_character, charname_params)

    redirect_to events_path
  end

  def update
    CharNames::UpsertService.call(current_character, charname_params)

    redirect_to events_path
  end

  private

  def charname_params
    params.require(:char_name).permit(:name, :description, :named_id)
  end
end
