# frozen_string_literal: true

module Geohash
  MIN_VAL = 0
  MIDDLE_VAL = 5000
  MAX_VAL = 10_000

  LETTERS = '0123456789bcdefghjkmnpqrstuvwxyz'

  def self.geohash(coords)
    ar = encode(coords).split('')

    ar.first(60).each_slice(5).map do |slice|
      LETTERS[slice.join.to_i(2)]
    end.join
  end

  def self.encode(coords)
    coords = coords.to_h

    x = g_encode_value(coords[:x])
    y = g_encode_value(coords[:y])

    x.split('').map.with_index { |v, i| "#{v}#{y[i]}" }.join
  end

  def self.g_encode_value(value)
    map_vals(value).join('')
  end

  def self.map_vals(value)
    vals = [MIN_VAL, MIDDLE_VAL, MAX_VAL].map(&:to_f)

    (0..31).map do
      if value < vals[1]
        vals[2] = vals[1]
        b = 0
      else
        vals[0] = vals[1]
        b = 1
      end
      vals[1] = (vals[2] + vals[0]) / 2

      b
    end
  end
end
