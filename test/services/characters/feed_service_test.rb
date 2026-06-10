# frozen_string_literal: true

require 'test_helper'

class CharactersFeedServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service
    Characters::FeedService.call(@character.id)
  end

  test 'increase hunger when character has no food' do
    assert_difference -> { @character.reload.hunger } => 5,
                      -> { Event.count } => 1 do
      call_service
    end

    event = Event.last
    assert_equal 'You are hungry', event.body
  end

  test 'increase hunger up to 100' do
    @character.update!(hunger: 96)

    assert_difference -> { Event.count } => 1 do
      call_service
    end

    assert_equal 100, @character.reload.hunger

    event = Event.last
    assert_equal 'You are hungry', event.body
  end

  test 'hunger is 0 and character has enough food - raw food' do
    food = create(:resource, :raw_food, key: 'potatoes', eaten: 25)
    inv = create(:inventory_object, character: @character, subject: food, amount: 100)

    assert_difference -> { Event.count } => 1 do
      call_service
    end

    assert_equal 0, @character.reload.hunger
    assert_equal 75, inv.reload.amount

    event = Event.last
    assert_equal 'You eat 25 grams of your potatoes', event.body
  end

  test 'hunger is 0 and character has not enough food - raw food' do
    food = create(:resource, :raw_food, key: 'potatoes', eaten: 100)
    create(:inventory_object, character: @character, subject: food, amount: 80)

    assert_difference -> { InventoryObject.count } => -1,
                      -> { Event.count } => 2 do
      call_service
    end

    assert_equal 1, @character.reload.hunger

    events = Event.all.pluck(:body)
    assert_equal ['You are hungry', 'You eat all of your potatoes'], events.sort
  end

  test 'hunger is > 0 and character has enough food so decrease hunger' do
    @character.update!(hunger: 5)
    food = create(:resource, :raw_food, eaten: 100)
    create(:inventory_object, character: @character, subject: food, amount: 180)

    call_service

    assert_equal 2, @character.reload.hunger
  end

  test 'hunger is > 0 and character has not enough food - increase proportionally' do
    @character.update!(hunger: 5)
    food = create(:resource, :raw_food, eaten: 100)
    create(:inventory_object, character: @character, subject: food, amount: 50)

    call_service

    assert_equal 7.5, @character.reload.hunger
  end

  test 'eat less efficient food first' do
    t = create(:resource_type, key: 'raw_food')
    food_1 = create(:resource, key: 'pumpkins', eaten: 10, resource_type_id: [t.id])
    food_2 = create(:resource, key: 'carrots', eaten: 100, resource_type_id: [t.id])
    inv_1 = create(:inventory_object, character: @character, subject: food_1, amount: 50)
    inv_2 = create(:inventory_object, character: @character, subject: food_2, amount: 150)

    call_service

    assert_equal 50, inv_1.reload.amount
    assert_equal 50, inv_2.reload.amount
  end
end
