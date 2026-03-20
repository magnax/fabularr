# frozen_string_literal: true

# == Schema Information
#
# Table name: location_types
#
#  id         :bigint           not null, primary key
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :location_type do
    key { 'forest' }
  end
end
