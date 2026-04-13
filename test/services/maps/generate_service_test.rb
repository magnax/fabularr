# frozen_string_literal: true

require 'test_helper'

class MapsGenerateServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character, location: nil, coords: { x: 200, y: 300 })
  end

  def call_service
    Maps::GenerateService.call(@character)
  end

  test 'works' do
    location = create(:location, coords: { x: 250, y: 250 })
    res = call_service

    assert_equal 'image/png', res[:content_type]
    assert_equal 1, res[:locations].length
    assert_equal location.id, res[:locations].sole
  end
end
