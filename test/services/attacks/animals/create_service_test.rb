# frozen_string_literal:true

require 'test_helper'

class AttacksAnimalsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
    @location_character = create(:character, location: @location)
    hunting = create(:skill, key: Skill::HUNTING)
    create(:character_skill, character: @character, skill: hunting, level: 3.6)
  end

  def call_service(params)
    Attacks::CreateService.call(@character, params)
  end

  test 'attack some animals' do
    cat = create(:animal, key: 'cat', health: 30)
    dog = create(:animal, key: 'dog', health: 40)
    zebra = create(:animal, key: 'zebra', health: 150)
    cats = create(:animal_pack, animal: cat, location: @location,
                                amount: 3, points: 90)
    dogs = create(:animal_pack, animal: dog, location: @location,
                                amount: 2, points: 80)
    zebras = create(:animal_pack, animal: zebra, location: @location,
                                  amount: 1, points: 150)

    params = {
      force: 10,
      target_id: [cat.id, zebra.id],
      target_type: 'animal',
      weapon: 0
    }

    assert_difference -> { Event.count } => 4 do
      call_service(params)
    end

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
end
