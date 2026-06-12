# frozen_string_literal: true

require 'test_helper'

class LoginPageTest < ActionDispatch::IntegrationTest
  test 'visiting the index' do
    visit login_url
    assert_selector 'div.title-bar', text: 'Fabular login'
  end
end
