# frozen_string_literal: true

require 'test_helper'

class Characters::CreateServiceTest < ActiveSupport::TestCase
  def call_service(user, params)
    Characters::CreateService.call(user, params)
  end

  def setup
    DatabaseCleaner.start
    @user = create(:user)
    @location = create(:location)
  end

  def teardown
    DatabaseCleaner.clean
  end

  test 'creates character in an empty location' do
    params = {
      name: 'Kermit',
      gender: 'M'
    }

    assert_difference -> { Character.count }, 1 do
      assert_difference -> { Event.count }, 2 do
        call_service(@user, params)
      end
    end
  end

  test 'creates character in location with other character' do
    create(:character, location: @location)

    params = {
      name: 'Kermit',
      gender: 'M'
    }

    assert_difference -> { Character.count }, 1 do
      assert_difference -> { Event.count }, 3 do
        call_service(@user, params)
      end
    end
  end
end
