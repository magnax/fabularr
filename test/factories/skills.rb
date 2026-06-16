# frozen_string_literal: true

FactoryBot.define do
  factory :skill do
    key { Faker::Lorem.word }
  end
end
