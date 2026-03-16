# frozen_string_literal: true

require 'test_helper'

class UsersNewTest < ApplicationSystemTest
  test 'register page' do
    visit register_path

    assert_selector 'h1', text: 'Register'
  end

  test 'submit with invalid information' do
    visit register_path

    assert_difference -> { User.count }, 0 do
      click_button 'Create my account'
    end
  end

  test 'submit with valid information - create user' do
    visit register_path

    fill_in 'E-mail', with: 'user@example.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Confirmation', with: 'foobar'

    assert_difference -> { User.count }, 1 do
      click_button 'Create my account'
    end
  end
end
