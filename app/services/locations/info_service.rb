# frozen_string_literal: true

module Locations
  class InfoService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      {
        toplevel_location_name: toplevel_location&.display_name(@character),
        toplevel_location_id: toplevel_location&.id,
        sublocation_name: sublocation_name,
        sublocation_id: sublocation_id,
        location_type: location_type
      }
    end

    private

    def sublocation_name
      return if location.blank? || town?

      location.display_name(@character)
    end

    def sublocation_id
      return if location.blank? || town?

      location.id
    end

    def location_type
      return if location.blank?

      loc_type = I18n.t "#{location_type_i18n_key}.#{location.location_type.key}"
      return "[#{loc_type}]" unless location.town?

      "[#{loc_type}][#{location.x.round(1)}, #{location.y.round(1)}]"
    end

    def location_type_i18n_key
      location.town? ? 'locations' : location.location_class.key.pluralize
    end

    def town?
      location.present? && location.town?
    end

    def toplevel_location
      @toplevel_location ||= @character.toplevel_location
    end

    def location
      @location ||= @character.location
    end
  end
end
