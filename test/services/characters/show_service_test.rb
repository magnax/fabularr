# frozen_string_literal: true

require 'test_helper'

class CharactersShowServiceTest < ActiveSupport::TestCase
  def setup
    GameTime.create!
  end

  def call_service(character, char_id)
    Characters::ShowService.call(character, char_id)
  end

  test 'non existent character' do
    character = create(:character)

    assert_raises Characters::ShowService::InvalidCharacterError do
      call_service(character, 0)
    end
  end

  test 'show info about yourself' do
    location = create(:location)
    GameTime.last.update!(updated_at: GameTime.last.created_at + 2.days)
    spawn_date = GameTime.last.created_at + 2.days
    character = create(:character, gender: 'M', name: 'Magnus',
                                   spawn_location: location, created_at: spawn_date)
    create(:location_name, character: character, location: location, name: 'Klojt')

    res = call_service(character, character.id)

    assert_equal 'Magnus', res['name']
    assert_equal 'He is in his twenties', res['age']
    assert_equal 2, res['spawn_day']
    assert_equal location.id, res['spawn_location_id']
    assert_equal 'Klojt', res['spawn_location_name']
  end

  test 'show info about other' do
    character = create(:character)
    other_character = create(:character, gender: 'M')

    res = call_service(character, other_character.id)

    assert_equal 'unknown man', res['name']
  end

  test 'show info about other (named)' do
    character = create(:character)
    other_character = create(:character, gender: 'M')
    create(:char_name, character: character, named: other_character, name: 'Mosstan')

    res = call_service(character, other_character.id)

    assert_equal 'Mosstan', res['name']
  end
end
