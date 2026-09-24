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
require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'model fields' do
    item = build(:item)

    assert_respond_to item, :damage_key
    assert_respond_to item, :weight
    assert_respond_to item, :key
    assert_respond_to item, :tags
  end

  test '#damage_key' do
    assert_equal 'brand_new', build(:item, damage: 0).damage_key
    assert_equal 'new', build(:item, damage: 25.01).damage_key
    assert_equal 'used', build(:item, damage: 50.01).damage_key
    assert_equal 'often_used', build(:item, damage: 63.01).damage_key
    assert_equal 'old', build(:item, damage: 75.01).damage_key
    assert_equal 'crumbling', build(:item, damage: 87.01).damage_key
  end
end
