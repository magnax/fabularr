# frozen_string_literal: true

# == Schema Information
#
# Table name: item_types
#
#  id         :bigint           not null, primary key
#  attack     :integer          default(0)
#  defense    :integer          default(0)
#  key        :string
#  repair     :integer          default(0)
#  rot        :integer          default(10)
#  rot_use    :integer          default(100)
#  skill      :integer          default(50)
#  visible    :boolean          default(FALSE)
#  weight     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :item_type do
    key { Faker::Lorem.word }
  end
end
