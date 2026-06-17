# frozen_string_literal: true

module Characters
  class AssignSkillsService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      Skill.find_each do |skill|
        CharacterSkills::CreateService.call(@character, skill)
      end
    end
  end
end
