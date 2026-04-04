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
#  recipe_id             :bigint
#  starting_character_id :integer
#
# Indexes
#
#  index_projects_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
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

  test 'name for project - discovering resources' do
    character = create(:character)
    project = create(:project, :discover_resource, starting_character: character)

    assert_equal 'Discovering new resources', project.short_name
  end
end
