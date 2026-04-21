# frozen_string_literal: true

require 'test_helper'

class UsersUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    login(@user)
  end

  test 'update user password' do
    params = {
      user: {
        password: '1234567',
        password_confirmation: '1234567'
      }
    }

    put "/en/users/#{@user.id}", params: params

    assert_redirected_to '/en/list'
  end

  test 'update - invalid data' do
    params = {
      user: {
        password: '43434',
        password_confirmation: ''
      }
    }

    put "/en/users/#{@user.id}", params: params

    assert_redirected_to '/?locale=en'
  end

  test 'update - invalid user' do
    params = {
      user: {
        password: '43434',
        password_confirmation: ''
      }
    }

    put '/en/users/0', params: params

    assert_redirected_to '/?locale=en'
  end
end
