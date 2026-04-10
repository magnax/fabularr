# frozen_string_literal: true

module Maps
  class GenerateService < ApplicationService
    IMAGE_WIDTH = 200
    IMAGE_HEIGHT = 200

    def initialize(character)
      @character = character
    end

    def call
      {
        data: image_data,
        content_type: 'image/png'
      }
    end

    private

    def image_data
      @image_data ||= result.to_blob
    end

    def result
      canvas = full_map.crop(position[:x], position[:y], 200, 200)
      draw = Magick::Draw.new
      draw_locations(draw, canvas)
      draw_character(draw, canvas)
      canvas
    end

    def draw_character(draw, canvas)
      draw.fill(@character.travelling? ? 'yellow' : 'black')
      draw.stroke(@character.travelling? ? 'black' : 'none')
      draw.circle(100, 100, 97, 100)
      draw.draw(canvas)
    end

    def draw_locations(draw, canvas)
      draw.fill('black')
      locations.each do |location|
        draw_position(draw, location.coords, position[:x], position[:y])
      end
      draw.draw(canvas)
    end

    def locations
      @locations ||= Location.where(
        'coords[0] > ? and coords[0] < ? and coords[1] > ? and coords[1] < ?',
        position[:x], position[:y], position[:x] + IMAGE_WIDTH, position[:y] + IMAGE_HEIGHT
      )
    end

    def draw_position(draw, coords, offset_x, offset_y)
      draw.circle(
        coords.x - offset_x,
        coords.y - offset_y,
        coords.x - offset_x - 3,
        coords.y - offset_y
      )
    end

    def position
      @position ||= { x: coords.x - 100, y: coords.y - 100 }
    end

    def coords
      @coords ||= @character.coords || @character.location.coords
    end

    def full_map
      @full_map ||= Magick::ImageList.new('app/assets/images/map.png')
    end
  end
end
