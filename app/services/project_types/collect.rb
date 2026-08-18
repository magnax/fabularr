# frozen_string_literal: true

module ProjectTypes
  class Collect < ApplicationService
    class NoSuchResourceError < StandardError; end

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      raise NoSuchResourceError if location_resource.blank?

      receiver = InventoryObjects::IncreaseAmountService.call(
        receiving_character, resource.key, resource_description.amount_needed
      )

      resource_description.update!(amount: amount)
      project.project_descriptions.create!(
        description_type: ProjectDescription::RECEIVER, subject: receiver
      )
      update_workers!
      return unless project.starting_character.location == project.location

      update_starting_character
    end

    private

    def location_resource
      @location_resource ||= visible_location_resources.find_by(resource_id: resource.id)
    end

    def update_workers!
      project.workers.active.find_each do |worker|
        worker.update!(left_at: DateTime.current)
        next if worker.character == project.starting_character

        create_event_and_broadcast!(worker)
      end
    end

    def update_starting_character
      event = Event.create!(
        body: body,
        receiver_character: project.starting_character
      )
      broadcast_to_receiver(event.id, project.starting_character.id)
    end

    def body
      I18n.t(body_key, **project_info)
    end

    def body_key
      return 'events.projects.end.collect' if receiver == project.starting_character

      'events.projects.end.collect_ground'
    end

    def receiver
      @receiver = destination_description.subject
    end

    def destination_description
      @destination_description ||= project.project_descriptions.receiver.last
    end

    def broadcast_to_receiver(event_id, receiver_id)
      ActionCable.server.broadcast(
        "char_#{receiver_id}",
        { type: 'event', event_id: event_id, receiver_id: receiver_id }
      )
    end

    def project_info
      {
        project_name: project.short_name.upcase_first,
        amount: out_resource_description.amount.to_i,
        resource: I18n.tn("resources.#{out_resource_description.subject.key}")
      }
    end

    def out_resource_description
      @out_resource_description ||= project.project_descriptions.resource_out.first
    end

    def visible_location_resources
      @visible_location_resources ||= location.location_resources.visible
    end

    # TODO: case when starting character is not present in project's location
    def receiving_character
      @receiving_character ||= project.starting_character
    end

    def resource
      @resource ||= resource_description.subject
    end

    def resource_description
      @resource_description ||= project.project_descriptions.resource_out.last
    end

    def amount
      @amount ||= resource_description.amount_needed.to_i
    end

    def location
      @location ||= project.location
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
