# frozen_string_literal: true

require 'test_helper'

class ProjectsMachineryCreateServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @current_character = create(:character, location: @location)
    @project_type = create(:project_type, key: ProjectType::MACHINERY)
  end

  def call_service(params)
    Projects::CreateService.call(
      @current_character, params.merge(project_type_id: @project_type.id)
    )
  end

  test 'raises invalid machine exception' do
    params = {
      machine_id: 0
    }

    assert_raises Projects::InvalidMachineError do
      call_service(params)
    end
  end

  test 'raises invalid recipe exception' do
    pit = create(:machinery, key: 'small_fire_pit')
    machine = create(:location_object, subject: pit, location: @location)

    params = {
      machine_id: machine.id,
      recipe_id: 0
    }

    assert_raises Projects::RecipeNotFoundError do
      call_service(params)
    end
  end

  test 'creates project' do
    pit = create(:machinery, key: 'small_fire_pit')
    machine = create(:location_object, subject: pit, location: @location)

    meat = create(:resource, :raw_food, key: 'meat')
    dung = create(:resource, :raw_resource, key: 'dried_dung')
    grilled_meat = create(:resource, :food, key: 'grilled_meat')
    recipe = create(:recipe, key: 'grilled_meat_dung', recipe_type: Recipe::GRILLING)
    create(:recipe_instruction, recipe: recipe, subject: meat, amount: 250)
    create(:recipe_instruction, recipe: recipe, subject: dung, amount: 150)
    create(:recipe_instruction, :resource_out, recipe: recipe,
                                               subject: grilled_meat, amount: 225)
    create(:recipe_instruction, :machinery, recipe: recipe, subject: pit)
    create(:recipe_instruction, :max_amount, recipe: recipe, subject: nil, amount: 18_000)

    params = {
      machine_id: machine.id,
      recipe_id: recipe.id,
      amount: 100
    }

    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 3 do
      call_service(params)
    end

    project = Project.last

    assert_equal ProjectType::MACHINERY, project.project_type.key
    assert_equal 38_400, project.duration
    assert_equal 0, project.elapsed
    assert_not project.ready
    assert_equal @location, project.location

    desc = ProjectDescription.find_by(subject_id: meat.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 112, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.find_by(subject_id: dung.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 67, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.find_by(subject_id: grilled_meat.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_OUT, desc.description_type
    assert_equal 100, desc.amount
    assert_nil desc.amount_needed
    assert_equal 'grams', desc.unit

    event = Event.last
    assert_equal "You're starting new project: grilling meat.", event.body
  end

  test 'collect resource, repeating project' do
    strawberry = create(:resource, :raw_food, key: 'strawberries', daily_rate: 600)
    location_resource = create(:location_resource, location: @location,
                                                   resource: strawberry)

    params = {
      location_resource_id: location_resource.id,
      amount: 600,
      repeat: 3
    }

    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 2 do
      call_service(params)
    end

    project = Project.last

    assert_equal 'collect', project.project_type.key
    assert_equal 86_400, project.duration
    assert_equal 0, project.elapsed
    assert project.ready

    desc = ProjectDescription.where(
      description_type: ProjectDescription::RESOURCE_OUT
    ).sole
    assert_equal strawberry.id, desc.subject_id
    assert_equal 'Resource', desc.subject_type
    assert_equal 0, desc.amount
    assert_equal 600, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.where(
      description_type: ProjectDescription::REPEAT
    ).sole
    assert_equal 3, desc.amount

    event = Event.last
    assert_equal "You're starting new project: collecting strawberries.", event.body
  end
end
