# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    key { 'stone_knife' }
    base_speed { 1000 }
  end
end
