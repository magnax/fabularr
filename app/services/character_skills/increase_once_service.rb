# frozen_string_literal: true

module CharacterSkills
  class IncreaseOnceService < ApplicationService
    def initialize(character_skill)
      @character_skill = character_skill
    end

    def call
      return if @character_skill.level >= 4

      new_level = @character_skill.level + amount
      new_level = 4 if new_level > 4

      @character_skill.update!(level: new_level)
    end

    private

    def amount
      1.0 / Skill::DAYS_PER_LEVEL[@character_skill.int_level]
    end
  end
end
