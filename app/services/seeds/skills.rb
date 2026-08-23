# frozen_string_literal: true

module Seeds
  class Skills < ApplicationService
    def call
      Skill::SKILLS.each do |key|
        Skill.where(key: Skill.const_get(key)).first_or_create
      end
    end
  end
end
