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

    assert_difference -> { LocationObject.count } => 2,
                      -> { Event.count } => 0 do
      call_service
    end
  end

  test 'stop working on project after dying' do
    create(:worker, character: @character, left_at: nil)

    assert_difference -> { Worker.active.count } => -1 do
      call_service
    end
  end

  test 'create events when other characters are present' do
    char = create(:character, location: @character.location)

    assert_difference -> { Event.count } => 1 do
      call_service
    end

    event = Event.where(receiver_character: char).sole
    assert_equal "You see that <!--CHARID:#{@character.id}--> dies.", event.body
  end
end
