# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

module Definitions::Recipes
  RECIPES = [
    {
      key: 'copper#collect',
      instructions: [
        { key: 'tool#pickaxe', speed: 2 },
        { key: 'tool#bronze_pickaxe', speed: 2 }
      ]
    },
    {
      key: 'drop_spindle#machinery',
      base_speed: '1d',
      portable: true,
      skill: 'manufacturing_machines',
      instructions: [
        { key: 'resource#stone', amount: 50 },
        {
          key: 'item#small_shaft', amount: 1,
          options: [
            { key: 'small_wooden_shaft' },
            { key: 'small_bone_shaft' }
          ]
        }
      ]
    },
    {
      key: 'lasso#item',
      base_speed: '2d',
      skill: 'manufacturing_tools',
      instructions: [
        { key: 'resource#string', amount: 500 }
      ]
    },
    {
      key: 'small_bone_shaft#item',
      base_speed: '1d',
      skill: 'carpenting',
      instructions: [
        { key: 'resource#small_bones', amount: 50 },
        { key: 'tool#knife',
          options: [
            { key: 'steel_knife' },
            { key: 'bone_knife' }
          ] }
      ]
    },
    {
      key: 'small_firewood_shaft#item',
      base_speed: '1d',
      skill: 'carpenting',
      instructions: [
        { key: 'resource#firewood', amount: 50 },
        { key: 'tool#knife' }
      ]
    },
    {
      key: 'small_wooden_shaft#item',
      base_speed: '1d',
      skill: 'carpenting',
      instructions: [
        { key: 'resource#wood', amount: 50 },
        { key: 'tool#knife' }
      ]
    },
    {
      key: 'small_fire_pit#machinery',
      # TODO: base_speed is building/collecting time, can be confused with travel speed
      base_speed: 3000,
      placement: 'outside_all',
      skill: 'manufacturing_machines',
      instructions: [
        { key: 'resource#stone', amount: 500 }
      ]
    },
    {
      key: 'small_wooden_cart#vehicle',
      base_speed: 3000,
      instructions: [
        { key: 'resource#wood', amount: 500 }
      ]
    },
    {
      key: 'stone_knife#item',
      base_speed: 3600,
      instructions: [
        { key: 'resource#stone', amount: 100 }
      ]
    },
    {
      key: 'wood#collect',
      instructions: [
        { key: 'tool#stone_knife', speed: 1.2 },
        { key: 'tool#stone_axe', speed: 2 }
      ]
    },
    {
      key: 'wood_shack#building',
      base_speed: 500,
      instructions: [
        { key: 'resource#wood', amount: 100 }
      ]
    }
  ].freeze
end

# rubocop:enable Metrics/ModuleLength
