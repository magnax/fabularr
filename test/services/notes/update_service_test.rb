# frozen_string_literal: true

require 'test_helper'

class NotesUpdateServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
  end

  def call_service(params)
    Notes::UpdateService.call(@character, params)
  end

  test 'raises error when invalid note' do
    params = {
      id: 0,
      title: '<b>Title</b>',
      body: 'body'
    }

    assert_raises Notes::InvalidNoteError do
      call_service params
    end
  end

  test 'raises error when invalid note - cannot edit notes on the ground' do
    note = create(:note)
    create(:location_object, location: @location, subject: note)

    params = {
      id: note.id,
      title: 'title',
      body: 'body'
    }

    assert_raises Notes::InvalidNoteError do
      call_service params
    end
  end

  test 'raises error when invalid note - note read-only' do
    note = create(:note, editable: false)
    create(:inventory_object, character: @character, subject: note)

    params = {
      id: note.id,
      title: 'title',
      body: 'body'
    }

    assert_raises Notes::InvalidNoteError do
      call_service params
    end
  end

  test 'updates a note' do
    note = create(:note, title: 'Title', body: 'Body', editable: true)
    create(:inventory_object, character: @character, subject: note)

    params = {
      id: note.id,
      title: 'New title',
      body: 'New body'
    }

    call_service params

    assert_equal 'New title', note.reload.title
    assert_equal 'New body', note.body
  end
end
