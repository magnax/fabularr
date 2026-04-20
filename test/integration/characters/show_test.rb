# frozen_string_literal: true

require 'test_helper'

class CharactersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, user: @user, name: 'Magnus')
  end

  def sign_in
    visit new_session_url
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
    click_on @character.name
  end

  test 'link to character name on events page' do
    sign_in

    assert_link 'Magnus', href: "#{host}/en/characters/#{@character.id}"
  end

  test 'content for self character on character name page' do
    sign_in
    visit character_url(id: @character.id)

    assert_text 'Current name: Magnus'
  end
end
