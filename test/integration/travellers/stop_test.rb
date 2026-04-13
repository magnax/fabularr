# frozen_string_literal: true

require 'test_helper'

class TravellersStopTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
  end

  def sign_in
    visit new_session_url
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
  end

  test 'stops travel' do
    traveller = create(:traveller, subject: @character, speed: 100)
    sign_in
    click_link 'Magnus'
    click_link 'Stop'

    assert_equal 0, traveller.reload.speed
  end
end
