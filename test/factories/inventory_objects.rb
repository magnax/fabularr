# frozen_string_literal: true

FactoryBot.define do
  factory :inventory_object do
    subject_id { 1 }
    subject_type { 'Resource' }
    amount { 100 }
    unit { 'grams' }
    character
  end
end
