# frozen_string_literal: true

class NotesController < ApplicationController
  def new; end

  def create
    Notes::CreateService.call(current_character, notes_params)

    redirect_to events_path
  end

  private

  def notes_params
    params.require(:note).permit(:title, :body)
  end
end
