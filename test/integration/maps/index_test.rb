# frozen_string_literal: true

require 'test_helper'

class MapsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@character)
  end

  test 'show page' do
    get '/maps'

    assert_response :ok

    assert_equal 'image/png', response.content_type
  end
end
