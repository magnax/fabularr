# frozen_string_literal: true

FactoryBot.define do
  factory :character_skill do
    character
    skill
    level { 0 }

    trait :exploring do
      skill { create(:skill, key: Skill::EXPLORING) }
    end
  end
end
