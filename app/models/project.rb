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
class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :starting_character, optional: false, class_name: 'Character'
  belongs_to :project_type

  has_many :workers, dependent: :destroy
  has_many :project_descriptions, dependent: :destroy

  scope :pending, -> { where('elapsed < duration') }

  DISPATCH_SERVICE = {
    'build' => 'Build',
    'collect' => 'Collect',
    'discover_resource' => 'DiscoverResource'
  }.freeze

  def name(for_character)
    type_name = I18n.t("projects.name.#{project_type.key}")
    char_name = for_character.name_for(starting_character)
    "#{type_name.titleize}, #{I18n.t('projects.name.started_by')}#{char_name}"
  end
end
