# frozen_string_literal: true

module LocationObjects
  class IncreaseAmountService < ApplicationService
    def initialize(location, key, amount)
      @location = location
      @key = key
      @amount = amount
    end

    def call
      location_object.update!(amount: location_object.amount + @amount)
    end

    private

    def location_object
      @location_object ||=
        location_objects.find_by(subject_id: resource.id) ||
        location_objects.create!(subject: resource, amount: 0)
    end

    def location_objects
      @location.location_objects.resource
    end

    def resource
      @resource ||= Resource.find_by(key: @key)
    end
  end
end
