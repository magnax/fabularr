# frozen_string_literal: true

require 'test_helper'

class ProjectsProjectInfoServiceTest < ActiveSupport::TestCase
  def setup
    # create skills:
    require_relative '../../../db/seeds/skills'

    @project_type = create(:project_type, key: 'collect')
  end

  def teardown
    Resource.destroy_all
    Skill.destroy_all
  end

  def call_service(params)
    Projects::ProjectInfoService.call(@character, params)
  end

  test 'raise exception for invalid resource' do
    skill = create(:skill)
    resource = create(:resource, skill: skill)
    location_resource = create(:location_resource, resource: resource, status: false)

    params = {
      project_type_id: @project_type.id,
      location_resource_id: location_resource.id,
      type: 'collect'
    }

    assert_raises Projects::ProjectInfoService::InvalidResourceError do
      call_service(params)
    end
  end

  test 'skill names' do
    Skill::COLLECTING_SKILLS.each do |skill_name|
      skill = Skill.find_by(key: skill_name.downcase)
      resource = create(:resource, skill: skill)
      location_resource = create(:location_resource, resource: resource)

      params = {
        project_type_id: @project_type.id,
        location_resource_id: location_resource.id,
        type: 'collect'
      }

      res = call_service(params)

      assert_not_includes res[:skill_name], 'Translation missing'
    end
  end
end
