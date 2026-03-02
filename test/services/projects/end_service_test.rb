require 'test_helper'

class Projects::EndServiceTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test 'broadcasting end project message to worker' do
    starting_character = create(:character)
    worker_character = create(:character)
    project = create(:project, starting_character: starting_character)
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
    project = create(:project, location: location, starting_character: starting_character)
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
    project = create(:project, location: location, starting_character: starting_character)
    create(:worker, project: project, character: worker_character)

    call_service(project.id)

    assert_broadcast_on(
      "location_#{project.location_id}",
      type: 'project.end',
      project_id: project.id
    )
  end
end
