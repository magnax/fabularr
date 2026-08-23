# frozen_string_literal: true

module Seeds
  class RawResources < ApplicationService
    def call
      data = YAML.load_file(Rails.root.join('db/seeds/data/raw_resources.yml').to_s)

      load_resources!(data, 'raw_resource')

      Log.say "ResourceTypes (#{ResourceType.count}), Resources (raw resources) "\
              "created: #{Resource.raw_resource.pluck(:key).join(', ')}"
    end

    private

    def load_resources!(data, default_resource_type = 'raw_resource')
      data.each do |key, conf|
        skill_name = conf.try(:[], 'skill')
        skill = skill_name.present? ? Skill.where(key: skill_name).first_or_create : nil
        names = ([default_resource_type] + (conf.try(:[], 'types') || [])).uniq

        res_types_id = names.map do |key|
          ResourceType.where(key: key).first_or_create.id
        end

        create_resource!(key, conf, res_types_id, skill)
      end
    end

    def create_resource!(key, conf, res_types_id, skill)
      Resource.create!(
        key: key, unit: 'grams',
        daily_rate: conf.try(:[], 'rate') || 0,
        eaten: conf.try(:[], 'eaten') || 0,
        heal: conf.try(:[], 'heal') || 0,
        resource_type_id: res_types_id,
        skill: skill
      )
    end
  end
end
