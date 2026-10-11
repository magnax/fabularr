# frozen_string_literal: true

require 'test_helper'

class NotesEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, name: 'Magnus', user: @user, location: @location, spawn_location: @location)
    sign_in(@user)
    click_link 'Magnus'
  end

  def edit_path(note_id)
    "/en/notes/#{note_id}/edit"
  end

  test 'shows note form' do
    note = create(:note)

    visit edit_path(note.id)

    assert_equal 200, page.status_code

    assert_content 'Edit a note'
    assert_content 'Title:'
    assert_selector "input[value='#{note.title}']"
    assert_selector 'textarea', text: note.body
  end
end
