# frozen_string_literal: true

Definitions::ItemTypes::CONFIG.each do |c|
  ItemClass.where(key: c[:item_class]).first_or_create
  ItemType.where(key: c[:key]).first_or_create(**c.except(:key, :item_class))
end
Log.say "ItemTypes (#{Definitions::ItemTypes::CONFIG.length}) loaded"
