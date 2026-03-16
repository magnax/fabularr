# frozen_string_literal: true

require 'test_helper'

class UsersShowTest < ApplicationSystemTest
  def setup
    @user = create(:user)
    sign_in
  end

  test 'visiting the characters list page' do
    visit list_url
    assert_selector 'h1', text: "Hello #{@user.email}"
  end
end
