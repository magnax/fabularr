# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsDropTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(@character)
  end

  def events_route(id)
    "/en/inventory_objects/#{id}/drop"
  end

  test 'creates location object' do
    stone = create(:resource, key: 'stone')
    inv_stone = create(:inventory_object, character: @character,
                                          subject: stone, amount: 100)

    get events_route(inv_stone.id)

    assert_response :ok

    assert_includes response.parsed_body.to_s, 'You can drop max. 100 grams stone'
  end
end
