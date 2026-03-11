# frozen_string_literal: true

require 'test_helper'

class Characters::CreateServiceTest < ActiveSupport::TestCase
  def call_service(user, params)
    Characters::CreateService.call(user, params)
  end

  def setup
    @user = create(:user)
  end

  test 'creates character in an empty location' do
    create(:location)
    params = {
      name: 'Kermit',
      gender: 'M'
    }

    assert_difference(
      -> { Character.count } => 1,
      -> { Event.count } => 3
    ) do
      call_service(@user, params)
    end
  end

  test 'creates character in location with other character' do
    location = create(:location)
    create(:character, spawn_location: location, location: location)

    params = {
      name: 'Kermit',
      gender: 'M'
    }

    assert_difference(
      -> { Character.count } => 1,
      -> { Event.count } => 4
    ) do
      call_service(@user, params)
    end
  end
end
