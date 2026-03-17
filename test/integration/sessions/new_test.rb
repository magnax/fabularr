# frozen_string_literal: true

require 'test_helper'

class SessionsNewTest < ActionDispatch::IntegrationTest
  test 'login page' do
    visit login_path

    assert_text 'Fabular login'
  end
end
