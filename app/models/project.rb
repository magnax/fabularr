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
  scope :completed, -> { where('elapsed = duration') }

  DISPATCH_SERVICE = {
    'build' => 'Build',
    'building' => 'Building',
    'collect' => 'Collect',
    'create_location' => 'CreateLocation',
    'discover_resource' => 'DiscoverResource',
    'item' => 'Build',
    'machinery' => 'Machinery',
    'road' => 'BuildRoad',
    'vehicle' => 'Vehicle'
  }.freeze

  def pending?
    elapsed < duration
  end

  def active?
    workers.active.any?
  end

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
      build_type_name
    when ProjectType::DISCOVER_RESOURCE, ProjectType::CREATE_LOCATION
      base_type_name
    when ProjectType::COLLECT
      skill = I18n.t("views.skills.#{resource_out_skill.key}")
      res = I18n.td("resources.#{resource_out_subject.key}")
      "#{skill} #{res}"
    when ProjectType::MACHINERY
      I18n.td(
        "views.project_descriptions.#{resource_out_subject.key}"
      )
    end
  end

  def build_type_name
    return base_type_name unless recipe

    case recipe.recipe_type
    when Recipe::BUILDING
      "#{I18n.t('projects.name.start_building')} (#{recipe_item_name})"
    when Recipe::MACHINERY
      "#{I18n.t("views.skills.#{recipe.skill.key}")} #{recipe_item_name}"
    when Recipe::VEHICLE
      "#{I18n.t('projects.name.start_vehicle')} (#{recipe_item_name})"
    else
      "#{base_type_name}: #{recipe_item_name}"
    end
  end

  def recipe_item_name
    I18n.t("#{recipe.recipe_type.pluralize}.#{recipe.key}")
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
    return recipe.skill if recipe&.skill.present?

    if project_type.exploring?
      return Skill.where(key: Skill::EXPLORING).first_or_create
    elsif project_type.road?
      return Skill.where(key: Skill::BUILDING).first_or_create
    elsif project_type.collect?
      return resource_out_skill
    end

    nil
  end

  def resource_out_skill
    project_descriptions.resource_out.first.subject.skill
  end

  def resource_out_subject
    project_descriptions.resource_out.last.subject
  end
end
