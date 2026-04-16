# frozen_string_literal: true

require 'test_helper'

class TravellersStopTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user,
                                    location: nil, coords: { x: 100, y: 100 })
  end

  test 'reverses travel' do
    traveller = create(:traveller, subject: @character, speed: 100, direction: 200)
    sign_in(@user)
    click_link 'Magnus'
    click_link 'Reverse'

    assert_equal 20, traveller.reload.direction
  end
end
