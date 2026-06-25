# frozen_string_literal:true

require 'test_helper'

class AttacksCreateServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
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

    assert_difference -> { Event.count } => 1 do
      call_service(params)
    end

    assert_equal 4, @character.reload.damage

    event = Event.last
    assert_equal 'You efficiently hurt yourself using bare fist. '\
                 "You lose 4 points. You're not saving any points.", event.body
  end
end
