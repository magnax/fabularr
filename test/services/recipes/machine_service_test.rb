# frozen_string_literal: true

require 'test_helper'

class RecipesMachineServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(id)
    Recipes::MachineService.call(@character, id)
  end

  test 'raises error when invalid machine' do
    assert_raises Recipes::MachineService::InvalidMachineError do
      call_service(0)
    end
  end

  test 'raises error when machine is in use' do
    pit = create(:machinery, key: Machinery::SMALL_FIRE_PIT)
    machine = create(:location_object, subject: pit)
    project = create(:project, location: @character.location)
    create(:project_description, :machine, subject: machine, project: project)

    assert_raises Recipes::MachineService::MachineInUseError do
      call_service(machine.id)
    end
  end

  test 'works' do
    pit = create(:machinery, key: Machinery::SMALL_FIRE_PIT)
    machine = create(:location_object, subject: pit)

    res = call_service(machine.id)

    assert_equal machine.id, res[:machine_id]
  end
end
