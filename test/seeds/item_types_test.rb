# frozen_string_literal: true

require 'test_helper'

class SeedsItemTypesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { ItemType.count } => 2 do
      require_relative '../../db/seeds/item_types'
    end
  end
end
