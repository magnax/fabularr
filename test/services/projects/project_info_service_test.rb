# frozen_string_literal: true

require 'test_helper'

class ProjectsProjectInfoServiceTest < ActiveSupport::TestCase
  def setup
    # create skills:
    Skill::SKILLS.each do |key|
      Skill.where(key: Skill.const_get(key)).first_or_create
    end

    @project_type = create(:project_type, key: 'collect')
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

    assert_raises Projects::Info::Collect::InvalidResourceError do
      call_service(params)
    end
  end

  test 'skill names' do
    resource = create(:resource)
    location_resource = create(:location_resource, resource: resource)

    Skill::COLLECTING_SKILLS.each do |skill_name|
      skill = Skill.find_by(key: skill_name.downcase)
      assert skill
      resource.update!(skill: skill)

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
