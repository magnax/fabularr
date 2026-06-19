# frozen_string_literal: true

require 'test_helper'

class SeedsAnimalsTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { Animal.count } => 7 do
      require_relative '../../db/seeds/animals'
    end
  end
end
