# frozen_string_literal: true

require 'test_helper'

class TravellersStopTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user,
                                    location: nil, coords: { x: 100, y: 100 })
  end

  def sign_in
    visit new_session_url
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
  end

  test 'reverses travel' do
    traveller = create(:traveller, subject: @character, speed: 100, direction: 200)
    sign_in
    click_link 'Magnus'
    click_link 'Reverse'

    assert_equal 20, traveller.reload.direction
  end
end
