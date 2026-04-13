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

  test 'starts new travel' do
    sign_in
    click_link 'Magnus'

    assert_difference -> { Traveller.count } => 1 do
      click_link 'Start travel'
      assert_content 'Direction in degrees'
      fill_in 'traveller_direction', with: '45'
      click_on 'Go now!'
    end
  end
end
