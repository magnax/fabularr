# frozen_string_literal: true

require 'test_helper'

class TravellersUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user,
                                    location: nil, coords: { x: 100, y: 100 })
  end

  test 'updates travel' do
    traveller = create(:traveller, subject: @character, speed: 100, direction: 200)
    sign_in(@user)
    click_link 'Magnus'
    fill_in 'traveller_direction', with: '45'
    click_on 'Set'

    assert_equal 45, traveller.reload.direction
  end
end
