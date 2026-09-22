# frozen_string_literal: true

require 'test_helper'

class CharactersAttackInfoServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
  end

  def call_service(params)
    Characters::AttackInfoService.call(@character, params)
  end

  test 'raise error when invalid character' do
    params = {
      character_id: 0
    }

    assert_raises Characters::InvalidCharacterError do
      call_service(params)
    end
  end

  test 'raise error when character not in range (ie. in building)' do
    building = create(:location, :building, parent_location: @location)
    other_character = create(:character, location: building)

    params = {
      character_id: other_character.id
    }

    assert_raises Characters::InvalidCharacterError do
      call_service(params)
    end
  end

  test 'can attack character in vehicle in the same location' do
    vehicle = create(:location, :vehicle, parent_location: @location)
    other_character = create(:character, location: vehicle)

    params = {
      character_id: other_character.id
    }

    res = call_service(params)

    assert_equal other_character.id, res[:target_id]
  end

  test 'can attack character in town while being in a vehicle' do
    vehicle = create(:location, :vehicle, parent_location: @location)
    other_character = create(:character, location: @location)
    @character.update!(location: vehicle)

    params = {
      character_id: other_character.id
    }

    res = call_service(params)

    assert_equal other_character.id, res[:target_id]
  end

  test 'can attack character in another vehicle' do
    vehicle_1 = create(:location, :vehicle, parent_location: @location)
    vehicle_2 = create(:location, :vehicle, parent_location: @location)
    other_character = create(:character, location: vehicle_1)
    @character.update!(location: vehicle_2)

    params = {
      character_id: other_character.id
    }

    res = call_service(params)

    assert_equal other_character.id, res[:target_id]
  end

  test 'raise error if target cannot be attacked (less than one day passed)' do
    other_character = create(:character, location: @location)
    create(:character_action, character: @character, subject: other_character,
                              created_at: 23.hours.ago, key: CharacterAction::ATTACK)

    params = {
      character_id: other_character.id
    }

    assert_raises Attacks::Characters::NotEnoughTimeError do
      call_service(params)
    end
  end

  test 'show weapons sorted by attack strength' do
    other_character = create(:character, location: @character.location)
    weapon = create(:tag, key: Tag::WEAPON)

    knife_type = create(:item_type, key: 'knife', attack: 6)
    spear_type = create(:item_type, key: 'bone_spear', attack: 10)

    create(:item_types_tag, item_type: knife_type, tag: weapon)
    create(:item_types_tag, item_type: spear_type, tag: weapon)

    knife = create(:item, item_type: knife_type)
    spear = create(:item, item_type: spear_type)

    create(:inventory_object, character: @character, subject: knife)
    create(:inventory_object, character: @character, subject: spear)

    params = {
      character_id: other_character.id
    }

    res = call_service(params)

    assert_equal 3, res[:weapons].length

    weapon = res[:weapons].first

    assert_equal 'bone_spear', weapon[0]
    assert_equal 10, weapon[1]
  end
end
