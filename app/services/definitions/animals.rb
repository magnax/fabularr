# frozen_string_literal: true

module Definitions::Animals
  CONFIG = [
    { key: 'cat', tamable: true, mountable: false, pack_size: 30, attack: 4,
      health: 35, agression: 1, armour: 0,
      res: [
        { key: 'feed#meat_feed', amount: 25 },
        { key: 'hunt#fresh_dung', amount: (20..50) },
        { key: 'hunt#meat', amount: (50..150) }
      ] },
    { key: 'dog', tamable: true, mountable: false, pack_size: 30, attack: 4,
      health: 45, agression: 2, armour: 0,
      res: [
        { key: 'feed#meat_feed', amount: 35 },
        { key: 'hunt#fresh_dung', amount: (30..60) },
        { key: 'hunt#meat', amount: (70..160) }
      ] },
    { key: 'horse', tamable: true, mountable: false, pack_size: 30, attack: 6, health: 100, agression: 1, armour: 0,
      res: [
        { key: 'feed#hay', amount: 75 },
        { key: 'feed#vegetable_feed', amount: 75 },
        { key: 'hunt#fresh_dung', amount: (120..150) },
        { key: 'hunt#meat', amount: (250..350) }
      ] },
    { key: 'red_fox', tamable: false, mountable: false, pack_size: 30, attack: 5, health: 40, agression: 4, armour: 0,
      res: [
        { key: 'hunt#fresh_dung', amount: (20..50) },
        { key: 'hunt#meat', amount: (60..130) }
      ] },
    { key: 'sheep', tamable: true, mountable: false, pack_size: 30, attack: 4,
      health: 85, agression: 1, armour: 0,
      res: [
        { key: 'feed#hay', amount: 75 },
        { key: 'gather#milk', amount: 1200 },
        { key: 'gather#wool', amount: 300 },
        { key: 'hunt#fresh_dung', amount: (120..200) },
        { key: 'hunt#large_bones', amount: (220..320) },
        { key: 'hunt#meat', amount: (520..620) },
        { key: 'hunt#milk', amount: (150..210) },
        { key: 'hunt#small_bones', amount: (100..120) },
        { key: 'hunt#wool', amount: (270..320) },
        { key: 'slay#mutton', amount: (1000..1320) },
        { key: 'slay#large_bones', amount: (300..320) },
        { key: 'slay#small_bones', amount: (150..180) },
        { key: 'slay#wool', amount: (270..320) }
      ] },
    { key: 'turkey', tamable: true, mountable: false, pack_size: 30, attack: 1, health: 50, agression: 2, armour: 0,
      res: [
        { key: 'feed#vegetable_feed', amount: 35 },
        { key: 'hunt#fresh_dung', amount: (15..25) },
        { key: 'hunt#meat', amount: (40..60) }
      ] },
    { key: 'zebra', tamable: true, mountable: false, pack_size: 30, attack: 7, health: 110, agression: 3, armour: 0,
      res: [
        { key: 'feed#hay', amount: 75 },
        { key: 'feed#vegetable_feed', amount: 75 },
        { key: 'hunt#fresh_dung', amount: (120..170) },
        { key: 'hunt#meat', amount: (250..330) }
      ] }
  ].freeze
end
