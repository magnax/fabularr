# frozen_string_literal:true

require 'test_helper'

class AttacksCreateServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @location_character = create(:character, location: @character.location)
    fighting = create(:skill, key: Skill::FIGHTING)
    create(:character_skill, character: @character, skill: fighting, level: 2.6)
  end

  def call_service(params)
    Attacks::CreateService.call(@character, params)
  end

  test 'attack self with bare fist' do
    params = {
      target_id: @character.id,
      target_type: 'character',
      weapon: 0,
      force: 10
    }

    assert_difference -> { Event.count } => 2 do
      call_service(params)
    end

    assert_equal 4, @character.reload.damage

    event_me = Event.where(receiver_character: @character).sole
    event_spectator = Event.where(receiver_character: @location_character).sole

    assert_equal '<b>You efficiently hurt yourself using bare fist. '\
                 "You lose 4 points. You're not saving any points.</b>", event_me.body
    assert_equal "You see <!--CHARID:#{@character.id}--> efficiently hurts "\
                 "<!--CHARID:#{@character.id}--> using bare fist", event_spectator.body
  end

  test 'attack self with bare fist with half force' do
    params = {
      target_id: @character.id,
      target_type: 'character',
      weapon: 0,
      force: 5
    }

    assert_difference -> { Event.count } => 2 do
      call_service(params)
    end

    assert_equal 2, @character.reload.damage

    event = Event.where(receiver_character: @character).sole
    assert_equal '<b>You efficiently hurt yourself using bare fist. '\
                 "You lose 2 points. You're not saving any points.</b>", event.body
  end

  test 'attack self with bare fist with little force - rounding' do
    params = {
      target_id: @character.id,
      target_type: 'character',
      weapon: 0,
      force: 2
    }

    assert_difference -> { Event.count } => 2 do
      call_service(params)
    end

    assert_equal 0.8, @character.reload.damage

    event = Event.where(receiver_character: @character).sole
    assert_equal '<b>You efficiently hurt yourself using bare fist. '\
                 "You lose 1 points. You're not saving any points.</b>", event.body
  end

  test 'attack self with bare fist - slap' do
    params = {
      target_id: @character.id,
      target_type: 'character',
      weapon: 0,
      force: 0
    }

    assert_difference -> { Event.count } => 2 do
      call_service(params)
    end

    assert_equal 0, @character.reload.damage

    event_me = Event.where(receiver_character: @character).sole
    event_spectator = Event.where(receiver_character: @location_character).sole

    assert_equal '<b>You efficiently slap yourself in the face. '\
                 "You didn't lose any points.</b>", event_me.body
    assert_equal "You see <!--CHARID:#{@character.id}--> efficiently slaps himself",
                 event_spectator.body
  end

  test 'attack other with bare fist' do
    target_character = create(:character, location: @character.location)

    params = {
      target_id: target_character.id,
      target_type: 'character',
      weapon: 0,
      force: 5
    }

    assert_difference -> { Event.count } => 3 do
      call_service(params)
    end

    assert_equal 2, target_character.reload.damage

    event_attacker = Event.where(receiver_character: @character).sole
    event_target = Event.where(receiver_character: target_character).sole
    event_spectator = Event.where(receiver_character: @location_character).sole

    assert_equal "You efficiently hurt <!--CHARID:#{target_character.id}--> "\
                 'using bare fist. He loses 2 points.', event_attacker.body
    assert_equal "<b><!--CHARID:#{@character.id}-->"\
                 ' efficiently hurts you using bare fist. '\
                 "You lose 2 points. You're not saving any points.</b>",
                 event_target.body
    assert_equal "You see <!--CHARID:#{@character.id}--> "\
                 "efficiently hurts <!--CHARID:#{target_character.id}--> "\
                 'using bare fist', event_spectator.body
  end
end
