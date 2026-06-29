# frozen_string_literal: true

require 'test_helper'

class ProjectsMachineryEndServiceTest < ActiveSupport::TestCase
  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test '#build creates manufactured item in location' do
    location = create(:location)

    pit = create(:machinery, key: 'small_fire_pit')
    recipe = create(:recipe, :machinery, key: 'small_fire_pit')
    create(:recipe_instruction, recipe: recipe,
                                instruction_type: 'machinery', subject: pit, amount: 100)

    starting_character = create(:character, location: location)
    project = create(:project, :build, location: location,
                                       starting_character: starting_character,
                                       recipe: recipe)
    create(:project_description, project: project, subject: pit, amount: 1,
                                 unit: 'grams')
    create(:worker, project: project, character: starting_character)

    assert_difference -> { LocationObject.count }, 1 do
      call_service(project.id)
    end

    loc_object = location.reload.location_objects.sole
    assert_equal 'Machinery', loc_object.subject_type
    assert_equal recipe.key, loc_object.subject.key

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_match(/Project started by you has just ended. Manufactured: small fire pit/, event.body)
  end
end
