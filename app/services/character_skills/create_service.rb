# frozen_string_literal: true

module CharacterSkills
  class CreateService < ApplicationService
    def initialize(character, skill)
      @character = character
      @skill = skill
    end

    def call
      @character.character_skills.where(skill_id: @skill.id)
                .first_or_create(level: (0..4).to_a.sample)
    end
  end
end
