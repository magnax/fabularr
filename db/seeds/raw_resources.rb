# frozen_string_literal: true

data = YAML.load_file(Rails.root.join('db/seeds/data/raw_resources.yml').to_s)

Seed.load_resources(data, 'raw_resource')

Log.say "ResourceTypes (#{ResourceType.count}), Resources (raw resources) "\
        "created: #{Resource.raw_resource.pluck(:key).join(', ')}"
