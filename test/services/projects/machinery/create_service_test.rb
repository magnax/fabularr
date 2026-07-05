# frozen_string_literal: true

require 'test_helper'

class ProjectsMachineryCreateServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
    @project_type = create(:project_type, key: ProjectType::MACHINERY)

    @pit = create(:machinery, key: 'small_fire_pit')
    @machine = create(:location_object, subject: @pit, location: @location)

    @meat = create(:resource, :raw_food, key: 'meat')
    @dung = create(:resource, :raw_resource, key: 'dried_dung')
    @grilled_meat = create(:resource, :food, key: 'grilled_meat')
  end

  def call_service(params)
    Projects::CreateService.call(
      @character, params.merge(project_type_id: @project_type.id)
    )
  end

  def create_recipe!
    @recipe = create(:recipe, key: 'grilled_meat_dung', recipe_type: Recipe::GRILLING)
    create(:recipe_instruction, recipe: @recipe, subject: @meat, amount: 250)
    create(:recipe_instruction, recipe: @recipe, subject: @dung, amount: 150)
    create(:recipe_instruction, :resource_out, recipe: @recipe,
                                               subject: @grilled_meat, amount: 225)
    create(:recipe_instruction, :machinery, recipe: @recipe, subject: @pit)
    create(:recipe_instruction, :max_amount, recipe: @recipe, subject: nil, amount: 18_000)
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
    params = {
      machine_id: @machine.id,
      recipe_id: 0
    }

    assert_raises Projects::RecipeNotFoundError do
      call_service(params)
    end
  end

  test 'creates project' do
    create_recipe!

    params = {
      machine_id: @machine.id,
      recipe_id: @recipe.id,
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

    desc = ProjectDescription.find_by(subject_id: @meat.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 112, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.find_by(subject_id: @dung.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 67, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.find_by(subject_id: @grilled_meat.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_OUT, desc.description_type
    assert_equal 100, desc.amount
    assert_nil desc.amount_needed
    assert_equal 'grams', desc.unit

    event = Event.last
    assert_equal "You're starting new project: grilling meat.", event.body
  end

  test 'resource allocation - use all that character has' do
    create_recipe!

    create(:inventory_object, character: @character, subject: @meat, amount: 20)
    create(:inventory_object, character: @character, subject: @dung, amount: 200)

    params = {
      amount: 100,
      machine_id: @machine.id,
      recipe_id: @recipe.id,
      resource_allocation: 'regardless'
    }

    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 3,
                      -> { Event.count } => 3,
                      -> { InventoryObject.count } => -1 do
      call_service(params)
    end

    project = Project.last

    assert_equal ProjectType::MACHINERY, project.project_type.key
    assert_equal 38_400, project.duration
    assert_equal 0, project.elapsed
    assert_not project.ready
    assert_equal @location, project.location

    desc = ProjectDescription.find_by(subject_id: @meat.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 20, desc.amount
    assert_equal 112, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.find_by(subject_id: @dung.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 67, desc.amount
    assert_equal 67, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.find_by(subject_id: @grilled_meat.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_OUT, desc.description_type
    assert_equal 100, desc.amount
    assert_nil desc.amount_needed
    assert_equal 'grams', desc.unit

    assert_equal 1, @character.reload.inventory_objects.length

    inv_object = @character.inventory_objects.sole
    assert_equal 133, inv_object.amount
    assert_equal @dung, inv_object.subject

    event_bodies = Event.all.pluck(:body)

    assert_includes event_bodies, "You're starting new project: grilling meat."
    assert_includes event_bodies, 'You added 67 grams of dried dung to project grilling meat.'
    assert_includes event_bodies, 'You added 20 grams of meat to project grilling meat.'
  end

  test 'resource allocation - use nothing when allocation is full' do
    create_recipe!

    create(:inventory_object, character: @character, subject: @meat, amount: 20)
    create(:inventory_object, character: @character, subject: @dung, amount: 200)

    params = {
      amount: 100,
      machine_id: @machine.id,
      recipe_id: @recipe.id,
      resource_allocation: 'full'
    }

    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 3,
                      -> { Event.count } => 1,
                      -> { InventoryObject.count } => 0 do
      call_service(params)
    end

    project = Project.last

    assert_equal ProjectType::MACHINERY, project.project_type.key
    assert_equal 38_400, project.duration
    assert_equal 0, project.elapsed
    assert_not project.ready
    assert_equal @location, project.location

    desc = ProjectDescription.find_by(subject_id: @meat.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 112, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.find_by(subject_id: @dung.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 67, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.find_by(subject_id: @grilled_meat.id)
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_OUT, desc.description_type
    assert_equal 100, desc.amount
    assert_nil desc.amount_needed
    assert_equal 'grams', desc.unit

    assert_equal 2, @character.reload.inventory_objects.length
  end
end
