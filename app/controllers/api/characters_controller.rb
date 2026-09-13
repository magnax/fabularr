# frozen_string_literal: true

class Api::CharactersController < ApplicationController
  before_action :current_character_set

  def name
    render json: {
      content: render_to_string(
        partial: 'api/characters/name',
        locals: Characters::ShowService.call(
          current_character, params[:character_id]
        )
      )
    }
  end
end
