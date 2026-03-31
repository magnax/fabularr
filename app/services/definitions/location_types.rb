# frozen_string_literal: true

module Definitions::LocationTypes
  CONFIG_TOWNS = %w[
    beach desert fields forest hills lakeside meadow mountains swamp tundra
  ].freeze

  CONFIG_BUILDINGS =
    {
      'wood_shack' => { max_capacity: 400_000, max_characters: 4 }
    }.freeze
end
