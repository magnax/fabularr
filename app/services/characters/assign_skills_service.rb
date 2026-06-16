# frozen_string_literal: true

module Characters
  class AssignSkillsService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      Skill.find_each do |skill|
        @character.character_skills.where(skill_id: skill.id).first_or_create(
          level: (0..4).to_a.sample
        )
      end
    end
  end
end
