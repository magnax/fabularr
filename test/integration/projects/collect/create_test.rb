# frozen_string_literal: true

require 'test_helper'

class ProjectsCollectCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@user, @character)
  end

  test 'create project - collect resource' do
    digging = create(:skill, key: Skill::DIGGING)
    zinc = create(:resource, key: 'zinc', daily_rate: 100, skill: digging)
    location_zinc = create(:location_resource, resource: zinc,
                                               location: @character_location)
    project_type = create(:project_type, key: 'collect',
                                         base_speed: 1000, fixed: true)
    params = {
      locale: 'pl',
      project: {
        location_resource_id: location_zinc.id,
        project_type_id: project_type.id,
        repeat: 3
      }
    }

    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 2 do
      post '/projects', params: params
    end

    assert_response :found

    assert_redirected_to '/pl/events'

    event = Event.last
    assert_equal 'Rozpoczynasz nowy projekt: kopanie cynku.', event.body
  end
end
