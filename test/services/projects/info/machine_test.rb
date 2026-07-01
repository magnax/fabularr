# frozen_string_literal: true

require 'test_helper'

class ProjectsInfoMachineTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @project_type = create(:project_type, key: ProjectType::MACHINERY)
  end

  def call_service(params)
    Projects::Info::Machine.call(@character,
                                 { type: 'machine' }.merge(params))
  end

  test 'invalid machine' do
    assert_raises Projects::Info::Machine::InvalidMachineError do
      call_service(project: { machine_id: 0 })
    end
  end

  test 'invalid recipe' do
    pit = create(:machinery, key: 'small_fire_pit')
    machine = create(:location_object, subject: pit, location: @character.location)

    params = {
      project: { machine_id: machine.id },
      recipe_id: 0
    }

    assert_raises Projects::Info::Machine::InvalidRecipeError do
      call_service(params)
    end
  end
end
