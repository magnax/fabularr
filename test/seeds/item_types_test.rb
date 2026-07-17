# frozen_string_literal: true

require 'test_helper'

class SeedsItemTypesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { ItemType.count } => 7 do
      require_relative '../../db/seeds/item_types'
    end

    # assert virtual item type
    virtual = ItemType.find_by(key: 'small_shaft')
    assert virtual.virtual
    assert_equal 2, virtual.item_types.length
  end
end
