# frozen_string_literal: true

module Characters
  class ShowService < ApplicationService
    class InvalidCharacterError < StandardError; end

    def initialize(character, char_id)
      @character = character
      @char_id = char_id
    end

    def call
      raise InvalidCharacterError if subject_character.blank?

      {
        age: age,
        id: subject_character.id,
        name: @character.name_for(subject_character),
        project: project,
        self_view: @character == subject_character,
        skills: skills,
        spawn_location_id: subject_character.spawn_location_id,
        spawn_location_name: spawn_location_name,
        spawn_day: GameTime.last.days(subject_character.created_at)
      }.with_indifferent_access
    end

    private

    def age
      I18n.t("characters.age.over_#{subject_character.decade}_#{subject_character.gender.downcase}")
    end

    def project
      return if worker.blank?

      {
        name: worker_project.name(@character, short: true)
              .upcase_first,
        skill: worker_skill
      }
    end

    def worker_skill
      @worker_skill ||= Skill::MAP_LEVELS[
        subject_character.character_skills.find_by(
          skill_id: worker_project.skill.id
        ).int_level
      ]
    end

    def worker_project
      @worker_project ||= worker.project
    end

    def worker
      @worker ||= subject_character.worker
    end

    def skills
      return unless subject_character == @character

      subject_character.character_skills.visible.as_json(
        only: :level, methods: %i[description key]
      )
    end

    def spawn_location_name
      subject_character.spawn_location.display_name(subject_character)
    end

    def subject_character
      @subject_character ||= Character.find_by(id: @char_id)
    end
  end
end
