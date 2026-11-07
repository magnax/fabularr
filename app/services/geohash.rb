# frozen_string_literal: true

module Geohash
  MIN_VAL = 0
  MAX_VAL = 10_000

  LETTERS = '0123456789bcdefghjkmnpqrstuvwxyz'

  def self.geohash(coords, res: 32, max_area: MAX_VAL)
    ar = encode(coords, res:, max_area:).split('')

    length = ((res * 2) / 5) * 5
    translate(ar, length)
  end

  def self.translate(value, length)
    value
      .first(length).each_slice(5).map do |slice|
      LETTERS[slice.join.to_i(2)]
    end.join
  end

  def self.interleave(val_x, val_y)
    val_x.split('').map.with_index { |v, i| "#{v}#{val_y[i]}" }.join
  end

  def self.encode(coords, res: 32, max_area: MAX_VAL)
    coords = coords.to_h.with_indifferent_access

    x = g_encode_value(coords[:x], res:, max_area:)
    y = g_encode_value(coords[:y], res:, max_area:)

    interleave(x, y)
  end

  def self.g_encode_value(value, res: 32, max_area: MAX_VAL)
    map_vals(value, res:, max_area:).join('')
  end

  def self.map_vals(value, res: 32, max_area: MAX_VAL)
    vals = init_vals(max_area)

    (0..(res - 1)).map do
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

  def self.init_vals(max_area = MAX_VAL)
    [MIN_VAL, (MIN_VAL + max_area) / 2, max_area].map(&:to_f)
  end

  def self.search_prefixes(coords, _radius, res: 32, max_area: MAX_VAL)
    length = ((res * 2) / 5) * 5
    values = {
      x: g_encode_value(coords[:x], res:, max_area:),
      y: g_encode_value(coords[:y], res:, max_area:)
    }

    [
      [-1, -1], [0, -1], [1, -1],
      [-1, 0],  [0, 0],  [1, 0],
      [-1, 1],  [0, 1],  [1, 1]
    ].map do |dx, dy|
      translate(calculate_prefix(values, dx, dy), length)
    end
  end

  def self.calculate_prefix(values_hash, d_x, d_y)
    px = ((values_hash[:x].to_i + d_x) + 32) % 32
    py = ((values_hash[:y].to_i + d_y) + 32) % 32

    px = "00000#{px.to_s(2)}".slice(-5, 5)
    py = "00000#{py.to_s(2)}".slice(-5, 5)

    interleave(px, py).split('')
  end
end
