# frozen_string_literal: true

module Seeds::CreateResources
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
    res = Resource.find_by(key: key)
    attrs = resource_attrs(conf, res_types_id, skill)

    if res.present?
      res.update!(**attrs)
    else
      Resource.create!(key: key, **attrs)
    end
  end

  def resource_attrs(conf, res_types_id, skill)
    {
      unit: 'grams',
      daily_rate: conf.try(:[], 'rate') || 0,
      eaten: conf.try(:[], 'eaten') || 0,
      heal: conf.try(:[], 'heal') || 0,
      resource_type_id: res_types_id,
      skill: skill
    }
  end
end
