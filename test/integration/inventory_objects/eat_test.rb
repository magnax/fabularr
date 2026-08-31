# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsEatTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  def events_route(id)
    "/en/inventory_objects/#{id}/eat"
  end

  test 'shows eating form' do
    grapes = create(:resource, :raw_food, key: 'grapes', eaten: 100)
    inv_grapes = create(:inventory_object, character: @character,
                                           subject: grapes, amount: 100)

    get events_route(inv_grapes.id)

    assert_response :ok

    assert_includes response.parsed_body.to_s, 'Amount to eat:'
  end

  test '#post create eating action' do
    grapes = create(:resource, :raw_food, key: 'grapes', heal: 100)
    inv_grapes = create(:inventory_object, character: @character,
                                           subject: grapes, amount: 1000)
    @character.update!(damage: 20)

    params = {
      inventory_object: {
        subject_id: grapes.id,
        subject_type: 'Resource',
        amount: 250
      }
    }

    assert_difference -> { Event.count } => 1 do
      post eat_inventory_objects_url, params: params
    end

    assert_redirected_to events_path

    event = Event.last
    assert_equal 'You eat 250 grams of your grapes', event.body

    assert_equal 17.5, @character.reload.damage
    assert_equal 750, inv_grapes.reload.amount
  end

  test '#post eat up all if amount is greater than in inventory' do
    grapes = create(:resource, :raw_food, key: 'grapes', heal: 100)
    create(:inventory_object, character: @character,
                              subject: grapes, amount: 100)
    @character.update!(damage: 0)

    params = {
      inventory_object: {
        subject_id: grapes.id,
        subject_type: 'Resource',
        amount: 250
      }
    }

    assert_difference -> { Event.count } => 1,
                      -> { InventoryObject.count } => -1 do
      post eat_inventory_objects_url, params: params
    end

    assert_redirected_to events_path

    event = Event.last
    assert_equal 'You eat all of your grapes', event.body

    assert_equal 0, @character.reload.damage
  end

  test '#post can eat up more than needed to fully heal' do
    grapes = create(:resource, :raw_food, key: 'grapes', heal: 100)
    inv_grapes = create(:inventory_object, character: @character,
                                           subject: grapes, amount: 1000)
    @character.update!(damage: 1)

    params = {
      inventory_object: {
        subject_id: grapes.id,
        subject_type: 'Resource',
        amount: 250
      }
    }

    assert_difference -> { Event.count } => 1 do
      post eat_inventory_objects_url, params: params
    end

    assert_redirected_to events_path

    event = Event.last
    assert_equal 'You eat 250 grams of your grapes', event.body

    assert_equal 0, @character.reload.damage
    assert_equal 750, inv_grapes.reload.amount
  end

  test '#post can eat up some to reduce hunger' do
    grapes = create(:resource, :raw_food, key: 'grapes', eaten: 100)
    inv_grapes = create(:inventory_object, character: @character,
                                           subject: grapes, amount: 1000)
    @character.update!(hunger: 5)

    params = {
      inventory_object: {
        subject_id: grapes.id,
        subject_type: 'Resource',
        amount: 100
      }
    }

    assert_difference -> { Event.count } => 1 do
      post eat_inventory_objects_url, params: params
    end

    assert_redirected_to events_path

    event = Event.last
    assert_equal 'You eat 100 grams of your grapes', event.body

    assert_equal 0, @character.reload.hunger
    assert_equal 900, inv_grapes.reload.amount
  end

  test '#post can eat up more than needed to fully reduce hunger' do
    grapes = create(:resource, :raw_food, key: 'grapes', eaten: 100)
    inv_grapes = create(:inventory_object, character: @character,
                                           subject: grapes, amount: 1000)
    @character.update!(hunger: 3)

    params = {
      inventory_object: {
        subject_id: grapes.id,
        subject_type: 'Resource',
        amount: 200
      }
    }

    assert_difference -> { Event.count } => 1 do
      post eat_inventory_objects_url, params: params
    end

    assert_redirected_to events_path

    event = Event.last
    assert_equal 'You eat 200 grams of your grapes', event.body

    assert_equal 0, @character.reload.hunger
    assert_equal 800, inv_grapes.reload.amount
  end
end
