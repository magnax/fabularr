# frozen_string_literal: true

module Definitions::LocationResources # rubocop:disable Metrics/ModuleLength
  CONFIG = {
    beach: {
      min: 2, max: 4,
      raw_food: {
        min: 1, max: 1,
        resources: %w[seaweeds]
      },
      mandatory: {
        min: 1, max: 1,
        resources: %w[sand]
      },
      available: {
        resources: %w[cod gold limestone mud obsidian oil pearls pike salt
                      seashells soda]
      }
    },
    desert: {
      min: 2, max: 3,
      raw_food: {
        min: 1, max: 1,
        resources: %w[spinach]
      },
      mandatory: {
        min: 1,
        max: 2,
        resources: %w[sand]
      },
      available: {
        resources: %w[limestone soda]
      }
    },
    fields: {
      min: 4,
      max: 11,
      raw_food: {
        min: 1,
        max: 3,
        resources: %w[carrots potatoes rice]
      },
      mandatory: {
        min: 2,
        max: 4,
        resources: %w[grass firewood]
      },
      available: {
        resources: %w[coal hematite limestone]
      }
    },
    forest: {
      min: 3,
      max: 10,
      raw_food: {
        min: 1,
        max: 3,
        resources: %w[spinach olives]
      },
      mandatory: {
        min: 1,
        max: 1,
        resources: %w[firewood]
      },
      available: {
        resources: %w[lumber coal hematite limestone]
      }
    },
    hills: {
      min: 4,
      max: 12,
      raw_food: {
        min: 2,
        max: 3,
        resources: %w[carrots potatoes]
      },
      mandatory: {
        min: 1,
        max: 4,
        resources: %w[firewood grass]
      },
      available: {
        resources: %w[sage thyme roses]
      }
    },
    lakeside: {
      min: 5,
      max: 8,
      raw_food: {
        min: 2,
        max: 3,
        resources: %w[carrots potatoes rice]
      },
      mandatory: {
        min: 1,
        max: 2,
        resources: %w[firewood grass]
      },
      available: {
        resources: %w[rye roses sage spinach]
      }
    },
    meadow: {
      min: 3,
      max: 7,
      raw_food: {
        min: 1,
        max: 3,
        resources: %w[carrots potatoes rice]
      },
      mandatory: {
        min: 1,
        max: 2,
        resources: %w[grass firewood]
      },
      available: {
        resources: %w[roses sage rye]
      }
    },
    mountains: {
      min: 1,
      max: 3,
      raw_food: {
        min: 0,
        max: 0, # there can be no food in this biom
        resources: %w[]
      },
      mandatory: {
        min: 1,
        max: 1,
        resources: %w[stone]
      },
      available: {
        resources: %w[gold silver diamonds chromium cobalt emerald mushrooms
                      nickel olives taconite salmon rainbow_trout]
      }
    },
    swamp: {
      min: 4,
      max: 6,
      raw_food: {
        min: 1,
        max: 3,
        resources: %w[carrots potatoes rice]
      },
      mandatory: {
        min: 2,
        max: 3,
        resources: %w[firewood mud]
      },
      available: {
        resources: %w[grass soda]
      }
    },
    tundra: {
      min: 3,
      max: 7,
      raw_food: {
        min: 1,
        max: 2,
        resources: %w[carrots potatoes]
      },
      mandatory: {
        min: 1,
        max: 2,
        resources: %w[firewood]
      },
      available: {
        resources: %w[mud grass]
      }
    }
  }.freeze
end
