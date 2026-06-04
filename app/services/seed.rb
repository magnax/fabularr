# frozen_string_literal: true

module Seed
  def self.load_resources(data, default_resource_type = 'raw_resource')
    data.each do |key, conf|
      skill_name = conf.try(:[], 'skill')
      skill = skill_name.present? ? Skill.where(key: skill_name).first_or_create : nil
      names = ([default_resource_type] + (conf.try(:[], 'types') || [])).uniq

      res_types_id = names.map do |key|
        ResourceType.where(key: key).first_or_create.id
      end

      create_resource(key, conf, res_types_id, skill)
    end
  end

  def self.create_resource(key, conf, res_types_id, skill)
    Resource.create!(
      key: key, unit: 'grams',
      base_speed_per_unit: conf.try(:[], 'rate') || 0,
      eaten: conf.try(:[], 'eaten') || 0,
      heal: conf.try(:[], 'heal') || 0,
      resource_type_id: res_types_id,
      skill: skill
    )
  end
end
