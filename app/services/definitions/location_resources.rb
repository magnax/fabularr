# frozen_string_literal: true

module Definitions::LocationResources
  RESOURCES = {
    beach: %w[sand seaweeds salmon stone],
    desert: %w[mushrooms wood sand],
    fields: %w[strawberries mushrooms nuts coal wood sand beeswax],
    forest: %w[strawberries mushrooms nuts coal wood sand beeswax stone],
    hills: %w[strawberries mushrooms nuts coal wood sand beeswax],
    lakeside: %w[strawberries mushrooms nuts wood sand seaweeds salmon beeswax],
    meadow: %w[strawberries mushrooms nuts coal wood beeswax],
    mountains: %w[mushrooms coal wood],
    swamp: %w[strawberries mushrooms wood beeswax stone],
    tundra: %w[strawberries mushrooms coal wood]
  }.freeze
end
