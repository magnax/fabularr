# frozen_string_literal: true

module Maps
  class InvalidMapColorError < StandardError; end

  def self.location_type(pos_x, pos_y)
    p = full_map.pixel_color(pos_x, pos_y)
    color = p.to_color(Magick::AllCompliance, false, 8).tr('#', '').downcase
    if color.in?(LocationType::HABITABLE_TYPES_COLORS)
      LocationType.find_by(key: LocationType::COLOR_MAP[color])
    elsif color == LocationType::COLOR_WATER
      'water'
    elsif color == LocationType::COLOR_BORDER
      'border'
    else
      raise InvalidMapColorError
    end
  end

  def self.full_map
    @full_map ||= Magick::ImageList.new('app/assets/images/map.png')
  end
end
