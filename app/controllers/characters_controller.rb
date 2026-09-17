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

  def attack
    render locals: Characters::AttackInfoService.call(current_character, attack_params)
  end

  def name
    render locals: CharNames::ShowService.call(current_character, params[:character_id])
  end

  def point
    Events::PointService.call(current_character, 'character', params[:character_id])

    redirect_to events_path
  end

  def set
    cookies.permanent[:character_token] = params[:character_id]
    redirect_to events_path
  end

  def show
    render locals: Characters::ShowService.call(current_character, params[:id])
  rescue Characters::InvalidCharacterError
    render_error I18n.t('errors.characters.invalid')
  end

  def talk
    render locals: Characters::TalkService.call(
      current_character, params[:character_id]
    )
  rescue Characters::InvalidCharacterError
    render_error I18n.t('errors.characters.invalid')
  end

  private

  def character_params
    params.require(:character).permit(:name, :gender)
  end

  def attack_params
    params.permit(:character_id)
  end
end
