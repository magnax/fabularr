# frozen_string_literal: true

include ApplicationHelper

def valid_signin(user)
  fill_in 'E-mail', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Login'
end

def sign_in(user, options = {})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit login_path
    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end
end

def choose_character(character, options = {})
  if options[:no_capybara]
    # Choose character when not using Capybara.
    cookies[:character_token] = character.id
  else
    visit list_path
    click_link 'Magnus'
  end
end
