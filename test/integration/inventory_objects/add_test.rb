# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsDropTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  test 'show add to project page' do
    stone = create(:resource, key: 'stone')
    inv_stone = create(:inventory_object, character: @character,
                                          subject: stone, amount: 100)

    get "/en/inventory_objects/#{inv_stone.id}/add"

    assert_response :ok

    assert_includes response.parsed_body.to_s, 'You want to add to the project: stone'
  end
end
