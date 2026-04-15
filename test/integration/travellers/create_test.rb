# frozen_string_literal: true

require 'test_helper'

class TravellersCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location, coords: { x: 100, y: 100 })
    @character = create(:character, location: @location, name: 'Magnus', user: @user)
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

  test 'other characters in location are not visible after starting travel' do
    other_character = create(:character, location: @location)

    other_travelling_character = create(:character, location: nil,
                                                    coords: {
                                                      x: 102,
                                                      y: 102
                                                    })
    create(:traveller, subject: other_travelling_character)

    create(:char_name, character: @character, named: other_character, name: 'Sid')
    create(:char_name, character: @character,
                       named: other_travelling_character, name: 'Ella')

    sign_in
    click_link 'Magnus'

    assert_link 'Sid', href: "#{host}/en/characters/#{other_character.id}/name"
    assert_no_link 'Ella', href: "#{host}/en/characters/#{other_travelling_character.id}/name"

    click_link 'Start travel'
    assert_content 'Direction in degrees'
    fill_in 'traveller_direction', with: '45'
    click_on 'Go now!'

    assert_no_link 'Sid', href: "#{host}/en/characters/#{other_character.id}/name"
    assert_link 'Ella', href: "#{host}/en/characters/#{other_travelling_character.id}/name"
  end
end
