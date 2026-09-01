# frozen_string_literal: true

require 'test_helper'

class AnimalsAttackInfoServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service
    Animals::AttackInfoService.call(@character)
  end

  test 'show nothing when no animals' do
    res = call_service

    assert_empty res[:animals]
  end

  test 'show animal packs' do
    dog = create(:animal, key: 'dog')
    zebra = create(:animal, key: 'zebra')
    create(:animal_pack, location: @character.location, animal: zebra, amount: 3)
    create(:animal_pack, location: @character.location, animal: dog, amount: 5)

    res = call_service

    assert_equal 2, res[:animals].length

    pack = res[:animals].find { |p| p[:name] == 'zebra' }
    assert pack[:can_attack]
    assert_equal zebra.id, pack[:id]
  end

  test 'indicate pack which cannot be attacked' do
    dog = create(:animal, key: 'dog')
    location_dogs = create(:animal_pack, location: @character.location,
                                         animal: dog, amount: 5)
    create(:character_action, character: @character, subject: location_dogs)

    res = call_service

    assert_equal 1, res[:animals].length

    pack = res[:animals].find { |p| p[:name] == 'dog' }
    assert_not pack[:can_attack]
  end

  test 'indicate pack which can be attacked again (one day passed)' do
    dog = create(:animal, key: 'dog')
    location_dogs = create(:animal_pack, location: @character.location,
                                         animal: dog, amount: 5)
    create(:character_action, character: @character, subject: location_dogs,
                              created_at: 25.hours.ago)

    res = call_service

    assert_equal 1, res[:animals].length

    pack = res[:animals].find { |p| p[:name] == 'dog' }
    assert pack[:can_attack]
  end
end
