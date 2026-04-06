# frozen_string_literal: true

require 'test_helper'

class SessionsCreateTest < ActionDispatch::IntegrationTest
  test 'login - with invalid information' do
    visit login_path
    click_on 'Login'

    assert_text 'Fabular login'
    assert_selector('div.alert.alert-error', text: 'Invalid username or password')
  end

  test 'login - with valid credentials' do
    user = create(:user)
    visit login_path

    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Login'

    assert_content("Hello #{user.email}")
    assert_content("You don't have any characters")
    assert_link('Profile', href: "#{host}/en/list")
    assert_link('Logout', href: "#{host}/en/logout")
    assert_no_link('Login')
  end

  test 'login followed by logout' do
    user = create(:user)
    visit login_path

    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Login'

    assert_content("Hello #{user.email}")
    assert_no_link 'Login'

    click_on 'Logout'

    assert_link 'Login'
    assert_no_link 'Logout'
  end

  test 'list characters - redirect not signed in user' do
    create(:user)

    visit list_url

    assert_content 'Fabular login'
  end

  test 'edit user - redirect not signed in user' do
    user = create(:user)

    visit edit_user_url(id: user.id)

    assert_content 'Fabular login'
  end
end
