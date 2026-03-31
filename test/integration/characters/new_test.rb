# frozen_string_literal: true

require 'test_helper'

class CharactersNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    sign_in
  end

  def sign_in
    visit new_session_url
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
  end

  test 'visiting the characters list page' do
    visit list_url
    click_on 'Create new character'

    assert_current_path new_character_path(locale: 'en')
    assert_selector 'h1', text: 'New character'
  end

  test 'actually creating a character' do
    visit list_url
    assert_text "You don't have any characters"
    click_on 'Create new character'

    fill_in 'Name', with: 'Magnus'
    select('female', from: 'Gender')

    click_on 'Create character'
    assert_text 'New character successfully created'
    assert_text 'Your characters (1)'
  end

  test 'cannot create more than 15 characters' do
    create_list(:character, 15, { user: @user })

    visit list_url
    assert_text 'Your characters (15)'
    assert_text 'You cannot create more characters'

    assert_no_link 'Create new character'
  end
end
