# frozen_string_literal: true

Definitions::ItemTypes::CONFIG.each do |c|
  ItemType.where(key: c[:key])
          .first_or_create(weight: c[:weight])
end
puts "ItemTypes (#{Definitions::ItemTypes::CONFIG.length}) loaded"
