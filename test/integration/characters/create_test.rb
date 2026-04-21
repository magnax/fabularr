# frozen_string_literal: true

require 'test_helper'

class CharactersCreateTest < ActionDispatch::IntegrationTest
  def setup
    create(:location)
    @user = create(:user)
    login(@user)
  end

  test 'creates new character' do
    params = {
      character: {
        name: 'Ginger',
        gender: 'K'
      }
    }

    assert_difference -> { Character.count } => 1 do
      post '/en/characters', params: params
    end

    assert_redirected_to '/en/list'
  end

  test 'too many characters' do
    create_list(:character, 15, { user: @user })

    params = {
      character: {
        name: 'Ginger',
        gender: 'K'
      }
    }

    assert_difference -> { Character.count } => 0 do
      post '/en/characters', params: params
    end

    assert_redirected_to '/en/list'
  end

  test 'invalid data with redirect' do
    params = {
      character: {
        name: '',
        gender: ''
      }
    }

    assert_difference -> { Character.count } => 0 do
      post '/en/characters', params: params
    end

    assert_redirected_to '/?locale=en'
  end

  test 'invalid data with render' do
    ApplicationController.any_instance.expects(:render_new?).returns(true)

    params = {
      character: {
        name: '',
        gender: ''
      }
    }

    assert_difference -> { Character.count } => 0 do
      post '/en/characters', params: params
    end

    assert_response :ok
  end
end
