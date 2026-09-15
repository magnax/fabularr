# frozen_string_literal: true

require 'test_helper'

class ApiCharactersNameTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)
    @other_character = create(:character, location: @location)

    login(user, @character)
  end

  def name_route(character_id)
    "/api/characters/#{character_id}/name"
  end

  test 'returns content' do
    get name_route(@other_character.id)

    assert_response :ok

    res = response.parsed_body.to_s
    assert_includes res, 'Damage: 0%'
    assert_includes res, 'Current name:'
  end
end
