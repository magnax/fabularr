# frozen_string_literal: true

FactoryBot.define do
  factory :setting do
    key { 'jobs' }
    value { '1' }
  end
end
