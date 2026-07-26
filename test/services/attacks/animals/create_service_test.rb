# frozen_string_literal:true

require 'test_helper'

class AttacksAnimalsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
    @location_character = create(:character, location: @location)
    hunting = create(:skill, key: Skill::HUNTING)
    create(:character_skill, character: @character, skill: hunting, level: 3.6)
    @cat = create(:animal, key: 'cat', health: 30)
  end

  def call_service(params)
    Attacks::CreateService.call(@character, params)
  end

  test 'attack some animals' do
    dog = create(:animal, key: 'dog', health: 40)
    zebra = create(:animal, key: 'zebra', health: 150)
    cats = create(:animal_pack, animal: @cat, location: @location,
                                amount: 3, points: 90)
    dogs = create(:animal_pack, animal: dog, location: @location,
                                amount: 2, points: 80)
    zebras = create(:animal_pack, animal: zebra, location: @location,
                                  amount: 1, points: 150)

    params = {
      force: 10,
      target_ids: [@cat.id, zebra.id],
      target_type: 'animal',
      weapon: 0
    }

    assert_difference -> { Event.count } => 4 do
      call_service(params)
    end

    assert_equal 86, cats.reload.points
    assert_equal 80, dogs.reload.points
    assert_equal 146, zebras.reload.points

    events_me = Event.where(receiver_character: @character)
    events_spectator = Event.where(receiver_character: @location_character)

    assert_equal 2, events_me.count
    assert_equal 2, events_spectator.count

    assert_equal [
      'You skillfully hurt a cat, using bare fist, which loses 4 points',
      'You skillfully hurt a zebra, using bare fist, which loses 4 points'
    ], events_me.pluck(:body).sort
    assert_equal [
      "You see that <!--CHARID:#{@character.id}--> skillfully hurts a cat, using bare fist.",
      "You see that <!--CHARID:#{@character.id}--> skillfully hurts a zebra, using bare fist."
    ], events_spectator.pluck(:body).sort
  end

  test 'attack some animals - kill' do
    cats = create(:animal_pack, animal: @cat, location: @location,
                                amount: 3, points: 62)

    params = {
      force: 10,
      target_ids: [@cat.id],
      target_type: 'animal',
      weapon: 0
    }

    assert_difference -> { Event.count } => 2 do
      call_service(params)
    end

    assert_equal 58, cats.reload.points
    assert_equal 2, cats.amount

    event_me = Event.where(receiver_character: @character).sole
    event_spectator = Event.where(receiver_character: @location_character).sole

    assert_equal 'You skillfully kill a cat, using bare fist.', event_me.body
    assert_equal "You see that <!--CHARID:#{@character.id}--> " \
                 'skillfully kills a cat, using bare fist.',
                 event_spectator.body
  end

  test 'killed animal should drop some resources' do
    cats = create(:animal_pack, animal: @cat, location: @location,
                                amount: 3, points: 62)
    dung = create(:resource, key: 'fresh_dung')
    hide = create(:resource, key: 'hide')
    meat = create(:resource, key: 'meat')

    create(:animal_resource, animal: @cat, resource: dung,
                             min_amount: 50, max_amount: 100)
    create(:animal_resource, animal: @cat, resource: hide,
                             min_amount: 20, max_amount: 40)
    create(:animal_resource, animal: @cat, resource: meat,
                             min_amount: 40, max_amount: 70)

    params = {
      force: 10,
      target_ids: [@cat.id],
      target_type: 'animal',
      weapon: 0
    }

    assert_difference -> { InventoryObject.count } => 3 do
      call_service(params)
    end

    assert_equal 2, cats.reload.amount

    res = @character.reload.inventory_objects.resource
    inv_dung = res.find_by(subject_id: dung.id).amount
    inv_hide = res.find_by(subject_id: hide.id).amount
    inv_meat = res.find_by(subject_id: meat.id).amount

    assert(inv_dung >= 50 && inv_dung <= 100)
    assert(inv_hide >= 20 && inv_hide <= 40)
    assert(inv_meat >= 40 && inv_meat <= 70)
  end

  test 'cannot attack in less than one day' do
    cats = create(:animal_pack, animal: @cat, location: @location,
                                amount: 3, points: 62)
    create(:character_action, character: @character, subject: cats,
                              key: CharacterAction::HUNTING,
                              updated_at: 23.hours.ago)

    params = {
      force: 10,
      target_ids: [@cat.id],
      target_type: 'animal',
      weapon: 0
    }

    assert_raises Attacks::Animal::NotEnoughTimeError do
      call_service(params)
    end
  end
end
