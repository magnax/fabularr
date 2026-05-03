# frozen_string_literal: true

require 'test_helper'

class ProjectsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@user, @character)
  end

  test 'create project - discover resource' do
    project_type = create(:project_type, key: 'discover_resource',
                                         base_speed: 1000, fixed: true)
    params = {
      project: {
        project_type_id: project_type.id
      }
    }

    assert_difference -> { Project.count }, 1 do
      post '/projects', params: params
    end

    assert_response :found

    assert_redirected_to '/en/events'
  end

  test 'create project - build road' do
    project_type = create(:project_type, key: 'road', base_speed: 1000, fixed: true)
    location = create(:location)

    params = {
      project: {
        project_type_id: project_type.id,
        location_id: location.id
      }
    }
    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 1,
                      -> { Event.count } => 1 do
      post '/projects', params: params
    end

    p = Project.last
    assert_equal ProjectType::ROAD, p.project_type.key
    assert p.ready

    pd = p.project_descriptions.sole
    assert_equal ProjectDescription::ROAD, pd.description_type
    assert_equal location, pd.subject
    assert_equal Road::PATH, pd.metadata['road_type']

    e = Event.last
    assert_equal @character.id, e.receiver_character_id
    assert_equal "You're starting new project: building road.", e.body
  end
end
