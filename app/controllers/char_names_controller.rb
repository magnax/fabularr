#encoding = utf-8
class CharNamesController < ApplicationController
  def create
  	@charname = current_character.char_names.build(charname_params)

    if @charname.save
      flash[:success] = "Zmieniono nazwę!"
      redirect_to events_path
    else
      redirect_to character_name_url(current_character.id)
    end
  end

  def update
  	@charname = CharName.find(params[:id])

    if @charname.update_attributes(charname_params)
      flash[:success] = "Uaktualniono nazwę!"
      redirect_to events_path
    else
      redirect_to character_name_url(current_character.id)
    end
  end

  private

    def charname_params
      params.require(:char_name).permit(:name, :description, :named_id)
    end

end
