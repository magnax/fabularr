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
    'create_location' => 'CreateLocation',
    'discover_resource' => 'DiscoverResource',
    'item' => 'Build',
    'road' => 'BuildRoad',
    'vehicle' => 'Vehicle'
  }.freeze

  def name(character, short: false)
    name = if project_type.key == ProjectType::ROAD
             Projects::NameService.call(self, character)
           else
             short_name
           end
    return name if short

    char_name = character.name_for(starting_character)
    "#{name}, #{I18n.t('projects.name.started_by')}#{char_name}"
  end

  def short_name
    case project_type.key
    when ProjectType::BUILD
      return base_type_name unless recipe

      item_name = I18n.t("#{recipe.recipe_type.pluralize}.#{recipe.key}")
      case recipe.recipe_type
      when Recipe::BUILDING
        "#{I18n.t('projects.name.start_building')} (#{item_name})"
      when Recipe::MACHINERY
        "#{I18n.t("views.skills.#{recipe.skill.key}")} #{item_name}"

      when Recipe::VEHICLE
        "#{I18n.t('projects.name.start_vehicle')} (#{item_name})"
      else
        "#{base_type_name}: #{item_name}"
      end
    when ProjectType::DISCOVER_RESOURCE, ProjectType::CREATE_LOCATION
      base_type_name
    when ProjectType::COLLECT
      skill = I18n.t("views.skills.#{project_descriptions.resource_out.last.subject.skill.key}")
      res = I18n.td("resources.#{project_descriptions.resource_out.last.subject.key}")
      "#{skill} #{res}"
    end
  end

  def base_type_name
    I18n.t("projects.name.#{project_type.key}").capitalize
  end

  def settings
    project_descriptions.settings.first&.metadata || {}
  end

  def progress(precision = 1)
    (elapsed.to_f / duration * 100.0).round(precision)
  end

  def skill
    if project_type.exploring?
      return Skill.where(key: Skill::EXPLORING).first_or_create
    elsif project_type.key == ProjectType::ROAD
      return Skill.where(key: Skill::BUILDING).first_or_create
    elsif project_type.key == ProjectType::COLLECT
      return project_descriptions.resource_out.first.subject.skill
    elsif recipe.present? && recipe.skill.present?
      return recipe.skill
    end

    nil
  end
end
