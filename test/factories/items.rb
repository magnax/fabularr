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
FactoryBot.define do
  factory :item do
    location_id { 1 }
    itemtype_id { 1 }
  end
end
