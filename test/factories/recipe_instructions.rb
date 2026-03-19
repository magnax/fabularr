# frozen_string_literal: true

FactoryBot.define do
  factory :recipe_instruction do
    instruction_type { 'resource' }
    subject_id { 1 }
    subject_type { 'Resource' }
    amount { 1 }
    unit { 'grams' }
  end
end
