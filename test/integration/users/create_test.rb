# frozen_string_literal: true

require 'test_helper'

class UsersCreateTest < ActionDispatch::IntegrationTest
  test 'can create new user' do
    visit register_url

    assert_difference -> { User.count } => 1 do
      fill_in 'E-mail', with: 'a@a.eu'
      fill_in 'Password', with: '12345678'
      fill_in 'Confirmation', with: '12345678'
      click_on 'Create my account'
    end
  end
end
