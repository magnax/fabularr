# frozen_string_literal: true

require 'test_helper'

class Projects::DiscoverResourceEndServiceTest < ActiveSupport::TestCase
  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test '#discover_resource creates resource in location' do
    location = create(:location)

    res_1 = create(:resource, key: 'wood')
    res_2 = create(:resource, key: 'stone')
    res_3 = create(:resource, key: 'mushrooms')
    create(:location_resource, location: location,
                               status: true, resource: res_1, sorting: 1)
    create(:location_resource, location: location,
                               status: false, resource: res_2, sorting: 3)
    create(:location_resource, location: location,
                               status: false, resource: res_3, sorting: 2)

    starting_character = create(:character, location: location)
    project = create(:project, :discover_resource, location: location,
                                                   starting_character: starting_character)
    create(:worker, project: project, character: starting_character)

    assert_difference -> { LocationResource.visible.count } => 1,
                      -> { ProjectDescription.count } => 1,
                      -> { Event.count } => 1 do
      call_service(project.id)
    end

    assert_equal ProjectDescription::LOCATION_RESOURCE,
                 ProjectDescription.last.description_type

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_equal 'Project started by you has just ended. Found new resource: mushrooms', event.body
  end

  test '#discover_resource when no resources left to discover' do
    location = create(:location)
    resource = create(:resource)
    create(:location_resource, location: location, status: true, resource: resource)

    starting_character = create(:character, location: location)
    project = create(:project, :discover_resource, location: location,
                                                   starting_character: starting_character)
    create(:worker, project: project, character: starting_character)

    assert_difference -> { LocationResource.count } => 0,
                      -> { ProjectDescription.count } => 1,
                      -> { Event.count } => 1 do
      call_service(project.id)
    end

    assert_equal ProjectDescription::LOCATION_RESOURCE,
                 ProjectDescription.last.description_type

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_equal 'Project started by you has just ended. '\
                 'No resource found, all resources are already discovered.',
                 event.body
  end
end
