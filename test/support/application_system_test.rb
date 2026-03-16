# frozen_string_literal: true

class ApplicationSystemTest < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def sign_in
    visit new_session_url
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
  end
end
