# frozen_string_literal: true

FactoryBot.define do
  factory :location_class do
    key { 'town' }
    moveable { false }
  end
end
