# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id               :bigint           not null, primary key
#  daily_rate       :float
#  eaten            :integer
#  heal             :integer          default(0)
#  integer          :integer
#  key              :string
#  material         :boolean          default(TRUE)
#  unit             :string           default("grams")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  resource_type_id :integer          is an Array
#  skill_id         :bigint
#
# Indexes
#
#  index_resources_on_skill_id  (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#
require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  test 'resource types' do
    resource = create(:resource, :raw_food)

    assert_equal ['raw_food'], resource.resource_types.pluck(:key)
  end
end
