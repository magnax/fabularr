# frozen_string_literal: true

data = YAML.load_file(Rails.root.join('db/seeds/data/materials.yml').to_s)

Seed.load_resources(data, 'material')

Log.say "ResourceTypes (#{ResourceType.count}), Resources (materials) "\
        "created: #{Resource.material.pluck(:key).join(', ')}"
