# frozen_string_literal: true

require 'test_helper'

class GeohashTest < ActiveSupport::TestCase
  test '#g_encode_value' do
    res = Geohash.g_encode_value(28)

    assert_equal 32, res.length
    assert_equal '00000000101101111000000000110100', res

    res = Geohash.g_encode_value(6732)

    assert_equal 32, res.length
    assert_equal '10101100010101101101010111001111', res
  end

  test '#encode' do
    point = ActiveRecord::Point.new(x: 28, y: 6732)

    res = Geohash.encode(point)
    assert_equal 64, res.length
    assert_equal '0100010001010000100110110011111011010001000100010101101001110101', res
  end

  test '#geohash from point (coords)' do
    point = ActiveRecord::Point.new(x: 28, y: 6732)

    res = Geohash.geohash(point)
    assert_equal 12, res.length
    assert_equal '8j89qgqj25e7', res
  end

  test '#geohash from plain hash' do
    point = { x: 28, y: 6732 }

    res = Geohash.geohash(point)
    assert_equal 12, res.length
    assert_equal '8j89qgqj25e7', res
  end
end
