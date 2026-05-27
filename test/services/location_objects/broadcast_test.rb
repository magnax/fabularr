# frozen_string_literal: true

require 'test_helper'

class LocationObjectsBroadcastTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  def setup
    @character = create(:character)
    @location = @character.location
  end

  def call_service(params)
    LocationObjects::CreateService.call(@character, params)
  end

  test 'drop item from inventory' do
    item_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: item_type)
    inv_knife = create(:inventory_object, character: @character, subject: knife)
    second_character = create(:character, location: @character.location)

    params = {
      inventory_object_id: inv_knife.id
    }

    call_service(params)

    [@character.id, second_character.id].each do |id|
      event = Event.where(receiver_character_id: id).sole
      assert_broadcast_on "char_#{id}", { type: 'event', event_id: event.id }
    end
  end

  # test 'taking item from the ground' do
  #   second_character = create(:character, location: @character.location)
  #   item_type = create(:item_type, key: 'iron_knife')
  #   iron_knife = create(:item, item_type: item_type)
  #   location_iron_knife = create(:location_object, location: @character.location,
  #                                                  subject: iron_knife)

  #   params = {
  #     location_object_id: location_iron_knife.id
  #   }

  #   call_service(params)

  #   [@character.id, second_character.id].each do |id|
  #     event = Event.where(receiver_character_id: id).sole
  #     assert_broadcast_on "char_#{id}", { type: 'event', event_id: event.id }
  #   end
  # end
end
