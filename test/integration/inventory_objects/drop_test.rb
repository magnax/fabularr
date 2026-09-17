# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsDropTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  def events_route(id)
    "/en/inventory_objects/#{id}/drop"
  end

  test 'shows error message when invalid resource' do
    get events_route(0)

    assert_response :found
    assert_redirected_to '/en/events'
  end

  test 'shows form for dropping resource' do
    stone = create(:resource, key: 'stone')
    inv_stone = create(:inventory_object, character: @character,
                                          subject: stone, amount: 100)

    get events_route(inv_stone.id)

    assert_response :ok

    assert_includes response.parsed_body.to_s, 'You can drop max. 100 grams stone'
  end
end
