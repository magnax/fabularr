# frozen_string_literal: true

require 'test_helper'

class NotesCreateTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  def notes_route
    '/notes'
  end

  test 'creates new note' do
    params = {
      note: {
        title: 'New note',
        body: 'Note body'
      }
    }

    assert_difference -> { Note.count } => 1,
                      -> { InventoryObject.count } => 1 do
      post notes_route, params: params
    end

    note = Note.last
    inv_note = @character.reload.inventory_objects.last

    assert_equal note, inv_note.subject
    assert_equal params[:note][:title], note.title
    assert_equal params[:note][:body], note.body
    assert note.editable
  end
end
