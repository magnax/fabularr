# frozen_string_literal: true

module Projects
  class NameService < ApplicationService
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def initialize(project, character)
      @project = project
      @character = character
    end

    def call
      "#{type_name}: #{road_name}"
    end

    private

    def road_name
      @road_name ||= I18n.t(
        "roads.#{description.metadata['road_type']}",
        location_1: link_to_location(@project.location), location_2: link_to_location(description.subject)
      )
    end

    def link_to_location(location)
      link_to(
        location.display_name(@character),
        location_name_url(location_id: location.id, only_path: true)
      )
    end

    def description
      @description ||= @project.project_descriptions.road.first
    end

    def type_name
      @type_name ||= I18n.t("projects.name.#{project_type.key}").capitalize
    end

    def project_type
      @project_type ||= @project.project_type
    end
  end
end
