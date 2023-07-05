#encoding = utf-8
class CharNamesController < ApplicationController
  before_action :update_blank_name

  def create
  	@charname = current_character.char_names.build(charname_params)

    if @charname.save
      flash[:success] = I18n.t 'flash.success.character_name_created'
    else
      flash[:error] = I18n.t 'flash.errors.character_name_change_error'
    end
    redirect_to events_path
  end

  def update
  	@charname = CharName.find(params[:id])
    
    if @charname.update(charname_params)
      flash[:success] = I18n.t 'flash.success.character_name_changed'
    else
      flash[:error] = I18n.t 'flash.errors.character_name_change_error'
    end
    redirect_to events_path
  end

  private

  def update_blank_name
    params[:char_name][:name] = '%char%' if params[:char_name][:name].blank?
  end
  
  def charname_params
    params.require(:char_name).permit(:name, :description, :named_id)
  end
end
