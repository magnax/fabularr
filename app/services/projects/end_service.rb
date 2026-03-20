# frozen_string_literal: true

module Projects
  class EndService < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      Projects::Dispatcher.call(@project_id)
      update_workers
      broadcast_to_location
      return unless project.starting_character.location == project.location

      update_starting_character
    end

    private

    def update_workers
      project.workers.active.find_each do |worker|
        worker.update!(left_at: DateTime.current)
        event = Event.create!(
          body: I18n.t('events.projects.ended'),
          location: project.location,
          receiver_character: worker.character
        )

        broadcast_to_receiver(event.id, worker.character.id)
      end
    end

    def update_starting_character
      event = Event.create!(
        body: I18n.t('events.projects.my_ended', project_info: project_info),
        location: project.location,
        receiver_character: project.starting_character
      )
      broadcast_to_receiver(event.id, project.starting_character.id)
    end

    def broadcast_to_receiver(event_id, receiver_id)
      ActionCable.server.broadcast(
        channel, { type: 'event', event_id: event_id, receiver_id: receiver_id }
      )
    end

    def broadcast_to_location
      ActionCable.server.broadcast(
        channel, { type: 'project.end', project_id: project.id }
      )
    end

    def channel
      @channel ||= "location_#{project.location_id}"
    end

    def project_info
      return unless project.project_descriptions.any?

      case project.project_type.key
      when 'build'
        build_project_info
      when 'collect'
        collect_project_info
      when 'discover_resource'
        discover_resource_project_info
      end
    end

    def build_project_info
      I18n.t('project_info.build', item: I18n.t("items.#{project.recipe.key}"))
    end

    def collect_project_info
      I18n.t('project_info.collect', amount: resource_description.amount.to_i,
                                     res: resource_info,
                                     unit: I18n.t(resource_description.unit))
    end

    def discover_resource_project_info
      I18n.t('project_info.discover', res: resource_info)
    end

    def resource_info
      I18n.t("resources.#{resource_description.subject.key}")
    end

    def resource_description
      @resource_description ||= project.project_descriptions.first
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
