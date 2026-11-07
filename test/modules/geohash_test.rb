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

  test '#g_encode_value (5bit res., 500x500 area)' do
    res = Geohash.g_encode_value(14, res: 5, max_area: 500)

    assert_equal 5, res.length
    assert_equal '00000', res

    res = Geohash.g_encode_value(487, res: 5, max_area: 500)

    assert_equal 5, res.length
    assert_equal '11111', res
  end

  test '#encode' do
    point = ActiveRecord::Point.new(x: 28, y: 6732)

    res = Geohash.encode(point)
    assert_equal 64, res.length
    assert_equal '0100010001010000100110110011111011010001000100010101101001110101', res
  end

  test '#encode (5bit res. 500x500 area)' do
    point = ActiveRecord::Point.new(x: 14, y: 487)

    res = Geohash.encode(point, res: 5, max_area: 500)
    assert_equal 10, res.length
    assert_equal '0101010101', res
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

  test '#geohash from hash with string keys' do
    point = { 'x' => 28, 'y' => 6732 }

    res = Geohash.geohash(point)
    assert_equal 12, res.length
    assert_equal '8j89qgqj25e7', res
  end

  test '#geohash with 5 bit resolution and 500x500 px area' do
    point = { 'x' => 14, 'y' => 487 }

    res = Geohash.geohash(point, res: 5, max_area: 500)
    assert_equal 2, res.length
    assert_equal 'bp', res
  end

  test 'search prefixes for given radius (radius < resolution)' do
    # with 5 bits and 500x500 px area there are 32 (2^5) "cells"
    # each cell is 500 / 32 = 15.625 px wide.
    # so when we have radius of ie. 15 px we should consider the cell with given point
    # and 8 surrounding minimal cells
    radius = 15

    # point at upper left cell
    res = Geohash.search_prefixes({ x: 14, y: 14 }, radius, res: 5, max_area: 500)

    assert_equal 9, res.length
    assert_equal %w[00 01 02 03 bp br pb pc zz], res.sort

    # point one cell right and down from upper left corner
    res = Geohash.search_prefixes({ x: 24, y: 23 }, radius, res: 5, max_area: 500)

    assert_equal 9, res.length
    assert_equal %w[00 01 02 03 04 06 08 09 0d], res.sort
  end
end
