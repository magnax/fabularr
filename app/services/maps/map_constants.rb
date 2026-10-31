# frozen_string_literal: true

module Maps::MapConstants
  ANGLE_SAMPLE_SIZE = 36

  IMAGE_WIDTH = 200
  IMAGE_HEIGHT = 200

  LIGHTHOUSE_DISTANCE = 60
  LIGHTHOUSE_DISTANCE_LIT = 200
  SHIP_TRAIL_SCALE = 0.5
  SHORE_DISTANCE = 16
  UNDOCK_RADIUS = 20

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

  UNDOCK_DIRECTIONS = {
    0 => 'e',
    1 => 'se',
    2 => 's',
    3 => 'sw',
    4 => 'w',
    5 => 'nw',
    6 => 'n',
    7 => 'ne'
  }.freeze
end
