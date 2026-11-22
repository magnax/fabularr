# frozen_string_literal: true

require 'test_helper'

class ProjectsVehicleCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@user, @character)
  end

  test 'shows error when ship cannot be built' do
    project_type = create(:project_type, key: 'build')
    recipe = create(:recipe, recipe_type: 'ship')

    params = {
      project: {
        project_type_id: project_type.id,
        recipe_id: recipe.id
      }
    }

    assert_difference -> { Project.count } => 0 do
      post '/projects', params: params
    end

    assert_response :found

    assert_redirected_to '/en/events'
  end

  test 'create project - build ship' do
    project_type = create(:project_type, key: 'build', base_speed: 1000, fixed: true)
    recipe = create(:recipe, recipe_type: 'ship', key: 'sloop')
    location = create(:location, seashore: true)
    @character.update!(location: location)

    params = {
      project: {
        project_type_id: project_type.id,
        location_id: location.id,
        recipe_id: recipe.id,
        signboard_text: 'My Ship'
      }
    }
    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 1,
                      -> { Event.count } => 1 do
      post '/projects', params: params
    end

    p = Project.last
    assert_equal ProjectType::BUILD, p.project_type.key
    assert_not p.ready

    pd = p.project_descriptions.sole
    assert_equal ProjectDescription::SETTINGS, pd.description_type
    assert_equal 'My Ship', pd.metadata['name']

    e = Event.last
    assert_equal @character.id, e.receiver_character_id
    assert_equal "You're starting new project: Building: sloop.", e.body
  end
end
