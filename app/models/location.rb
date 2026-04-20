# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id                 :integer          not null, primary key
#  coords             :point
#  max_capacity       :integer
#  max_characters     :integer
#  name               :string
#  created_at         :datetime
#  updated_at         :datetime
#  location_class_id  :bigint
#  location_type_id   :integer
#  parent_location_id :integer
#
# Indexes
#
#  index_locations_on_location_class_id  (location_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_class_id => location_classes.id)
#
class Location < ApplicationRecord
  delegate :x, :y, to: :coords

  has_many :characters, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :location_names, dependent: :destroy
  has_many :location_objects, dependent: :destroy
  has_many :location_resources, dependent: :destroy
  has_many :resources, through: :location_resources
  has_many :projects, dependent: :destroy
  has_many :workers, through: :projects
  has_many :buildings, dependent: :destroy,
                       class_name: 'Building',
                       inverse_of: :parent_location

  belongs_to :location_type
  belongs_to :location_class
  belongs_to :parent_location, optional: true, class_name: 'Location'

  scope :random, -> { order('RANDOM()').limit(1) }

  def visible_characters
    # not final implementation, there will be probably some refinement to
    # distinguish between visible and hearable characters
    # (ie. inside/outside locations)
    characters
  end

  def town?
    location_class.key == 'town'
  end

  def display_name(character, parent: false)
    parent_name = parent && parent_location.present? ? parent_location.display_name(character) : nil
    remembered_name = location_name(character)&.name || default_name
    return remembered_name unless parent && parent_location.present?

    "#{parent_name} (#{remembered_name})"
  end

  def default_name
    return I18n.t('locations.unnamed_place') if town?

    name || I18n.t("locations.#{location_type.key}")
  end

  def location_name_or_build(character)
    location_names.where(character: character).first ||
      location_names.build(character: character, name: default_name)
  end

  def location_name(character)
    location_names.where(character: character).first
  end

  def loc_id
    "<!--LOCID:#{id}-->"
  end
end
