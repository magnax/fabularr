# frozen_string_literal: true

module Workers
  class EndService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      return if worker.blank?

      worker.update!(left_at: Time.current)

      CharacterSkills::UpdateService.call(worker)
    end

    private

    def project
      @project ||= worker.project
    end

    def worker
      @worker ||= @character.worker
    end
  end
end
