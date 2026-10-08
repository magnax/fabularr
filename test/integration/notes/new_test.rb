# frozen_string_literal: true

require 'test_helper'

class NotesNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, name: 'Magnus', user: @user, location: @location, spawn_location: @location)
    sign_in(@user)
    click_link 'Magnus'
  end

  def path
    '/en/notes/new'
  end

  test 'shows new note form' do
    visit(path)

    assert_equal 200, page.status_code

    assert_content 'Write a note'
    assert_content 'Title:'
  end
end
