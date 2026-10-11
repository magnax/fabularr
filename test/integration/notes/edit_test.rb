# frozen_string_literal: true

require 'test_helper'

class NotesEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, name: 'Magnus', user: @user, location: @location, spawn_location: @location)
  end

  def edit_path(note_id)
    "/en/notes/#{note_id}/edit"
  end

  test 'raises error if invalid note' do
    note = create(:note)
    login(@user, @character)

    get edit_path(note.id)

    assert_response :found

    assert_redirected_to '/en/events'
  end

  test 'shows note form' do
    note = create(:note)
    create(:inventory_object, character: @character, subject: note)

    sign_in(@user)
    click_link 'Magnus'

    visit edit_path(note.id)

    assert_equal 200, page.status_code

    assert_content 'Edit a note'
    assert_content 'Title:'
    assert_selector "input[value='#{note.title}']"
    assert_selector 'textarea', text: note.body

    # action's method is POST, but there is additional hidden field with HTTP method
    assert_selector "form[method='post'][action='#{host}/en/notes/#{note.id}']"
    assert_selector 'input[type="hidden"][name="_method"][value="put"]', visible: false
  end
end
