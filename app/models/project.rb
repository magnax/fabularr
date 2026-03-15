# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :starting_character, optional: false, class_name: 'Character'
  belongs_to :project_type

  has_many :workers, dependent: :destroy
  has_many :project_descriptions, dependent: :destroy

  scope :pending, -> { where('elapsed < duration') }

  DISPATCH_SERVICE = {
    'discover_resource' => 'DiscoverResource',
    'collect' => 'Collect'
  }.freeze

  def name(for_character)
    type_name = I18n.t("projects.name.#{project_type.key}")
    char_name = for_character.name_for(starting_character)
    "#{type_name.titleize}, #{I18n.t('projects.name.started_by')}#{char_name}"
  end
end
