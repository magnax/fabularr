# frozen_string_literal: true

require 'test_helper'

class Projects::EndServiceTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  def call_service(project_id)
    Projects::EndService.call(project_id)
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
      "char_#{starting_character.id}",
      type: 'event',
      event_id: Event.where(receiver_character_id: starting_character.id).last.id
    )
  end
end
