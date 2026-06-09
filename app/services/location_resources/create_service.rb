# frozen_string_literal: true

module LocationResources
  class CreateService < ApplicationService
    def initialize(location)
      @location = location
    end

    def call
      create_location_resources(food_resources)
      create_location_resources(mandatory_resources)

      available_count = res_count - food_count - mandatory_count

      return unless available_count.positive?

      create_location_resources(config[:available][:resources].sample(available_count))
    end

    private

    def res_count
      @res_count ||= rand(config[:min]..config[:max])
    end

    def food_resources
      @food_resources ||= food_config[:resources].sample(food_count)
    end

    def food_count
      @food_count ||= count_resources(food_config)
    end

    def food_config
      @food_config ||= config[:raw_food]
    end

    def mandatory_resources
      @mandatory_resources ||= mandatory_config[:resources].sample(mandatory_count)
    end

    def mandatory_count
      @mandatory_count ||= count_resources(mandatory_config)
    end

    def mandatory_config
      @mandatory_config ||= config[:mandatory]
    end

    def config
      @config ||= Definitions::LocationResources::CONFIG[location_type.key.to_sym]
    end

    def count_resources(config)
      config[:min] == config[:max] ? config[:min] : rand(config[:min]..config[:max])
    end

    def create_location_resources(keys)
      keys.each do |res_key|
        resource = Resource.find_by(key: res_key)
        next unless resource

        sorting = (@location.location_resources.pluck(:sorting).max || 0) + 1
        @location.location_resources.create!(
          resource: resource, sorting: sorting
        )
      end
    end

    def location_type
      @location_type ||= @location.location_type
    end
  end
end
