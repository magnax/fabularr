# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id                  :bigint           not null, primary key
#  base_speed_per_unit :float
#  eaten               :integer
#  heal                :integer          default(0)
#  integer             :integer
#  key                 :string
#  material            :boolean          default(TRUE)
#  unit                :string           default("grams")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_type_id    :integer          is an Array
#  skill_id            :bigint
#
# Indexes
#
#  index_resources_on_skill_id  (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#
class Resource < ApplicationRecord
  belongs_to :skill, optional: true

  # food, fuel, material, medicine, raw_food, raw_resource
  ResourceType::TYPES.map(&:downcase).each do |scope_name|
    define_singleton_method scope_name do
      rt_id = ResourceType.find_by(key: scope_name).id

      Resource.where("#{rt_id} = any(resource_type_id)")
    end
  end

  def resource_types
    ResourceType.where(id: resource_type_id)
  end
end
