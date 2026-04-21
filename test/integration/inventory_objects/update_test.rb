# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, location: @location, user: @user)
    login(@user, @character)
  end

  test 'update project' do
    stone = create(:resource, key: 'stone')
    create(:location_object, location: @location,
                             subject: stone, amount: 100)
    project = create(:project, location: @character.location)
    create(:project_description, :resource_in, subject: stone, amount_needed: 1000, amount: 100, project: project)
    inv_object = create(:inventory_object, character: @character,
                                           subject: stone, amount: 200)

    params = {
      subject_id: stone.id,
      subject_type: 'Resource',
      amount: '50',
      project_id: project.id
    }

    put "/inventory_objects/#{inv_object.id}", params: params

    assert_response :found

    assert_redirected_to '/en/events'
  end

  test 'invalid form data' do
    stone = create(:resource, key: 'stone')
    inv_object = create(:inventory_object, character: @character,
                                           subject: stone, amount: 200)

    params = {
      subject_id: stone.id,
      subject_type: 'Resource',
      amount: '50',
      project_id: 0
    }

    put "/inventory_objects/#{inv_object.id}", params: params

    assert_response :found

    assert_redirected_to '/?locale=en'
  end
end
