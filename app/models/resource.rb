# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id                  :bigint           not null, primary key
#  base_speed_per_unit :float
#  key                 :string
#  material            :boolean          default(TRUE)
#  unit                :string           default("grams")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_type_id    :integer          is an Array
#
class Resource < ApplicationRecord
  def resource_types
    ResourceType.where(id: resource_type_id)
  end
end
