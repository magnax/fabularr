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
end
