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

  test 'show weapons sorted by attack strength' do
    dog = create(:animal, key: 'dog')
    create(:animal_pack, location: @character.location, animal: dog)
    weapon = create(:tag, key: Tag::WEAPON)

    knife_type = create(:item_type, key: 'knife', attack: 6)
    spear_type = create(:item_type, key: 'bone_spear', attack: 10)

    create(:item_types_tag, item_type: knife_type, tag: weapon)
    create(:item_types_tag, item_type: spear_type, tag: weapon)

    knife = create(:item, item_type: knife_type)
    spear = create(:item, item_type: spear_type)

    create(:inventory_object, character: @character, subject: knife)
    create(:inventory_object, character: @character, subject: spear)

    res = call_service

    assert_equal 3, res[:weapons].length

    weapon = res[:weapons].first

    assert_equal 'bone_spear', weapon[0]
    assert_equal 10, weapon[1]
  end
end
