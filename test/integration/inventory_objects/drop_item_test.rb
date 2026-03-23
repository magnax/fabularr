# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsDropItemTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(@character)
  end

  def events_route(id)
    "/en/inventory_objects/#{id}/drop_item"
  end

  test 'creates location object' do
    item_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: item_type)
    inv_knife = create(:inventory_object, character: @character, subject: knife)

    assert_difference -> { LocationObject.count } => 1 do
      get events_route(inv_knife.id)
    end
  end
end
