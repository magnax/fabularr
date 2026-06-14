# frozen_string_literal: true

module Maps
  class InvalidMapColorError < StandardError; end
  class InvalidPositionError < StandardError; end

  DIRECTIONS = {
    0 => 'n',
    1 => 'n',
    2 => 'nne',
    3 => 'ne',
    4 => 'ene',
    5 => 'e',
    6 => 'ese',
    7 => 'se',
    8 => 'sse',
    9 => 's',
    10 => 'ssw',
    11 => 'sw',
    12 => 'wsw',
    13 => 'w',
    14 => 'wnw',
    15 => 'nw',
    16 => 'nnw'
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

  def self.direction_text(direction)
    I18n.t("directions.#{DIRECTIONS[dir_16(direction)]}")
  end

  def self.dir_16(direction)
    (((direction - 11.5) / 22.5) + 2).to_i % 17
  end

  def self.direction(location_from, location_to)
    ((Math.atan2(
      location_to.y - location_from.y,
      location_to.x - location_from.x
    ) * 180.0 / Math::PI) + 90) % 360
  end

  def self.road_direction(road, location_from)
    location_to_id = [road.location_1_id, road.location_2_id] - [location_from.id]
    location_to = Location.find_by(id: location_to_id)

    direction(location_from, location_to) % 360
  end

  def self.calculate_percent(traveller, road)
    return if traveller.road.blank?
    return unless traveller.road == road

    (traveller.distance / road.distance) * 100
  end

  def self.distance(coords_1, coords_2)
    Math.sqrt(
      (coords_2.y - coords_1.y)**2 +
      (coords_2.x - coords_1.x)**2
    )
  end
end
