# frozen_string_literal: true

require 'test_helper'

class CharactersNameTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @current_character = create(:character, user: @user, name: 'Magnus')
    @other_character = create(:character, gender: 'K',
                                          location: @current_character.location)
  end

  def sign_in_character
    sign_in
    click_on @current_character.name
  end

  def create_name_and_sign_in
    create(:char_name, character: @current_character,
                       named: @other_character, name: 'Ella')

    sign_in_character
  end

  test 'link to character name on events page' do
    sign_in_character

    assert_link 'unknown woman'
  end

  test 'content for unnamed character on character name page' do
    sign_in_character
    click_on 'unknown woman'

    assert_text 'Current name: unknown woman'
  end

  test 'change the character name' do
    sign_in_character
    click_on 'unknown woman'

    assert_difference -> { CharName.count }, 1 do
      fill_in 'New name', with: 'Ella'
      click_on 'Change name'
    end

    assert_link 'Ella'
  end

  test 'change the name even if not provided' do
    sign_in_character
    click_on 'unknown woman'

    assert_difference -> { CharName.count }, 1 do
      fill_in 'New name', with: ''
      click_on 'Change name'
    end
  end

  test 'link to named character' do
    create_name_and_sign_in

    assert_link text: 'Ella'
  end

  test 'changes the remembered name' do
    create_name_and_sign_in
    click_on 'Ella'

    assert_text 'Current name: Ella'

    fill_in 'New name', with: 'Not Ella'
    click_on 'Change name'

    assert_link 'Not Ella'
  end

  test 'returns back to default name when blank name provided' do
    create_name_and_sign_in
    click_on 'Ella'

    assert_text 'Current name: Ella'

    fill_in 'New name', with: ''
    click_on 'Change name'

    assert_link 'unknown woman'
  end
end
