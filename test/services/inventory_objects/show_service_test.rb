# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsShowServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service
    InventoryObjects::ShowService.call(@character)
  end

  test 'returns resources' do
    iron = create(:resource, key: 'iron')
    inv_iron = create(:inventory_object, character: @character, subject: iron,
                                         amount: 200)

    res = call_service

    assert 1, res[:resources].length

    res_iron = res[:resources].sole
    assert_equal inv_iron.id, res_iron[:id]
    assert_equal 200, res_iron[:amount]
    assert_equal 'iron', res_iron[:key]
    assert_not res_iron[:edible]
    assert_not res_iron[:healing]
    assert_equal 'grams', res_iron[:unit]
  end

  test 'returns items' do
    stone_knife = create(:item_type, key: 'stone_knife', weight: 120)
    knife = create(:item, item_type: stone_knife, placeable: @character)
    inv_knife = create(:inventory_object, character: @character, subject: knife,
                                          unit: nil)

    res = call_service

    assert 1, res[:items].length

    res_knife = res[:items].sole
    assert_equal inv_knife.id, res_knife[:id]
    assert_equal 'stone_knife', res_knife[:key]
    assert_equal 'brand_new', res_knife[:damage]
  end
end
