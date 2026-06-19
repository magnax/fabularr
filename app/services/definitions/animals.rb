# frozen_string_literal: true

module Definitions::Animals
  CONFIG = [
    { key: 'cat', tamable: true, mountable: false, attack: 2, health: 35, agression: 1 },
    { key: 'dog', tamable: true, mountable: false, attack: 4, health: 45, agression: 2 },
    { key: 'horse', tamable: true, mountable: false, attack: 6, health: 100, agression: 1 },
    { key: 'red_fox', tamable: false, mountable: false, attack: 5, health: 40, agression: 4 },
    { key: 'sheep', tamable: true, mountable: false, attack: 1, health: 85, agression: 0 },
    { key: 'turkey', tamable: true, mountable: false, attack: 1, health: 50, agression: 2 },
    { key: 'zebra', tamable: true, mountable: false, attack: 7, health: 110, agression: 3 }
  ].freeze
end
