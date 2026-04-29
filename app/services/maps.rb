# frozen_string_literal: true

module Maps
  class InvalidMapColorError < StandardError; end
  class InvalidPositionError < StandardError; end

  DIRECTIONS = {
    1 => 'e',
    2 => 'ese',
    3 => 'se',
    4 => 'sse',
    5 => 's',
    6 => 'ssw',
    7 => 'sw',
    8 => 'wsw',
    9 => 'w',
    10 => 'wnw',
    11 => 'nw',
    12 => 'nnw',
    13 => 'n',
    14 => 'nne',
    15 => 'ne',
    16 => 'ene'
  }.freeze

  def self.location_type(pos_x, pos_y)
    raise InvalidPositionError if invalid_data(full_map, pos_x, pos_y)

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

  def self.invalid_data(full_map, pos_x, pos_y)
    pos_x.negative? || pos_y.negative? ||
      pos_x > full_map.columns || pos_y > full_map.rows
  end

  def self.full_map
    @full_map ||= Magick::ImageList.new('app/assets/images/map.png').first
  end

  def self.locations_direction_text(location_from, location_to)
    direction_text(direction(location_from, location_to))
  end

  def self.dir_16(direction)
    (((direction - 11.5) / 22.5) + 2).to_i % 17
  end

  def self.direction_text(direction)
    I18n.t("directions.#{DIRECTIONS[dir_16(direction)]}")
  end

  def self.direction(location_from, location_to)
    ((Math.atan2(
      location_to.y - location_from.y,
      location_to.x - location_from.x
    ) * 180.0 / Math::PI) + 360) % 360
  end
end
