# frozen_string_literal: true

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  test '#setup' do
    assert_difference -> { Setting.count } => 1 do
      Setting.setup('jobs')
    end

    s = Setting.last
    assert_equal '1', s.value
    assert_equal 'jobs', s.key
  end
end
