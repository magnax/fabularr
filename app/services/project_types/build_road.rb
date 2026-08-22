# frozen_string_literal: true

module ProjectTypes
  class BuildRoad < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project)
      @project = project
    end

    def call
      Road.create!(
        location_1: project_location,
        location_2: dest_location,
        road_type: road_type
      )

      update_workers!

      notify_starting_character
    end

    private

    def body
      I18n.t('events.projects.end.road', **project_info)
    end

    def project_info
      {
        road_type: I18n.t("roads.types.#{road_type}"),
        start_location_link: project_location.loc_id,
        end_location_link: dest_location.loc_id
      }
    end

    def project_location
      @project_location ||= @project.location
    end

    def dest_location
      @dest_location ||= road_description.subject
    end

    def road_type
      @road_type ||= road_description.metadata['road_type']
    end

    def road_description
      @road_description ||= @project.project_descriptions.road.first
    end
  end
end
