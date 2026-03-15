require 'test_helper'

class Projects::AddFromInventoryServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(params)
    Projects::AddFromInventoryService.call(@character, params)
  end

  test 'adds resource to project' do
    project = create(:project, location: @character.location)
    stone = create(:resource)
    inventory_object = create(:inventory_object, character: @character, subject: stone, amount: 100)
    project_description = create(:project_description,
                                 :resource_in, project: project,
                                               subject: stone, amount: 0, amount_needed: 100)

    params = {
      amount: '60',
      project_id: project.id,
      subject_id: stone.id,
      subject_type: 'Resource'
    }

    call_service(params)

    assert_equal 60, project_description.reload.amount
    assert_equal 40, inventory_object.reload.amount
    assert_not project.reload.ready
  end

  test 'adds resource to project - all what is needed' do
    project = create(:project, location: @character.location)
    stone = create(:resource)
    inventory_object = create(:inventory_object, character: @character, subject: stone, amount: 200)
    project_description = create(:project_description,
                                 :resource_in, project: project,
                                               subject: stone, amount: 0, amount_needed: 100)

    params = {
      amount: '100',
      project_id: project.id,
      subject_id: stone.id,
      subject_type: 'Resource'
    }

    call_service(params)

    assert_equal 100, project_description.reload.amount
    assert_equal 100, inventory_object.reload.amount
    assert project.reload.ready
  end
end
