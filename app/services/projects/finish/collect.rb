# frozen_string_literal: true

module Projects
  class Finish::Collect < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    class NoSuchResourceError < StandardError; end

    def initialize(project)
      @project = project
    end

    def call
      raise NoSuchResourceError if location_resource.blank?

      create_resource!

      update_workers!
      notify_starting_character
    end

    private

    def create_resource!
      if starting_character.location == @project.location
        receiver = InventoryObjects::IncreaseAmountService.call(
          starting_character, resource.key, resource_description.amount_needed
        )
      else
        LocationObjects::IncreaseAmountService.call(
          location, resource.key, resource_description.amount_needed
        )
        receiver = @project.location
      end

      resource_description.update!(amount: amount)
      @project.project_descriptions.create!(
        description_type: ProjectDescription::RECEIVER, subject: receiver
      )
    end

    def location_resource
      @location_resource ||= visible_location_resources.find_by(resource_id: resource.id)
    end

    def body
      I18n.t(body_key, **project_info)
    end

    def body_key
      return 'events.projects.end.collect' if receiver == starting_character

      'events.projects.end.collect_ground'
    end

    def receiver
      @receiver = destination_description.subject
    end

    def destination_description
      @destination_description ||= @project.project_descriptions.receiver.last
    end

    def project_info
      {
        project_name: @project.short_name.upcase_first,
        amount: out_resource_description.amount.to_i,
        resource: I18n.tn("resources.#{out_resource_description.subject.key}")
      }
    end

    def out_resource_description
      @out_resource_description ||= @project.project_descriptions.resource_out.first
    end

    def visible_location_resources
      @visible_location_resources ||= location.location_resources.visible
    end

    def resource
      @resource ||= resource_description.subject
    end

    def resource_description
      @resource_description ||= @project.project_descriptions.resource_out.last
    end

    def amount
      @amount ||= resource_description.amount_needed.to_i
    end

    def location
      @location ||= @project.location
    end
  end
end
