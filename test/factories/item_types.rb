# frozen_string_literal: true

# == Schema Information
#
# Table name: item_types
#
#  id                  :bigint           not null, primary key
#  attack              :integer          default(0)
#  defense             :integer          default(0)
#  key                 :string
#  repair              :integer          default(0)
#  rot                 :integer          default(10)
#  rot_use             :integer          default(100)
#  skill               :integer          default(50)
#  virtual             :boolean          default(FALSE)
#  visible             :boolean          default(FALSE)
#  weight              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  item_class_id       :bigint
#  parent_item_type_id :bigint
#
# Indexes
#
#  index_item_types_on_item_class_id        (item_class_id)
#  index_item_types_on_parent_item_type_id  (parent_item_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_class_id => item_classes.id)
#  fk_rails_...  (parent_item_type_id => item_types.id)
#
FactoryBot.define do
  factory :item_type do
    key { Faker::Lorem.word }
  end
end
