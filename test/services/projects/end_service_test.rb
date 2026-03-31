# frozen_string_literal: true

require 'test_helper'

class Projects::EndServiceTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test 'broadcasting end project message to worker' do
    starting_character = create(:character)
    worker_character = create(:character)
    project = create(:project, :discover_resource,
                     starting_character: starting_character)
    create(:worker, project: project, character: worker_character)

    call_service(project.id)

    assert_broadcast_on(
      "location_#{project.location_id}",
      type: 'event',
      event_id: Event.where(receiver_character_id: worker_character.id).last.id,
      receiver_id: worker_character.id
    )
  end

  test 'broadcasting end project to starting character' do
    location = create(:location)
    starting_character = create(:character, location: location)
    worker_character = create(:character, location: location)
    project = create(:project, :discover_resource,
                     location: location, starting_character: starting_character)
    create(:worker, project: project, character: worker_character)

    call_service(project.id)

    assert_broadcast_on(
      "location_#{project.location_id}",
      type: 'event',
      event_id: Event.where(receiver_character_id: starting_character.id).last.id,
      receiver_id: starting_character.id
    )
  end

  test 'broadcasting end project to location' do
    location = create(:location)
    starting_character = create(:character, location: location)
    worker_character = create(:character, location: location)
    project = create(:project, :discover_resource,
                     location: location,
                     starting_character: starting_character)
    create(:worker, project: project, character: worker_character)

    call_service(project.id)

    assert_broadcast_on(
      "location_#{project.location_id}",
      type: 'project.end',
      project_id: project.id
    )
  end

  test '#discover_resource does not create resource if no resources defined' do
    location = create(:location)
    starting_character = create(:character, location: location)
    project = create(:project, :discover_resource, location: location,
                                                   starting_character: starting_character)
    create(:worker, project: project, character: starting_character)

    assert_difference -> { LocationResource.count }, 0 do
      call_service(project.id)
    end
  end

  test '#discover_resource creates food resource in location' do
    type = create(:location_type, key: 'meadow')
    location = create(:location, location_type: type)

    food_type = create(:resource_type, key: 'food')
    other_type = create(:resource_type, key: 'material')

    create(:resource, key: 'wood', resource_type_id: [other_type.id])
    resource = create(:resource, key: 'mushrooms', resource_type_id: [food_type.id])

    starting_character = create(:character, location: location)
    project = create(:project, :discover_resource, location: location,
                                                   starting_character: starting_character)
    create(:worker, project: project, character: starting_character)

    assert_difference -> { LocationResource.count }, 1 do
      call_service(project.id)
    end

    assert_equal resource.id, location.reload.location_resources.sole.resource_id

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_equal 'Project started by you has just ended. Found new resource: mushrooms', event.body
  end
end
