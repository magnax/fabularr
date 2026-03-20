# frozen_string_literal: true

# == Schema Information
#
# Table name: location_resources
#
#  id          :bigint           not null, primary key
#  amount      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer
#  resource_id :integer
#
FactoryBot.define do
  factory :location_resource do
    location_id { 1 }
    resource_id { 1 }
    amount { 1 }
  end
end
