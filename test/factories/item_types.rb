# frozen_string_literal: true

# == Schema Information
#
# Table name: item_types
#
#  id         :bigint           not null, primary key
#  key        :string
#  weight     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :item_type do
    key { Faker::Lorem.word }
  end
end
