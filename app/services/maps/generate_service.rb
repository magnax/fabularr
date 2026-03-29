# frozen_string_literal: true

module Maps
  class GenerateService < ApplicationService
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
      draw.circle(100, 100, 97, 100)
      draw.draw(canvas)
      canvas
    end

    def position
      @position ||= { x: coords.x - 100, y: coords.y - 100 }
    end

    def coords
      @coords ||= @character.location.coords
    end

    def full_map
      @full_map ||= Magick::ImageList.new('app/assets/images/map.png')
    end
  end
end
