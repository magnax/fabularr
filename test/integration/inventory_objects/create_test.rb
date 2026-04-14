# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, location: @location, user: @user)
    login(@character)
  end

  test 'show page' do
    stone = create(:resource, key: 'stone')
    create(:location_object, location: @location,
                             subject: stone, amount: 100)

    params = {
      inventory_object: {
        subject_id: stone.id,
        subject_type: 'Resource',
        amount: '50'
      }
    }

    assert_difference -> { InventoryObject.count } => 1 do
      post '/inventory_objects', params: params
    end

    assert_response :found

    assert_redirected_to '/en/events'
  end
end
