# frozen_string_literal: true

module Definitions::ItemTypes
  CONFIG = [
    { key: 'bone_knife', item_class: 'tool',
      weight: 100, rot: 30, rot_use: 200, repair: 0,
      attack: 10, defense: 0, skill: 75, visible: false },
    { key: 'iron_shield', item_class: 'protection',
      weight: 300, rot: 5, rot_use: 25, repair: 280,
      attack: 0, defense: 28, skill: 0, visible: true },
    { key: 'stone_knife', item_class: 'tool',
      weight: 100, rot: 30, rot_use: 200, repair: 0,
      attack: 10, defense: 0, skill: 75, visible: false },
    { key: 'small_wooden_shaft', item_class: 'semi',
      weight: 50, rot: 0, rot_use: 0, repair: 0,
      attack: 3, defense: 0, skill: 50, visible: false }
  ].freeze
end
