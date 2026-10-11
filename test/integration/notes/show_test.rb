# frozen_string_literal: true

require 'test_helper'

class NotesShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, name: 'Magnus', user: @user, location: @location, spawn_location: @location)
    sign_in(@user)
    click_link 'Magnus'
  end

  def show_path(note_id)
    "/en/notes/#{note_id}"
  end

  test 'shows note' do
    note = create(:note)
    create(:inventory_object, character: @character, subject: note)

    visit show_path(note.id)

    assert_equal 200, page.status_code

    assert_selector "div[class='title-bar']", text: note.title
    assert_selector 'pre', text: note.body
  end

  test 'simple HTML formatting' do
    note = create(:note, body: '<b>Some text</b>')
    create(:inventory_object, character: @character, subject: note)

    visit show_path(note.id)

    assert_equal 200, page.status_code

    assert_selector 'b', text: 'Some text'
  end
end
