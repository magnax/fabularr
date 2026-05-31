# frozen_string_literal: true

module Definitions::Recipes
  RECIPES = [
    {
      key: 'small_fire_pit',
      type: 'machinery',
      # TODO: base_speed is building/collecting time, can be confused with travel speed
      base_speed: 3000,
      placement: 'outside_all',
      instructions: [
        { type: 'resource', key: 'stone', amount: 500 }
      ]
    },
    {
      key: 'small_wooden_cart',
      type: 'vehicle',
      base_speed: 3000,
      instructions: [
        { type: 'resource', key: 'wood', amount: 500 }
      ]
    },
    {
      key: 'stone_knife',
      type: 'item',
      base_speed: 3600,
      instructions: [
        { type: 'resource', key: 'stone', amount: 100 }
      ]
    },
    {
      key: 'wooden_shaft',
      type: 'item',
      base_speed: 3600,
      instructions: [
        { type: 'resource', key: 'wood', amount: 80 },
        { type: 'tool', key: 'stone_knife' }
      ]
    },
    {
      key: 'wood',
      type: 'collect',
      base_speed: nil,
      instructions: [
        { type: 'tool', key: 'stone_knife', speed: 1.2 },
        { type: 'tool', key: 'stone_axe', speed: 2 }
      ]
    },
    {
      key: 'wood_shack',
      type: 'building',
      base_speed: 500,
      instructions: [
        { type: 'resource', key: 'wood', amount: 100 }
      ]
    }
  ].freeze
end
