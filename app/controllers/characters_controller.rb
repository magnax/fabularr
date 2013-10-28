#encoding = utf-8
class CharactersController < ApplicationController
	before_action :signed_in_user, :check_character_create

  def new
  	@character = current_user.characters.build if signed_in?
  end

  def create
  	@character = current_user.characters.build(character_params)
    #not final implementation!
    @character.spawn_location_id = 1
    @character.location_id = 1

    if @character.save
      flash[:success] = "Utworzono postać!"
      redirect_to current_user
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
    @charnames = current_character.char_names.where(named_id: params[:id])
    if @charnames.count > 0
      @charname = @charnames.first
    else
      @charname = current_character.char_names.build(
        named_id: params[:id], 
        name: current_character.name_for(@named_character)
      )
    end
  end

  private

    def character_params
      params.require(:character).permit(:name, :gender)
    end

    def check_character_create
    	if not current_user.can_create_new_character? 
  			flash[:error] = "Nie możesz tworzyć więcej postaci"
  			redirect_to current_user and return	
	  	end
	  end

end
