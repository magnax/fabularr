# frozen_string_literal: true

module CharacterSkills
  class UpdateService < ApplicationService
    def initialize(worker)
      @worker = worker
    end

    def call
      return if character_skill.level >= 4

      new_level = character_skill.level + (@worker.time.to_f / (days * GameTime::DAY))
      new_level = 4 if new_level > 4
      character_skill.update!(level: new_level)
    end

    private

    def days
      @days ||= Skill::DAYS_PER_LEVEL[character_skill.int_level]
    end

    def character_skill
      @character_skill ||= character.character_skills.find_by(skill_id: skill.id)
    end

    def skill
      @skill ||= project.skill
    end

    def character
      @character ||= @worker.character
    end

    def project
      @project ||= @worker.project
    end
  end
end
