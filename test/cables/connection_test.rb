# frozen_string_literal: true

require 'test_helper'

class ActionCableConnectionTest < ActionCable::Connection::TestCase
  tests ApplicationCable::Connection

  test 'connect' do
    user = create(:user)
    s = Session.create!(user_id: user.id)
    cookies.signed[:session_id] = s.id

    connect

    assert_equal user.id, connection.current_user.id
  end

  test 'exception when unauthorized user' do
    assert_reject_connection { connect }
  end
end
