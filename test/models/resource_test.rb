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
require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  test 'resource types' do
    resource = create(:resource, :raw_food)

    assert_equal ['raw_food'], resource.resource_types.pluck(:key)
  end
end
