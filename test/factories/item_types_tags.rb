# frozen_string_literal: true

# == Schema Information
#
# Table name: item_types_tags
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  item_type_id :bigint
#  tag_id       :bigint
#
# Indexes
#
#  index_item_types_tags_on_item_type_id  (item_type_id)
#  index_item_types_tags_on_tag_id        (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_type_id => item_types.id)
#  fk_rails_...  (tag_id => tags.id)
#
FactoryBot.define do
  factory :item_types_tag do
    item_type
    tag
  end
end
