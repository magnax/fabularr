# frozen_string_literal: true

require 'test_helper'

class NotesCreateServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
  end

  def call_service(params)
    Notes::CreateService.call(@character, params)
  end

  test 'creates note' do
    params = {
      title: '<b>Title</b>',
      body: '<b>Some</b><script>console.log("test");</script> <i>content</i>'
    }

    assert_difference -> { Note.count } => 1,
                      -> { @character.inventory_objects.count } => 1 do
      call_service params
    end

    note = Note.last
    assert_equal 'Title', note.reload.title
    assert_equal '<b>Some</b> <i>content</i>', note.body
  end
end
