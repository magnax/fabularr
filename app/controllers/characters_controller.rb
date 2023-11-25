# frozen_string_literal: true

class CharactersController < ApplicationController
	before_action :signed_in_user
  before_action :check_character_create, only: [:new, :create]

  def new
  	@character = current_user.characters.build
  end

  def create
  	@character = current_user.create_character(character_params, Location.random[0].id)

    if @character.save
      flash[:success] = I18n.t 'flash.success.character_created'
      redirect_to list_path
    else
      render 'new'
    end
  end

  def set
    cookies.permanent[:character_token] = params[:id]
    redirect_to events_path
  end

  def name
    @named_character = Character.find(params[:id])
    @charname = current_character.char_name_or_build @named_character
  end

  private

  def character_params
    params.require(:character).permit(:name, :gender)
  end

  def check_character_create
  	if not current_user.can_create_new_character? 
			flash[:error] = I18n.t 'flash.errors.cannot_create'
			redirect_to list_path and return	
  	end
  end
end
