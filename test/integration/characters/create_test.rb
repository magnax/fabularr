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
end
