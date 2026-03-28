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
      @image_data ||= full_map.crop(150, 150, 200, 200).to_blob
    end

    def full_map
      @full_map ||= Magick::ImageList.new('app/assets/images/map.png')
    end
  end
end
