# frozen_string_literal: true

require 'test_helper'

class StaticPagesHomeTest < ActionDispatch::IntegrationTest
  test 'home page' do
    visit root_path

    assert_content 'Fabular'
    assert_title 'Fabular main page'
  end
end
