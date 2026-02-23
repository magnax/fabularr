# frozen_string_literal: true

class CharactersController < ApplicationController
  before_action :signed_in_user

  def new; end

  def create
    Characters::CreateService.call(current_user, character_params)

    flash[:success] = I18n.t 'flash.success.character_created'
    redirect_to list_path
  end

  def set
    cookies.permanent[:character_token] = params[:id]
    redirect_to events_path
  end

  def name
    @named_character = Character.find(params[:id])
    @charname = current_character.char_name_or_build @named_character
  end

  def talk
    @named_character = Character.find(params[:character_id])
    @charname = current_character.char_name_or_build @named_character
    @location = current_character.location
  end

  private

  def character_params
    params.require(:character).permit(:name, :gender)
  end
end
