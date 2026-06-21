# frozen_string_literal: true

require 'test_helper'

class ProjectsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character)
  end

  def call_service(params)
    Projects::CreateService.call(@current_character, params)
  end

  test 'raise exception when project type is wrong' do
    params = {
      project_type_id: 0
    }

    assert_raises Projects::CreateService::InvalidProjectTypeError do
      call_service(params)
    end
  end

  test 'raise exception when class not implemented' do
    project_type = create(:project_type, key: 'not_implemented_type')

    params = {
      project_type_id: project_type.id
    }

    assert_raises NotImplementedError do
      call_service(params)
    end
  end

  test 'raise exception when recipe not found for build project' do
    project_type = create(:project_type, key: 'build')

    params = {
      project_type_id: project_type.id
    }

    assert_raises Projects::RecipeNotFoundError do
      call_service(params)
    end
  end
end
