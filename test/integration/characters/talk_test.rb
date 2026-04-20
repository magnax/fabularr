# frozen_string_literal: true

require 'test_helper'

class CharactersTalkTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @current_character = create(:character, user: @user, name: 'Magnus')
    @other_character = create(:character, gender: 'K',
                                          location: @current_character.location)
  end

  def sign_in
    visit new_session_url
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
    click_on @current_character.name
  end

  test 'link to character name on events page' do
    sign_in

    assert_link 'Talk', href: "#{host}/en/characters/#{@other_character.id}/talk"
  end

  test 'content for unnamed character on character name page' do
    create(:char_name, character: @current_character,
                       named: @other_character, name: 'Ella')
    sign_in
    visit character_talk_url(character_id: @other_character.id)

    assert_text 'Say something to Ella'
  end
end
