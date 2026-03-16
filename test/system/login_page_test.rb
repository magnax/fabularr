# frozen_string_literal: true

require 'test_helper'

class LoginPageTest < ApplicationSystemTest
  test 'visiting the index' do
    visit login_url
    assert_selector 'h1', text: 'Fabular login'
  end
end
