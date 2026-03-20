# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                    :bigint           not null, primary key
#  amount                :integer
#  checked_at            :datetime
#  duration              :integer          default(0)
#  elapsed               :integer          default(0)
#  ready                 :boolean          default(FALSE)
#  unit                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  location_id           :integer
#  project_type_id       :integer
#  starting_character_id :integer
#
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
