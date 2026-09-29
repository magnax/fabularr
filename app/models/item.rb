# frozen_string_literal: true

# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  damage         :float            default(0.0)
#  placeable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_class_id  :bigint
#  item_type_id   :integer
#  placeable_id   :integer
#
# Indexes
#
#  index_items_on_item_class_id  (item_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_class_id => item_classes.id)
#
class Item < ApplicationRecord
  STRUCTURE_POINTS = {
    2500 => 'brand_new',
    5000 => 'new',
    6300 => 'used',
    7500 => 'often_used',
    8700 => 'old',
    10_000 => 'crumbling'
  }.freeze

  belongs_to :placeable, polymorphic: true, optional: true
  belongs_to :item_type

  delegate :attack, to: :item_type
  delegate :key, to: :item_type
  delegate :tags, to: :item_type
  delegate :weight, to: :item_type

  scope :weapon, -> { joins(:item_type).merge(ItemType.weapon) }
  scope :protection, -> { joins(:item_type).merge(ItemType.protection) }

  def damage_key
    STRUCTURE_POINTS.filter { |k, _v| k > damage }.first[1]
  end
end
