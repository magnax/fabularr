# frozen_string_literal: true

require 'test_helper'

class Projects::AddResourceFormTest < ActiveSupport::TestCase
  def init_form(character_id, params)
    f = Projects::AddResourceForm.new(character_id: character_id)
    f.assign_attributes(**params)
    f
  end

  test 'error - character not provided' do
    form = Projects::AddResourceForm.new
    assert_not form.valid?

    assert_equal 5, form.errors.count
    assert_equal(2, form.errors.select { |e| e.attribute == :character_id }.length)
  end

  test 'error - non existing character' do
    form = Projects::AddResourceForm.new(character_id: 0)
    assert_not form.valid?

    assert_equal 4, form.errors.count
    assert_equal(1, form.errors.select { |e| e.attribute == :character_id }.length)
  end

  test 'error - non existing project' do
    character = create(:character)
    stone = create(:resource)
    create(:inventory_object, character: character, subject: stone, amount: 100)

    params = {
      amount: '200',
      project_id: 0,
      subject_id: stone.id,
      subject_type: 'Resource'
    }

    form = init_form(character.id, params)

    assert_not form.valid?

    errors = form.errors
    assert_equal :invalid, errors.sole.type
    assert_equal :project_id, errors.sole.attribute
  end

  test 'error - project not visible for user (different location)' do
    character = create(:character)
    project = create(:project)
    stone = create(:resource)
    create(:inventory_object, character: character, subject: stone, amount: 100)

    params = {
      amount: '200',
      project_id: project.id,
      subject_id: stone.id,
      subject_type: 'Resource'
    }

    form = init_form(character.id, params)

    assert_not form.valid?

    errors = form.errors
    assert_equal :invalid, errors.sole.type
    assert_equal :project_id, errors.sole.attribute
  end

  test 'error - invalid resource' do
    character = create(:character)
    project = create(:project, location: character.location)

    params = {
      amount: '200',
      project_id: project.id,
      subject_id: 0,
      subject_type: 'Resource'
    }

    form = init_form(character.id, params)

    assert_not form.valid?

    errors = form.errors
    assert_equal :invalid, errors.sole.type
    assert_equal :subject_id, errors.sole.attribute
  end

  test 'error - not resource' do
    character = create(:character)
    project = create(:project, location: character.location)
    stone = create(:resource)

    params = {
      amount: '200',
      project_id: project.id,
      subject_id: stone.id,
      subject_type: 'Item'
    }

    form = init_form(character.id, params)

    assert_not form.valid?

    errors = form.errors
    assert_equal :invalid, errors.sole.type
    assert_equal :subject_type, errors.sole.attribute
  end

  test 'error - character does not have the resource' do
    character = create(:character)
    project = create(:project, location: character.location)
    stone = create(:resource)

    params = {
      amount: '200',
      project_id: project.id,
      subject_id: stone.id,
      subject_type: 'Resource'
    }

    form = init_form(character.id, params)

    assert_not form.valid?

    errors = form.errors
    assert_equal :invalid, errors.sole.type
    assert_equal :subject_id, errors.sole.attribute
  end

  test 'error - project does not need this resource' do
    character = create(:character)
    project = create(:project, location: character.location)
    stone = create(:resource)
    create(:inventory_object, character: character, subject: stone, amount: 100)

    params = {
      amount: '200',
      project_id: project.id,
      subject_id: stone.id,
      subject_type: 'Resource'
    }

    form = init_form(character.id, params)

    assert_not form.valid?

    errors = form.errors
    assert_equal :does_not_need_resource, errors.sole.type
    assert_equal :project_id, errors.sole.attribute
  end

  test 'error - project does not need this resource anymore - all added' do
    character = create(:character)
    project = create(:project, location: character.location)
    stone = create(:resource)
    create(:inventory_object, character: character, subject: stone, amount: 100)
    create(:project_description, :resource_in, project: project,
                                               subject: stone, amount: 100, amount_needed: 100)

    params = {
      amount: '200',
      project_id: project.id,
      subject_id: stone.id,
      subject_type: 'Resource'
    }

    form = init_form(character.id, params)

    assert_not form.valid?

    errors = form.errors
    assert_equal :does_not_need_resource, errors.sole.type
    assert_equal :project_id, errors.sole.attribute
  end

  test 'valid form' do
    character = create(:character)
    project = create(:project, location: character.location)
    stone = create(:resource)
    create(:inventory_object, character: character, subject: stone, amount: 100)
    create(:project_description, :resource_in, project: project,
                                               subject: stone, amount: 50, amount_needed: 100)

    params = {
      amount: '50',
      project_id: project.id,
      subject_id: stone.id,
      subject_type: 'Resource'
    }

    form = init_form(character.id, params)

    assert form.valid?
  end
end
