# frozen_string_literal: true

require 'test_helper'

class TravellersNewTest < ActionDispatch::IntegrationTest
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

  test 'travellers info' do
    traveller = create(:traveller, subject: @character)
    sign_in
    click_link 'Magnus'

    assert_content 'Travelling from unnamed place'
    assert_link 'Stop', href: "#{host}/en/travellers/#{traveller.id}/stop"
    assert_link 'Reverse', href: "#{host}/en/travellers/#{traveller.id}/reverse"
  end
end
