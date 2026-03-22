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
#  item_type_id   :integer
#  placeable_id   :integer
#
class Item < ApplicationRecord
  belongs_to :placeable, polymorphic: true, optional: true
  belongs_to :item_type

  delegate :weight, to: :item_type

  def damage_key
    'brand_new'
  end
end
