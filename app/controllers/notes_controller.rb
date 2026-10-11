# frozen_string_literal: true

class NotesController < ApplicationController
  def new; end

  def edit
    render locals: Notes::ShowService.call(current_character, params[:id])
  end

  def show
    render locals: Notes::ShowService.call(current_character, params[:id])
  end

  def create
    Notes::CreateService.call(current_character, notes_params)

    redirect_to events_path
  end

  def copy
    Notes::CopyService.call(current_character, params[:note_id])

    redirect_to events_path
  rescue Notes::InvalidNoteError
    render_error(I18n.t('errors.notes.invalid'))
  end

  private

  def notes_params
    params.require(:note).permit(:title, :body)
  end
end
