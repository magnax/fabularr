# frozen_string_literal: true

require 'test_helper'

class MapsCalculateCropSlicesServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character, location: nil, coords: { x: 200, y: 300 })
  end

  def call_service
    Maps::CalculateCropSlicesService.call(@character.coords, map)
  end

  def map
    @map ||= Magick::ImageList.new('app/assets/images/map.png')
  end

  test 'proper slices when map wraps around edges' do
    test_data = [
      {
        coords: { x: 200, y: 200 },
        slices: [{ x: 100, y: 100, width: 200, height: 200, left: 0, top: 0 }]
      },
      {
        coords: { x: 110, y: 110 },
        slices: [{ x: 10, y: 10, width: 200, height: 200, left: 0, top: 0 }]
      },
      {
        coords: { x: 888, y: 877 },
        slices: [{ x: 788, y: 777, width: 200, height: 200, left: 0, top: 0 }]
      },
      {
        coords: { x: 100, y: 100 },
        slices: [{ x: 0, y: 0, width: 200, height: 200, left: 0, top: 0 }]
      },
      {
        coords: { x: 20, y: 200 },
        slices: [
          { x: 920, y: 100, width: 80, height: 200, left: 0, top: 0 },
          { x: 0, y: 100, width: 120, height: 200, left: 80, top: 0 }
        ]
      },
      {
        coords: { x: 970, y: 200 },
        slices: [
          { x: 870, y: 100, width: 130, height: 200, left: 0, top: 0 },
          { x: 0, y: 100, width: 70, height: 200, left: 130, top: 0 }
        ]
      },
      {
        coords: { x: 200, y: 10 },
        slices: [
          { x: 100, y: 910, width: 200, height: 90, left: 0, top: 0 },
          { x: 100, y: 0, width: 200, height: 110, left: 0, top: 90 }
        ]
      },
      {
        coords: { x: 200, y: 975 },
        slices: [
          { x: 100, y: 875, width: 200, height: 125, left: 0, top: 0 },
          { x: 100, y: 0, width: 200, height: 75, left: 0, top: 125 }
        ]
      },
      {
        coords: { x: 5, y: 40 },
        slices: [
          { x: 905, y: 940, width: 95, height: 60, left: 0, top: 0 },
          { x: 905, y: 0, width: 95, height: 140, left: 0, top: 60 },
          { x: 0, y: 940, width: 105, height: 60, left: 95, top: 0 },
          { x: 0, y: 0, width: 105, height: 140, left: 95, top: 60 }
        ]
      }
    ]

    test_data.each do |data|
      @character.update!(coords: { x: data[:coords][:x], y: data[:coords][:y] })

      res = call_service

      assert_equal data[:slices].length, res.length

      res.each_with_index do |slice, index|
        assert_equal data[:slices][index][:x], slice[:x]
        assert_equal data[:slices][index][:y], slice[:y]
        assert_equal data[:slices][index][:width], slice[:width]
        assert_equal data[:slices][index][:height], slice[:height]
        assert_equal data[:slices][index][:left], slice[:left]
        assert_equal data[:slices][index][:top], slice[:top]
      end
    end
  end
end
