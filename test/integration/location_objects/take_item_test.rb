# frozen_string_literal: true

require 'test_helper'

class LocationObjectsTakeItemTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  def take_item_route(id)
    "/en/location_objects/#{id}/take_item"
  end

  test 'creates inventory object' do
    item_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: item_type)
    location_knife = create(:location_object, location: @location, subject: knife)

    assert_difference -> { InventoryObject.count } => 1 do
      get take_item_route(location_knife.id)
    end
  end

  test 'creates inventory object - the same interface for notes' do
    note = create(:note)
    location_note = create(:location_object, location: @location, subject: note)
    other_character = create(:character, location: @location)

    assert_difference -> { InventoryObject.count } => 1,
                      -> { Event.count } => 2 do
      get take_item_route(location_note.id)
    end

    inventory_note = InventoryObject.last
    assert note.id, inventory_note.subject_id

    event = Event.where(receiver_character: @character).last
    assert_equal "You're taking a note \"#{note.title}\"", event.body

    event = Event.where(receiver_character: other_character).last
    assert_equal "You see that <!--CHARID:#{@character.id}-->"\
                 " is taking a note \"#{note.title}\"", event.body
  end
end
