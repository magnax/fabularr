# frozen_string_literal: true

require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
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
    assert_selector 'h1', text: "Hello #{@user.email}"
  end

  test 'proper gender info for character' do
    create(:character, user: @user, gender: 'M')

    visit list_url

    assert_selector 'i.fa-mars'
  end

  test 'show admin menu when logged as admin' do
    @user.update!(god: true)

    visit list_url

    assert_link 'Admin', href: "#{host}/admin?locale=en"
  end
end
