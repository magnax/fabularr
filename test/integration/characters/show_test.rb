# frozen_string_literal: true

require 'test_helper'

class CharactersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, user: @user, name: 'Magnus')
    strength = create(:skill, key: 'strength')
    create(:character_skill, character: @character, skill: strength,
                             level: 4, status: false)
  end

  def sign_in_character
    sign_in

    click_on @character.name
  end

  test 'link to character name on events page' do
    sign_in_character

    assert_equal 200, page.status_code
    assert_link 'Magnus', href: "#{host}/en/characters/#{@character.id}"
  end

  test 'raise error for invalid character' do
    sign_in_character
    visit character_url(id: 0)

    assert_equal 200, page.status_code
    assert_text 'Invalid character or character not present'
  end

  test 'content for self character on character name page' do
    sign_in_character
    visit character_url(id: @character.id)

    assert_equal 200, page.status_code
    assert_text 'Current name: Magnus'
  end
end
