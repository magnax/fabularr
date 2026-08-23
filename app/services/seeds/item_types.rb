# frozen_string_literal: true

module Seeds
  class ItemTypes < ApplicationService
    def initialize
      @items_created = 0
      @items_updated = 0
    end

    def call
      Definitions::ItemTypes::CONFIG.each do |config|
        create_or_update_item!(config)
      end

      Log.say "ItemTypes: #{@items_created} created, #{@items_updated} updated"
    end

    private

    def create_or_update_item!(config)
      attrs = create_attributes!(config)

      item = ItemType.find_by(key: config[:key])
      if item
        item.update!(**attrs.except(:key))
        @items_updated += 1
      else
        ItemType.create!(**attrs)
        @items_created += 1
      end
    end

    def create_attributes!(config)
      item_class = ItemClass.where(key: config[:item_class]).first_or_create

      config.except(:item_class, :parent).merge(
        {
          parent_item_type_id: config[:parent] ? ItemType.find_by(key: config[:parent]).id : nil,
          item_class_id: item_class.id
        }
      )
    end
  end
end
