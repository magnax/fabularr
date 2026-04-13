# frozen_string_literal: true

require 'test_helper'

class TravellersCreateTest < ActionDispatch::IntegrationTest
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

  test 'updates travel' do
    traveller = create(:traveller, subject: @character, speed: 100, direction: 200)
    sign_in
    click_link 'Magnus'
    fill_in 'traveller_direction', with: '45'
    click_on 'Set'

    assert_equal 45, traveller.reload.direction
  end
end
