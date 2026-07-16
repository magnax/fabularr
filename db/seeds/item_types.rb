# frozen_string_literal: true

items_created = 0
items_updated = 0

Definitions::ItemTypes::CONFIG.each do |c|
  item_class = ItemClass.where(key: c[:item_class]).first_or_create

  attrs = {
    parent_item_type_id: c[:parent] ? ItemType.find_by(key: c[:parent]).id : nil,
    item_class_id: item_class.id
  }

  item = ItemType.find_by(key: c[:key])
  if item
    item.update!(**c.except(:key, :item_class, :parent).merge(attrs))
    items_updated += 1
  else
    ItemType.create!(**c.except(:item_class, :parent).merge(attrs))
    items_created += 1
  end
end
Log.say "ItemTypes: #{items_created} created, #{items_updated} updated"
