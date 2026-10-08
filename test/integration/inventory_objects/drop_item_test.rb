# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsDropItemTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  def drop_route(id)
    "/en/inventory_objects/#{id}/drop_item"
  end

  test 'creates location object' do
    item_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: item_type)
    inv_knife = create(:inventory_object, character: @character, subject: knife)

    assert_difference -> { LocationObject.count } => 1,
                      -> { Event.count } => 1 do
      get drop_route(inv_knife.id)
    end
  end

  test 'same endpoint also for notes - creates location object' do
    note = create(:note)
    inv_note = create(:inventory_object, character: @character, subject: note)
    other_character = create(:character, location: @location)

    assert_difference -> { LocationObject.count } => 1,
                      -> { Event.count } => 2 do
      get drop_route(inv_note.id)
    end

    location_note = LocationObject.last
    assert note.id, location_note.subject_id

    event = Event.where(receiver_character: @character).last
    assert_equal "You drop a note \"#{note.title}\"", event.body

    event = Event.where(receiver_character: other_character).last
    assert_equal "You see that <!--CHARID:#{@character.id}-->"\
                 " is droping a note \"#{note.title}\"", event.body
  end
end
