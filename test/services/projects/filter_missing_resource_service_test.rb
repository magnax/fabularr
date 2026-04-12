# frozen_string_literal: true

require 'test_helper'

class ProjectsFilterMissingResourceServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(resource)
    Projects::FilterMissingResourceService.call(@character, resource)
  end

  test 'empty list when no projects' do
    resource = create(:resource, key: 'stone')

    res = call_service(resource)

    assert_empty res
  end

  test 'list of projects' do
    resource = create(:resource, key: 'stone')
    project = create(:project, :build, location: @character.location)
    create(:project_description, :resource_in, project: project,
                                               subject: resource, amount_needed: 1000, amount: 200)

    res = call_service(resource)

    assert_equal 'Building, started by: unknown man (800.0)', res[0][0]
    assert_equal project.id, res[0][1]
  end
end
