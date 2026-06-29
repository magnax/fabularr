# frozen_string_literal: true

module Maps
  class GenerateService < ApplicationService
    IMAGE_WIDTH = 200
    IMAGE_HEIGHT = 200

    def initialize(character, params = {})
      @character = character
      @params = params
    end

    def call
      {
        data: image_data,
        content_type: 'image/png',
        locations: locations.pluck(:id)
      }
    end

    private

    def image_data
      @image_data ||= result.to_blob { |b| b.format = 'PNG' }
    end

    def result
      canvas = full_map.first.crop(
        position[:x], position[:y], IMAGE_WIDTH, IMAGE_HEIGHT
      )
      base = Magick::Image.new(canvas.columns, canvas.rows)
      canvas = base.composite(canvas, 0, 0, Magick::OverCompositeOp)

      draw = Magick::Draw.new
      draw_locations(draw, canvas)
      draw_character(draw, canvas)
      canvas
    end

    def draw_character(draw, canvas)
      draw.fill(@character.travelling? ? 'yellow' : 'black')
      draw.stroke(@character.travelling? ? 'black' : 'none')
      draw.circle(100, 100, 97, 100)
      if @params[:for] == 'road'
        draw.fill('none')
        draw.stroke('red')
        draw.circle(100, 100, 95, 100)
      end
      draw.draw(canvas)
    end

    # TODO: not tested!
    def draw_locations(draw, canvas)
      return if locations.empty?

      locations.each do |location|
        x = location.x - position[:x]
        y = location.y - position[:y]
        draw_position(draw, x, y)
        draw_index(draw, location, x, y) if show_indexes?
      end
      draw.draw(canvas)
    end

    def show_indexes?
      @show_indexes ||= @params[:for] == 'road' && @params[:order].is_a?(Array)
    end

    def locations
      @locations ||= Location.where(
        'coords[0] > ? and coords[0] < ? and coords[1] > ? and coords[1] < ?',
        position[:x], position[:x] + IMAGE_WIDTH, position[:y], position[:y] + IMAGE_HEIGHT
      )
    end

    def draw_index(draw, location, pos_x, pos_y)
      index = @params[:order].index(location.id.to_s)
      return if index.blank?

      draw.stroke('none')
      draw.fill('black')
      draw.font_weight(Magick::NormalWeight)
      draw.pointsize(14)
      draw.font_style(Magick::NormalStyle)
      pos_y += 20 if pos_y < 20
      pos_x += 20 if pos_x < 20
      draw.text(pos_x - 10, pos_y - 3, (index + 1).to_s)
    end

    def draw_position(draw, pos_x, pos_y)
      draw.circle(pos_x, pos_y, pos_x - 3, pos_y)
    end

    def position
      @position ||= { x: coords.x - 100, y: coords.y - 100 }
    end

    def coords
      @coords ||= @character.coords || @character.toplevel_location.coords
    end

    def full_map
      @full_map ||= Magick::ImageList.new('app/assets/images/map.png')
    end
  end
end
