# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsShowEatServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(params)
    InventoryObjects::ShowEatService.call(@character, params)
  end

  test 'edible resource' do
    resource = create(:resource, :food, key: 'cucumbers', eaten: 75)
    inv_res = create(:inventory_object, character: @character, subject: resource,
                                        amount: 100)
    @character.update!(hunger: 35)

    params = {
      inventory_object_id: inv_res.id
    }

    res = call_service(params)

    assert_equal 100, res[:food][:max_amount]
    assert_equal 525, res[:food][:needed_amount]
    assert_equal 15, res[:food][:rate_1]
    assert_equal 6.67, res[:food][:rate_100]
    assert_nil res[:heal_info]
  end

  test 'healing resource' do
    resource = create(:resource, :medicine, key: 'grapes', heal: 45)
    inv_res = create(:inventory_object, character: @character, subject: resource,
                                        amount: 120)
    @character.update!(damage: 25)

    params = {
      inventory_object_id: inv_res.id
    }

    res = call_service(params)

    assert_equal 120, res[:heal][:max_amount]
    assert_equal 1125, res[:heal][:needed_amount]
    assert_equal 45, res[:heal][:rate_1]
    assert_equal 2.22, res[:heal][:rate_100]
    assert_nil res[:food]
  end
end
