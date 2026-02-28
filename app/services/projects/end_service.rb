# frozen_string_literal: true

module Projects
  class EndService < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      project.workers.active.find_each do |worker|
        worker.update!(left_at: DateTime.current)
        Event.create!(
          body: I18n.t('events.projects.ended'),
          location: project.location,
          receiver_character: worker.character
        )
      end
      return unless project.starting_character.location == project.location

      Event.create!(
        body: I18n.t('events.projects.my_ended'),
        location: project.location,
        receiver_character: project.starting_character
      )
    end

    private

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
