# frozen_string_literal: true

FactoryBot.define do
  factory :character_skill do
    character
    skill
    level { 0 }

    %i[building exploring].each do |key|
      trait key do
        skill { create(:skill, key: Skill.const_get(key.to_s.upcase)) }
      end
    end
  end
end
