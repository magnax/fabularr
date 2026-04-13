# frozen_string_literal: true

require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  test 'resource types' do
    resource = create(:resource, :raw_food)

    assert_equal ['raw_food'], resource.resource_types.pluck(:key)
  end
end
