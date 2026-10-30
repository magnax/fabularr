# frozen_string_literal: true

module Maps
  class GenerateService < ApplicationService
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
      canvas = Magick::Image.new(Maps::IMAGE_WIDTH, Maps::IMAGE_HEIGHT)

      Maps::CalculateCropSlicesService.call(coords, full_map).each do |crop_slice|
        canvas = composite_canvas(crop_slice, canvas)
      end

      draw = Magick::Draw.new
      draw_locations(draw, canvas)
      draw_sail_speed(draw, canvas)
      draw_character(draw, canvas)
      canvas
    end

    def composite_canvas(slice, base)
      canvas = full_map.first.crop(
        slice[:x], slice[:y], slice[:width], slice[:height]
      )
      base.composite(
        canvas, slice[:left], slice[:top], Magick::OverCompositeOp
      )
    end

    def draw_character(draw, canvas)
      draw.fill(@character.travelling? ? 'yellow' : 'black')
      draw.stroke(@character.travelling? ? 'black' : 'none')
      draw.circle(
        half_image_width, half_image_height,
        half_image_width - 3, half_image_height
      )
      if @params[:for] == 'road'
        draw.fill('none')
        draw.stroke('red')
        draw.circle(
          half_image_width, half_image_height,
          half_image_width - 5, half_image_height
        )
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

    def draw_sail_speed(draw, canvas)
      return unless ship?
      return if traveller.speed.zero?

      new_coords = calculate_ship_trail

      draw.stroke('black')
      draw.line(
        half_image_width, half_image_height,
        new_coords[:x] + half_image_width, new_coords[:y] + half_image_height
      )
      draw.draw(canvas)
    end

    def calculate_ship_trail
      direction = (traveller.direction + 180) % 360
      length = (traveller.base_speed || 0) *
               (traveller.speed / 100) *
               Maps::SHIP_TRAIL_SCALE

      angle = direction * (Math::PI / 180)
      { x: (Math.cos(angle) * length), y: (Math.sin(angle) * length) }
    end

    def ship?
      @character.travelling? && @character.location&.ship?
    end

    def show_indexes?
      @show_indexes ||= @params[:for] == 'road' && @params[:order].is_a?(Array)
    end

    def locations
      @locations ||= Location.where(
        'coords[0] > ? and coords[0] < ? and coords[1] > ? and coords[1] < ?',
        position[:x], position[:x] + Maps::IMAGE_WIDTH,
        position[:y], position[:y] + Maps::IMAGE_HEIGHT
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

    def traveller
      @traveller = @character.traveller
    end

    def position
      @position ||= { x: coords.x - half_image_width, y: coords.y - half_image_height }
    end

    def half_image_width
      @half_image_width ||= Maps::IMAGE_WIDTH / 2
    end

    def half_image_height
      @half_image_height ||= Maps::IMAGE_HEIGHT / 2
    end

    def coords
      @coords ||= @character.coords || @character.toplevel_location.coords
    end

    def full_map
      @full_map ||= Magick::ImageList.new('app/assets/images/map.png')
    end
  end
end
