# frozen_string_literal: true

module Seeds
  class Materials < ApplicationService
    include CreateResources

    def call
      data = YAML.load_file(Rails.root.join('db/seeds/data/materials.yml').to_s)

      load_resources!(data, 'material')

      Log.say "ResourceTypes (#{ResourceType.count}), Resources (materials) "\
              "created: #{Resource.material.pluck(:key).join(', ')}"
    end
  end
end
