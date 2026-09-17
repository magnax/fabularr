# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsShowDropServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(inv_object_id)
    InventoryObjects::ShowDropService.call(@character, inv_object_id)
  end

  test 'raise error when invalid inventory object' do
    assert_raise InventoryObjects::InvalidObjectError do
      call_service(0)
    end
  end

  test 'returns resources' do
    iron = create(:resource, key: 'iron')
    inv_iron = create(:inventory_object, character: @character, subject: iron,
                                         amount: 200)

    res = call_service(inv_iron.id)

    assert_equal iron.id, res[:subject_id]
    assert_equal 200, res[:amount]
    assert_equal 'iron', res[:key]
    assert_equal 'grams', res[:unit]
    assert_equal 'Resource', res[:subject_type]
  end
end
