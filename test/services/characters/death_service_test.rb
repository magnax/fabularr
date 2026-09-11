# frozen_string_literal: true

require 'test_helper'

class CharactersDeathServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service
    Characters::DeathService.call(@character.id)
  end

  test "character's items and resources are dropped to location" do
    stone = create(:resource, key: 'stone')
    item_type = create(:item_type, key: 'iron_knife')
    knife = create(:item, item_type: item_type)
    create(:inventory_object, character: @character, subject: stone, amount: 100)
    create(:inventory_object, character: @character, subject: knife)

    assert_difference -> { LocationObject.count } => 2 do
      call_service
    end
  end
end
