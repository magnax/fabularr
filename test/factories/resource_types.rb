# frozen_string_literal: true

# == Schema Information
#
# Table name: resource_types
#
#  id         :bigint           not null, primary key
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :resource_type do
    key { 'sand' }
  end
end
