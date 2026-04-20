# frozen_string_literal: true

require 'test_helper'

class ApplicationCableLocationChannelTest < ActionCable::Channel::TestCase
  tests LocationChannel

  test 'channel' do
    user = create(:user)
    stub_connection(current_user: user)

    subscribe location_id: 1

    assert subscription.confirmed?
    assert_has_stream 'location_1'
  end
end
