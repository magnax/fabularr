# frozen_string_literal: true

require 'test_helper'

class ProjectsCollectEndServiceTest < ActiveSupport::TestCase
  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test '#collect creates resource in location' do
    location = create(:location)
    food_type = create(:resource_type, key: 'food')
    resource = create(:resource, key: 'mushrooms', resource_type_id: [food_type.id])
    starting_character = create(:character, location: location)
    project = create(:project, :collect, location: location,
                                         starting_character: starting_character)
    create(:project_description, project: project, subject: resource, amount: 100,
                                 unit: 'grams')
    worker = create(:worker, project: project, character: starting_character)
    assert_nil worker.left_at

    assert_difference -> { LocationObject.count }, 1 do
      call_service(project.id)
    end

    assert_not_nil worker.reload.left_at
    assert_equal resource.id, location.reload.location_objects.sole.subject_id
    assert_equal 'Resource', location.reload.location_objects.sole.subject_type

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_match(/Project started by you has just ended. (\d{2,3}) grams of mushrooms landed on the ground/, event.body)
  end
end
