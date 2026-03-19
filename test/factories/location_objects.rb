# frozen_string_literal: true

FactoryBot.define do
  factory :location_object do
    subject_id { 1 }
    subject_type { 'Resource' }
    amount { 100 }
    unit { 'grams' }
    damage { 1.5 }
    location
  end
end
