# frozen_string_literal: true

class CharactersController < ApplicationController
  def new
    raise Users::TooManyCharactersError unless current_user.can_create_character?
  end

  def create
    Characters::CreateService.call(current_user, character_params)

    flash[:success] = I18n.t 'flash.success.character_created'
    redirect_to list_path
  end

  def name
    @named_character = Character.find(params[:character_id])
    @charname = current_character.char_name_or_build @named_character
  end

  def set
    cookies.permanent[:character_token] = params[:character_id]
    redirect_to events_path
  end

  def show
    @character = Character.find_by(id: params[:id])
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
