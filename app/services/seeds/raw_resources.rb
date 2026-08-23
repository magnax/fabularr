# frozen_string_literal: true

module Seeds
  class RawResources < ApplicationService
    include CreateResources

    def call
      data = YAML.load_file(Rails.root.join('db/seeds/data/raw_resources.yml').to_s)

      load_resources!(data, 'raw_resource')

      Log.say "ResourceTypes (#{ResourceType.count}), Resources (raw resources) "\
              "created: #{Resource.raw_resource.pluck(:key).join(', ')}"
    end
  end
end
