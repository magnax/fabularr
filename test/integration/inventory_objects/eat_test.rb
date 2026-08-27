# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsEatTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  def events_route(id)
    "/en/inventory_objects/#{id}/eat"
  end

  test 'shows eating form' do
    grapes = create(:resource, :raw_food, key: 'grapes')
    inv_grapes = create(:inventory_object, character: @character,
                                           subject: grapes, amount: 100)

    get events_route(inv_grapes.id)

    assert_response :ok

    assert_includes response.parsed_body.to_s, 'Amount to eat:'
  end
end
