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
end
