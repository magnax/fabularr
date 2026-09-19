# frozen_string_literal: true

module LocationObjects
  class ShowTakeService < ApplicationService
    def initialize(character, location_object_id)
      @character = character
      @location_object_id = location_object_id
    end

    def call
      raise InvalidObjectError if location_object.blank?

      {
        amount: location_object.amount,
        key: location_object.subject.key,
        subject_id: location_object.subject_id,
        subject_type: location_object.subject_type,
        unit: location_object.unit || 'grams'
      }
    end

    private

    def location_object
      @location_object ||= location.location_objects.find_by(id: @location_object_id)
    end

    def location
      @location ||= @character.location
    end
  end
end
