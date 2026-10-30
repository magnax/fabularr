# frozen_string_literal: true

module Maps
  class CalculateCropSlicesService < ApplicationService
    def initialize(coords, map)
      @coords = coords
      @map = map
    end

    def call
      if xslices.length == 1 && yslices.length == 1
        [xslices.first.merge(yslices.first)]
      elsif xslices.length == 1
        merge_1x_2y
      elsif yslices.length == 1
        merge_1y_2x
      else
        combine_4
      end
    end

    private

    def merge_1x_2y
      [
        xslices.first.merge(yslices.first),
        xslices.first.merge(yslices.last)
      ]
    end

    def merge_1y_2x
      [
        xslices.first.merge(yslices.first),
        xslices.last.merge(yslices.first)
      ]
    end

    def combine_4
      [
        xslices.first.merge(yslices.first),
        xslices.first.merge(yslices.last),
        xslices.last.merge(yslices.first),
        xslices.last.merge(yslices.last)
      ]
    end

    def xslices
      @xslices ||= x_slices
    end

    def yslices
      @yslices ||= y_slices
    end

    def x_slices
      # binding.pry

      return full_x_slice unless left_edge? || right_edge?
      return left_slices if left_edge?

      right_slices
    end

    def y_slices
      return full_y_slice unless top_edge? || bottom_edge?
      return top_slices if top_edge?

      bottom_slices
    end

    def left_slices
      [
        {
          x: map_width + offset_x,
          width: -offset_x,
          left: 0
        },
        {
          x: 0,
          width: Maps::IMAGE_WIDTH + offset_x,
          left: -offset_x
        }
      ]
    end

    def right_slices
      [
        {
          x: offset_x,
          width: half_image_width + (map_width - @coords.x),
          left: 0
        },
        {
          x: 0,
          width: Maps::IMAGE_WIDTH - (map_width - offset_x),
          left: half_image_width + (map_width - @coords.x)
        }
      ]
    end

    def full_x_slice
      [
        {
          x: offset_x,
          width: Maps::IMAGE_WIDTH,
          left: 0
        }
      ]
    end

    def full_y_slice
      [
        {
          y: offset_y,
          height: Maps::IMAGE_HEIGHT,
          top: 0
        }
      ]
    end

    def top_slices
      [
        {
          y: map_height + offset_y,
          height: -offset_y,
          top: 0
        },
        {
          y: 0,
          height: Maps::MapConstants::IMAGE_HEIGHT + offset_y,
          top: -offset_y
        }
      ]
    end

    def bottom_slices
      [
        {
          y: offset_y,
          height: half_image_height + (map_height - @coords.y),
          top: 0
        },
        {
          y: 0,
          height: Maps::IMAGE_HEIGHT - (map_height - offset_y),
          top: half_image_height + (map_height - @coords.y)
        }
      ]
    end

    def left_edge?
      offset_x.negative?
    end

    def right_edge?
      offset_x > (map_width - Maps::IMAGE_WIDTH)
    end

    def top_edge?
      offset_y.negative?
    end

    def bottom_edge?
      offset_y > (map_height - Maps::IMAGE_HEIGHT)
    end

    def offset_x
      @offset_x ||= @coords.x - half_image_width
    end

    def offset_y
      @offset_y ||= @coords.y - (Maps::IMAGE_HEIGHT / 2)
    end

    def half_image_width
      @half_image_width ||= Maps::IMAGE_WIDTH / 2
    end

    def half_image_height
      @half_image_height ||= Maps::IMAGE_HEIGHT / 2
    end

    def map_width
      @map_width ||= @map.columns
    end

    def map_height
      @map_height ||= @map.rows
    end
  end
end
