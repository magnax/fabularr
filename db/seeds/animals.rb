# frozen_string_literal: true

Definitions::Animals::CONFIG.each do |animal|
  Animal.where(key: animal[:key]).first_or_create(**animal.except(:key))
end

Log.say "ItemTypes (#{Definitions::Animals::CONFIG.length}) loaded"
