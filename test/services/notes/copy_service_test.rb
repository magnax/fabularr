# frozen_string_literal: true

require 'test_helper'

class NotesCopyServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
  end

  def call_service(note_id)
    Notes::CopyService.call(@character, note_id)
  end

  test 'raise error when invalid note' do
    assert_raise Notes::InvalidNoteError do
      call_service(0)
    end
  end

  test 'raise error when invalid note - not present' do
    note = create(:note)

    assert_raise Notes::InvalidNoteError do
      call_service(note.id)
    end
  end

  test 'raise error when invalid note - not present, character travelling' do
    note = create(:note)
    @character.update!(location_id: nil)

    assert_raise Notes::InvalidNoteError do
      call_service(note.id)
    end
  end

  test 'copy note from inventory' do
    note = create(:note)
    create(:inventory_object, character: @character, subject: note)

    assert_difference -> { InventoryObject.count } => 1,
                      -> { Event.count } => 1 do
      call_service(note.id)
    end

    event = Event.last
    assert_equal "You make a copy of \"#{note.title}\"", event.body
  end

  test 'copy note from the ground' do
    note = create(:note)
    create(:location_object, location: @location, subject: note)
    other_character = create(:character, location: @location)

    assert_difference -> { InventoryObject.count } => 1,
                      -> { Event.count } => 2 do
      call_service(note.id)
    end

    event = Event.where(receiver_character: @character).last
    assert_equal "You make a copy of \"#{note.title}\"", event.body

    event = Event.where(receiver_character: other_character).last
    assert_equal "You see that <!--CHARID:#{@character.id}-->" \
                 " makes a copy of \"#{note.title}\"", event.body
  end
end
