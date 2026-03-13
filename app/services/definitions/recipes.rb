# frozen_string_literal: true

module Definitions::Recipes
  RECIPES = [
    {
      key: 'stone_knife',
      base_speed: 3600,
      instructions: [
        { type: 'resource', key: 'stone', amount: 100 }
      ]
    }
  ].freeze
end
