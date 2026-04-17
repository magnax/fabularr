# frozen_string_literal: true

module Definitions::ProjectTypes
  CONFIG = [
    { key: 'discover_resource', base_speed: 3600, fixed: true },
    { key: 'collect', base_speed: 6, fixed: false },
    { key: 'create_location', base_speed: 600, fixed: true },
    { key: 'build', base_speed: 0, fixed: true }
  ].freeze
end
