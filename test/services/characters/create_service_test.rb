# frozen_string_literal: true

require 'test_helper'

class Characters::CreateServiceTest < ActiveSupport::TestCase
  def call_service(user, params)
    Characters::CreateService.call!(user, params)
  end

  def setup
    @user = create(:user)
    create(:location)
  end

  test 'works' do
    params = {
      name: 'Kermit',
      gender: 'M'
    }

    assert_difference -> { Character.count }, 1 do
      assert_difference -> { Event.count }, 2 do
        call_service(@user, params)
      end
    end

    # assert_equal
  end
end
