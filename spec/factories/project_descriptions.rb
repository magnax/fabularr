# frozen_string_literal: true

FactoryBot.define do
  factory :project_description do
    subject_id { 1 }
    subject_type { 'Resource' }
    unit { 'grams' }
    amount { 1.5 }
    project
  end
end
