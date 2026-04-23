# frozen_string_literal: true

require 'test_helper'
class ProjectsCreateLocationEndServiceTest < ActiveSupport::TestCase
  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test '#create_location creates new location' do
    location_type = create(:location_type, key: 'tundra')
    Maps.expects(:location_type).with(300, 200).returns(location_type)
    starting_character = create(:character, location: nil,
                                            coords: { x: 300, y: 200 })
    create(:traveller, subject: starting_character, speed: 0)
    project = create(:project, :create_location,
                     location: nil, starting_character: starting_character)
    create(:project_description, description_type: ProjectDescription::LOCATION, project: project)
    worker = create(:worker, project: project, character: starting_character)
    assert_nil worker.left_at

    assert_difference -> { Location.count } => 1,
                      -> { Traveller.count } => -1,
                      -> { Event.count } => 1,
                      -> { ProjectDescription.count } => 0 do
      call_service(project.id)
    end

    location = Location.last
    assert_equal 'town', location.location_class.key
    assert_equal 'tundra', location.location_type.key
    assert_equal [300, 200], location.coords.to_a
    assert_equal location.id, starting_character.reload.location_id
    assert_not starting_character.travelling?

    assert_not_nil worker.reload.left_at
    assert_equal location.id, project.project_descriptions.sole.subject_id

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_equal "New location (#{location.location_type.key}) is successfully created", event.body
  end
end
