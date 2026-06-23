# frozen_string_literal: true

module Admin
  class Locations::ShowService < ApplicationService
    include Rails.application.routes.url_helpers

    def initialize(id, breadcrumbs)
      @id = id
      @breadcrumbs = breadcrumbs
    end

    def call
      {
        location_id: location.id,
        location_name: location.name,
        resources: resources,
        breadcrumbs: breadcrumbs
      }
    end

    private

    def breadcrumbs
      @breadcrumbs <<
        :separator <<
        { text: 'Locations', link: admin_locations_url(only_path: true) } <<
        :separator <<
        "Location: #{location.id}"
    end

    def resources
      @resources ||= location.location_resources.order(sorting: :asc).map do |res|
        {
          status: res.status,
          id: res.id,
          key: res.resource.key,
          name: I18n.tn("resources.#{res.resource.key}"),
          sorting: res.sorting
        }
      end
    end

    def location
      @location ||= Location.find_by(id: @id)
    end
  end
end
