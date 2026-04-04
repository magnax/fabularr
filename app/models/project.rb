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
class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :starting_character, optional: false, class_name: 'Character'
  belongs_to :project_type
  belongs_to :recipe, optional: true

  has_many :workers, dependent: :destroy
  has_many :project_descriptions, dependent: :destroy

  scope :pending, -> { where('elapsed < duration') }

  DISPATCH_SERVICE = {
    'build' => 'Build',
    'building' => 'Building',
    'collect' => 'Collect',
    'discover_resource' => 'DiscoverResource'
  }.freeze

  def name(for_character)
    char_name = for_character.name_for(starting_character)
    "#{short_name}, #{I18n.t('projects.name.started_by')}#{char_name}"
  end

  def short_name
    type_name = I18n.t("projects.name.#{project_type.key}").capitalize
    case project_type.key
    when ProjectType::BUILD
      return type_name unless recipe

      case recipe.recipe_type
      when 'build'
        tool_name = I18n.t("items.#{recipe.key}")
        "#{type_name}: #{tool_name}"
      when 'building'
        tool_name = I18n.t("buildings.#{recipe.key}")
        "#{type_name}: #{tool_name}"
      end
    when ProjectType::DISCOVER_RESOURCE
      type_name
    end
  end

  def settings
    project_descriptions.settings.first&.metadata || {}
  end
end
