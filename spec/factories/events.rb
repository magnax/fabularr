# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    body { 'MyText' }
    location_id { 1 }
    character_id { 1 }
  end
end
