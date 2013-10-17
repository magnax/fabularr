class CharactersController < ApplicationController
	before_action :signed_in_user, :check_character_create

  def new
  	@character = current_user.characters.build if signed_in?
  end

  def create
  	@character = current_user.characters.build(character_params)
    if @character.save
      flash[:success] = "Utworzono postac!"
      redirect_to current_user
    else
      render 'new'
    end
  end

  private

    def character_params
      params.require(:character).permit(:name, :gender)
    end

    def check_character_create
    	if not current_user.can_create_new_character? 
  			flash[:error] = "Nie mozesz tworzyc wiecej postaci"
  			redirect_to current_user and return	
	  	end
	end
end
