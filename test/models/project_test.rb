# frozen_string_literal: true

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'proper #name for project' do
    character = create(:character)
    second_character = create(:character)
    create(:char_name, character: second_character, named: character, name: 'Magnus')
    project_type = create(:project_type, key: 'build')
    project = create(:project, starting_character: character, project_type: project_type)

    name = project.name(second_character)

    assert_equal 'Building, started by: Magnus', name
  end
end
