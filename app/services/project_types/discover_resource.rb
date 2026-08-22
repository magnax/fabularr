# frozen_string_literal: true

module ProjectTypes
  class DiscoverResource < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project)
      @project = project
    end

    def call
      discovered_resource&.update!(status: true)

      @project.project_descriptions.create!(
        description_type: ProjectDescription::LOCATION_RESOURCE,
        subject: discovered_resource&.resource
      )

      update_workers!

      notify_starting_character
    end

    private

    def body
      I18n.t('events.projects.my_ended', project_info: project_info)
    end

    def project_info
      return I18n.t('project_info.discover_last') if resource_description.subject.blank?

      I18n.t('project_info.discover', res: resource_info)
    end

    def discovered_resource
      @discovered_resource ||= location.location_resources.available.first
    end

    def resource_info
      I18n.tn("resources.#{resource_description.subject.key}")
    end

    def resource_description
      @resource_description ||= @project.project_descriptions.location_resource.first
    end

    def location
      @location ||= @project.location
    end
  end
end
