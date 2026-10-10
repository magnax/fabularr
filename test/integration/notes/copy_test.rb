# frozen_string_literal: true

require 'test_helper'

class NotesCopyTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  def copy_route(id)
    "/en/notes/#{id}/copy"
  end

  test 'raises error when invalid note' do
    get copy_route(0)

    assert_response :found

    assert_redirected_to '/en/events'
  end

  test 'creates copy of inventory note' do
    note = create(:note)
    create(:inventory_object, character: @character, subject: note)

    assert_difference -> { InventoryObject.count } => 1 do
      get copy_route(note.id)
    end
  end
end
