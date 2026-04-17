# frozen_string_literal: true

require 'test_helper'

class TravellersStopTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user,
                                    location: nil, coords: { x: 100, y: 100 })
  end

  test 'stops travel' do
    traveller = create(:traveller, subject: @character, speed: 100)
    sign_in(@user)
    click_link 'Magnus'
    click_link 'Stop'

    assert_equal 0, traveller.reload.speed
    assert_no_link 'Stop'
    assert_link 'Examine location', href: "#{host}/en/locations/examine"
  end
end
