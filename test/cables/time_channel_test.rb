# frozen_string_literal: true

require 'test_helper'

class ApplicationCableTimeChannelTest < ActionCable::Channel::TestCase
  tests TimeChannel

  test 'channel' do
    subscribe

    assert subscription.confirmed?
    assert_has_stream 'time_channel'
  end
end
